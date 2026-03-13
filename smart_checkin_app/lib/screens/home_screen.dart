import 'package:flutter/material.dart';
import 'checkin_screen.dart';
import 'finish_class_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Class Check-in'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckinScreen()),
                );
              },
              child: const Text('Check-in'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FinishClassScreen()),
                );
              },
              child: const Text('Finish Class'),
            ),
          ],
        ),
      ),
    );
  }
}
