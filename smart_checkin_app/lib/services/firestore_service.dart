import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/checkin_record.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveCheckinRecord(CheckinRecord record) async {
    await _db.collection('checkins').add(record.toMap());
  }

  Future<void> saveFinishClassRecord(CheckinRecord record) async {
    await _db.collection('finish_class').add(record.toMap());
  }
}
