import 'package:flutter/material.dart';

import '../models/checkin_record.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import '../services/qr_service.dart';

class FinishClassScreen extends StatefulWidget {
  const FinishClassScreen({super.key});

  @override
  State<FinishClassScreen> createState() => _FinishClassScreenState();
}

class _FinishClassScreenState extends State<FinishClassScreen> {
  final QrService _qrService = QrService();
  final LocationService _locationService = LocationService();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isSubmitting = false;
  final TextEditingController _learnedTodayController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  String? sessionToken;
  double? latitude;
  double? longitude;
  bool _isScanning = false;
  bool _isLoadingLocation = false;

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
        previousTopic: '',
        expectedTopic: '',
        mood: 0,
        learnedToday: _learnedTodayController.text,
        feedback: _feedbackController.text,
      );

      await _firestoreService.saveFinishClassRecord(record);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reflection saved to Firestore!')),
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
    _learnedTodayController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationText = latitude == null || longitude == null
        ? 'Location not retrieved'
        : 'Lat: ${latitude!.toStringAsFixed(6)}, Lng: ${longitude!.toStringAsFixed(6)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finish Class'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isScanning ? null : _scanQrCode,
              child: Text(_isScanning ? 'Scanning...' : 'Scan QR Code'),
            ),
            const SizedBox(height: 8),
            Text(
              'Session Token: ${sessionToken ?? 'Not scanned yet'}',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              child: Text(
                _isLoadingLocation ? 'Getting Location...' : 'Get GPS Location',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              locationText,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _learnedTodayController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'What did you learn today?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Feedback about the class or instructor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _isSubmitting ? 'Saving...' : 'Submit Reflection',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
