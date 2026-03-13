import 'package:flutter/material.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  String _sessionToken = 'Not scanned yet';
  String _location = 'Location not retrieved';
  final TextEditingController _previousTopicController = TextEditingController();
  final TextEditingController _expectedTopicController = TextEditingController();
  int _mood = 3;

  final List<String> _moodEmojis = ['😡', '🙁', '😐', '🙂', '😄'];

  void _simulateScan() {
    setState(() {
      _sessionToken = 'SESSION-2026-ABC123';
    });
  }

  void _simulateLocation() {
    setState(() {
      _location = 'Lat: 13.7563, Lng: 100.5018';
    });
  }

  void _submit() {
    debugPrint('--- Check-in Submitted ---');
    debugPrint('Session Token: $_sessionToken');
    debugPrint('Location: $_location');
    debugPrint('Previous Topic: ${_previousTopicController.text}');
    debugPrint('Expected Topic: ${_expectedTopicController.text}');
    debugPrint('Mood: $_mood (${_moodEmojis[_mood - 1]})');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Check-in submitted! Check the console.')),
    );
  }

  @override
  void dispose() {
    _previousTopicController.dispose();
    _expectedTopicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: _simulateScan,
              child: const Text('Scan QR Code'),
            ),
            const SizedBox(height: 8),
            Text('Session Token: $_sessionToken',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),

            const SizedBox(height: 16),

            // GPS Section
            ElevatedButton(
              onPressed: _simulateLocation,
              child: const Text('Get GPS Location'),
            ),
            const SizedBox(height: 8),
            Text(_location,
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
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Submit Check-in',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
