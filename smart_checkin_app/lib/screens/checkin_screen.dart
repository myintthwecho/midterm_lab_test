import 'package:flutter/material.dart';

import '../models/checkin_record.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import '../services/qr_service.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  final QrService _qrService = QrService();
  final LocationService _locationService = LocationService();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isSubmitting = false;
  final TextEditingController _previousTopicController = TextEditingController();
  final TextEditingController _expectedTopicController = TextEditingController();
  int _mood = 3;
  String? sessionToken;
  double? latitude;
  double? longitude;
  bool _isScanning = false;
  bool _isLoadingLocation = false;

  final List<String> _moodEmojis = ['😡', '🙁', '😐', '🙂', '😄'];

  Future<void> _scanQrCode() async {
    setState(() {
      _isScanning = true;
    });

    try {
      final scannedToken = await _qrService.scanQrCode(context);
      if (!mounted || scannedToken == null) {
        return;
      }

      setState(() {
        sessionToken = scannedToken;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR scan failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final locationResult = await _locationService.getCurrentLocation();
      if (!mounted) {
        return;
      }

      setState(() {
        latitude = locationResult.latitude;
        longitude = locationResult.longitude;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (sessionToken == null || latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please scan QR code and get location first.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final record = CheckinRecord(
        studentId: 'student_001',
        sessionToken: sessionToken!,
        latitude: latitude!,
        longitude: longitude!,
        timestamp: DateTime.now(),
        previousTopic: _previousTopicController.text,
        expectedTopic: _expectedTopicController.text,
        mood: _mood,
        learnedToday: '',
        feedback: '',
      );

      await _firestoreService.saveCheckinRecord(record);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in saved to Firestore!')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _previousTopicController.dispose();
    _expectedTopicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationText = latitude == null || longitude == null
        ? 'Location not retrieved'
        : 'Lat: ${latitude!.toStringAsFixed(6)}, Lng: ${longitude!.toStringAsFixed(6)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // QR Section
            ElevatedButton(
              onPressed: _isScanning ? null : _scanQrCode,
              child: Text(_isScanning ? 'Scanning...' : 'Scan QR Code'),
            ),
            const SizedBox(height: 8),
            Text('Session Token: ${sessionToken ?? 'Not scanned yet'}',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),

            const SizedBox(height: 16),

            // GPS Section
            ElevatedButton(
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              child: Text(
                _isLoadingLocation ? 'Getting Location...' : 'Get GPS Location',
              ),
            ),
            const SizedBox(height: 8),
            Text(locationText,
                style: const TextStyle(fontSize: 13, color: Colors.grey)),

            const SizedBox(height: 24),

            // Previous topic
            TextField(
              controller: _previousTopicController,
              decoration: const InputDecoration(
                labelText: 'Previous class topic',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Expected topic
            TextField(
              controller: _expectedTopicController,
              decoration: const InputDecoration(
                labelText: 'Expected topic today',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Mood selector
            const Text('Mood before class:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final value = index + 1;
                return GestureDetector(
                  onTap: () => setState(() => _mood = value),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _mood == value
                          ? Colors.deepPurple.shade100
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _mood == value
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(_moodEmojis[index],
                            style: const TextStyle(fontSize: 28)),
                        Text('$value',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            // Submit
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(_isSubmitting ? 'Saving...' : 'Submit Check-in',
                  style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
