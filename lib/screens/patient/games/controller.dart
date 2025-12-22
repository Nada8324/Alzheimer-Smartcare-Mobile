import 'dart:math';

import 'package:alzheimer_smartcare/global_models/login_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../utils/custom_helpers/cache_helper.dart';
class PatientGameController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String patientId = CacheHelper().getData(key: "email") ?? "default_id";

  var highScore = 99999.obs;
  var isLoading = true.obs;
  var allScores = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadScores();
  }

  Future<void> _loadScores() async {
    try {
      isLoading.value = true;
      final doc = await _firestore.collection('patients').doc(patientId).get();

      if (doc.exists) {
        final data = doc.data()!;
        allScores.value = List<int>.from(data['memoryMatchScores'] ?? []);
        if (allScores.isNotEmpty) {
          highScore.value = allScores.reduce(min);
        } else {
          highScore.value = 99999;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load scores: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateHighScore(int currentScore) async {
    try {
      isLoading.value = true;

      // Create new scores list
      final newScores = [...allScores, currentScore];

      // Update local state
      allScores.value = newScores;
      highScore.value = newScores.reduce(min);

      // Update Firestore
      await _firestore.collection('patients').doc(patientId).set({
        'memoryMatchScores': newScores,
        'memoryMatchHighScore': highScore.value,
      }, SetOptions(merge: true));

    } catch (e) {
      Get.snackbar('Error', 'Failed to update score: $e');
      _loadScores();
    } finally {
      isLoading.value = false;
    }
  }
}