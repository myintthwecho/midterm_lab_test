import 'package:flutter/material.dart';

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

  void _submit() {
    debugPrint('--- Finish Class Submitted ---');
    debugPrint('Session Token: ${sessionToken ?? 'Not scanned yet'}');
    debugPrint('Latitude: ${latitude?.toStringAsFixed(6) ?? 'Not available'}');
    debugPrint('Longitude: ${longitude?.toStringAsFixed(6) ?? 'Not available'}');
    debugPrint('Learned Today: ${_learnedTodayController.text}');
    debugPrint('Feedback: ${_feedbackController.text}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reflection submitted. Check the console.')),
    );
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
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Submit Reflection',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
