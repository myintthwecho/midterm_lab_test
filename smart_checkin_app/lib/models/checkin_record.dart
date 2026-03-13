import 'package:cloud_firestore/cloud_firestore.dart';

class CheckinRecord {
  CheckinRecord({
    required this.studentId,
    required this.sessionToken,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.previousTopic,
    required this.expectedTopic,
    required this.mood,
    required this.learnedToday,
    required this.feedback,
  });

  final String studentId;
  final String sessionToken;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String previousTopic;
  final String expectedTopic;
  final int mood;
  final String learnedToday;
  final String feedback;

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'sessionToken': sessionToken,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': Timestamp.fromDate(timestamp),
      'previousTopic': previousTopic,
      'expectedTopic': expectedTopic,
      'mood': mood,
      'learnedToday': learnedToday,
      'feedback': feedback,
    };
  }

  factory CheckinRecord.fromMap(Map<String, dynamic> map) {
    return CheckinRecord(
      studentId: map['studentId'] as String? ?? '',
      sessionToken: map['sessionToken'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.tryParse(map['timestamp'] as String? ?? '') ?? DateTime.now(),
      previousTopic: map['previousTopic'] as String? ?? '',
      expectedTopic: map['expectedTopic'] as String? ?? '',
      mood: map['mood'] as int? ?? 0,
      learnedToday: map['learnedToday'] as String? ?? '',
      feedback: map['feedback'] as String? ?? '',
    );
  }
}
