import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to the patients collection
  CollectionReference get patients => _firestore.collection('patients');

  // Get a specific patient document
  DocumentReference patientDoc(String email) => patients.doc(email);

  // Get reminders subcollection for a patient
  CollectionReference reminders(String email) =>
      patientDoc(email).collection('reminders');

  // Add/Update a reminder
  Future<void> setReminder({
    required String patientEmail,
    required String reminderId,
    required Map<String, dynamic> data,
  }) async {
    await reminders(patientEmail).doc(reminderId).set(data);
  }

  // Get all reminders for a patient
  Stream<QuerySnapshot> getReminders(String patientEmail) {
    return reminders(patientEmail).snapshots();
  }

  // Delete a reminder
  Future<void> deleteReminder({
    required String patientEmail,
    required String reminderId,
  }) async {
    await reminders(patientEmail).doc(reminderId).delete();
  }
}