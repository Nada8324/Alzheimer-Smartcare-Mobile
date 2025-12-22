import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/constants/alerts.dart';
import 'package:alzheimer_smartcare/utils/custom_helpers/cache_helper.dart';
import 'package:alzheimer_smartcare/global_models/login_model.dart';
import '../../../utils/constants/endpoints.dart';
import '../../../utils/custom_helpers/dio_consumer.dart';
import '../Schedule/model.dart';

class TaskController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Reminder> taskList = <Reminder>[].obs;
  late String userEmail;
  StreamSubscription<QuerySnapshot>? _tasksSubscription;
  DioConsumer dioConsumer = DioConsumer(dio: Dio(), baseUrl: Endpoints.baseUrl);

  @override
  void onInit() {
    super.onInit();
    final loginModel = CacheHelper().getUserInfo();
    userEmail = loginModel?.email ?? "";
    _setupTasksStream();
  }

  @override
  void onClose() {
    _tasksSubscription?.cancel();
    super.onClose();
  }

  void _setupTasksStream() {
    if (userEmail.isEmpty) {
      print("User email not available for tasks");
      return;
    }

    _tasksSubscription = _firestore
        .collection('patients')
        .doc(userEmail)
        .collection('reminders')
        .orderBy('startTime', descending: false)
        .snapshots()
        .listen((snapshot) {
      _processSnapshot(snapshot);
    }, onError: (error) {
      print("Firestore error: $error");
      showAppSnackBar(
          alertType: AlertType.fail,
          message: "Failed to load tasks"
      );
    });
  }

  void _processSnapshot(QuerySnapshot snapshot) {
    final newTasks = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Reminder(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        isCompleted: data['isCompleted'] ?? false,
        date: (data['date'] as Timestamp).toDate(),
        startTime: (data['startTime'] as Timestamp).toDate(),
        endTime: (data['endTime'] as Timestamp).toDate(),
        repeat: data['repeat'] ?? 'None',
        imageBase64: data['imageBase64'],
        type: data['type'] ?? 'Medicine',
      );
    }).toList();

    taskList.assignAll(newTasks);
  }


  Future<void> addTask({required Reminder task}) async {
    try {
      final docRef = _firestore
          .collection('patients')
          .doc(userEmail)
          .collection('reminders');

      await docRef.add({
        'title': task.title,
        'description': task.description,
        'isCompleted': task.isCompleted,
        'date': Timestamp.fromDate(task.date),
        'startTime': Timestamp.fromDate(task.startTime),
        'endTime': Timestamp.fromDate(task.endTime),
        'repeat': task.repeat,
        'imageBase64': task.imageBase64,
        'type': task.type,
      });

      final fcmToken = await FirebaseMessaging.instance.getToken();

      final apiData = {
        'title': task.title,
        'body': task.description,
        'scheduledTime': _formatDateTimeToUTC(task.startTime),
        'repeat': task.repeat.toLowerCase(),
        'fcmToken': fcmToken,
      }; print(apiData);
      await dioConsumer.postData(
        Endpoints.scheduleNotification,
        data: apiData,
        onSuccess: (response) {
          debugPrint('Notification scheduled successfully');
        },
        onError: (error) {
          debugPrint('Error scheduling notification: $error');
        },
      );
    } catch (e) {
      print("Error adding task: $e");
      rethrow;
    }
  }
  String _formatDateTimeToUTC(DateTime dateTime) {
    final utcTime = dateTime.toUtc();
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(utcTime);
  }
  // Update existing task
  Future<void> updateReminder(Reminder task) async {
    try {
      await _firestore
          .collection('patients')
          .doc(userEmail)
          .collection('reminders')
          .doc(task.id)
          .update({
        'title': task.title,
        'description': task.description,
        'isCompleted': task.isCompleted,
        'date': Timestamp.fromDate(task.date),
        'startTime': Timestamp.fromDate(task.startTime),
        'endTime': Timestamp.fromDate(task.endTime),
        'repeat': task.repeat,
        'imageBase64': task.imageBase64,
        'type': task.type,
      });
    } catch (e) {
      print("Error updating task: $e");
      rethrow;
    }
  }

  // Delete task
  Future<void> delete(Reminder task) async {
    try {
      await _firestore
          .collection('patients')
          .doc(userEmail)
          .collection('reminders')
          .doc(task.id)
          .delete();
    } catch (e) {
      print("Error deleting task: $e");
      rethrow;
    }
  }


  Future<void> toggleTaskCompletion(Reminder task) async {
    try {
      final newStatus = !task.isCompleted;
      await _firestore
          .collection('patients')
          .doc(userEmail)
          .collection('reminders')
          .doc(task.id)
          .update({'isCompleted': newStatus});

      final index = taskList.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        taskList[index] = task.copyWith(isCompleted: newStatus);
      }
    } catch (e) {
      print("Error toggling task: $e");
      rethrow;
    }
  }

  Future<Reminder?> getTaskById(String id) async {
    try {
      final doc = await _firestore
          .collection('patients')
          .doc(userEmail)
          .collection('reminders')
          .doc(id)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Reminder(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          isCompleted: data['isCompleted'] ?? false,
          date: (data['date'] as Timestamp).toDate(),
          startTime: (data['startTime'] as Timestamp).toDate(),
          endTime: (data['endTime'] as Timestamp).toDate(),
          repeat: data['repeat'] ?? 'None',
          imageBase64: data['imageBase64'],
          type: data['type'] ?? 'Medicine',
        );
      }
      return null;
    } catch (e) {
      print("Error getting task: $e");
      return null;
    }
  }
}