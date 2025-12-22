import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../utils/constants/endpoints.dart';
import '../../../utils/constants/secrets.dart';
import '../../../utils/custom_helpers/cache_helper.dart';

class CareGiversController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? currentPatientId = CacheHelper().getDataString(key: ApiKey.email);

  Stream<QuerySnapshot> get pendingRequests {
    return _firestore
        .collection('pairing_requests')
        .where('patientId', isEqualTo: currentPatientId)
        .where('status', isEqualTo: 'pending')
        .where('apiToken', isEqualTo: AppSecrets.firestoreToken)
        .snapshots();
  }

  Future<void> respondToRequest(String requestId, String status) async {
    try {
      final requestDoc = await _firestore.collection('pairing_requests').doc(requestId).get();

      if (!requestDoc.exists) {
        throw Exception('Request not found');
      }

      final caregiverEmail = requestDoc.data()?['caregiverEmail'] as String?;
      if (caregiverEmail == null) {
        throw Exception('Caregiver email not found in request');
      }

      await _firestore.collection('pairing_requests').doc(requestId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
        'apiToken': AppSecrets.firestoreToken
      });

      if (status == 'approved') {
        await _firestore.collection('patients').doc(currentPatientId).update({
          'caregivers': FieldValue.arrayUnion([caregiverEmail])
        });
      }

      Get.snackbar('Success', status == 'approved'
          ? 'Caregiver approved successfully'
          : 'Request rejected');
    } catch (e) {
      Get.snackbar('Error', 'Failed to process request: ${e.toString()}');
    }
  }

  Stream<List<String>> get caregiversList {
    return _firestore.collection('patients')
        .doc(currentPatientId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null || data['caregivers'] == null) return [];
      return List<String>.from(data['caregivers']);
    });
  }

  Future<void> removeCaregiver(String caregiverEmail) async {
    try {
      await _firestore.collection('patients').doc(currentPatientId).update({
        'caregivers': FieldValue.arrayRemove([caregiverEmail])
      });

      final requests = await _firestore.collection('pairing_requests')
          .where('patientId', isEqualTo: currentPatientId)
          .where('caregiverEmail', isEqualTo: caregiverEmail)
          .where('status', isEqualTo: 'approved')
      .where('apiToken',isEqualTo: AppSecrets.firestoreToken)
          .get();

      for (var doc in requests.docs) {
        await doc.reference.update({
          'status': 'removed',
          'updatedAt': FieldValue.serverTimestamp(),
          'apiToken': AppSecrets.firestoreToken
        });
      }

      Get.snackbar('Success', '$caregiverEmail removed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove: ${e.toString()}');
    }
  }
}