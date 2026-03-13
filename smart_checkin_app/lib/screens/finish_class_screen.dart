import 'package:flutter/material.dart';

class FinishClassScreen extends StatefulWidget {
  const FinishClassScreen({super.key});

  @override
  State<FinishClassScreen> createState() => _FinishClassScreenState();
}

class _FinishClassScreenState extends State<FinishClassScreen> {
  String _sessionToken = 'Not scanned yet';
  String _location = 'Location not retrieved';
  final TextEditingController _learnedTodayController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  void _simulateScan() {
    setState(() {
      _sessionToken = 'SESSION-2026-END456';
    });
  }

  void _simulateLocation() {
    setState(() {
      _location = 'Lat: 13.7563, Lng: 100.5018';
    });
  }

  void _submit() {
    debugPrint('--- Finish Class Submitted ---');
    debugPrint('Session Token: $_sessionToken');
    debugPrint('Location: $_location');
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
  @override
  Widget build(BuildContext context) {
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
              onPressed: _simulateScan,
              child: const Text('Scan QR Code'),
            ),
            const SizedBox(height: 8),
            Text(
              'Session Token: $_sessionToken',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simulateLocation,
              child: const Text('Get GPS Location'),
            ),
            const SizedBox(height: 8),
            Text(
              _location,
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
