import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class NotificationServices {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    debugPrint("title: ${message.notification?.title}");
    debugPrint("body: ${message.notification?.body}");
    debugPrint("payload: ${message.data}");
  }


  Future<void> initializeNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $fcmToken");
    FirebaseMessaging.onMessage.listen((handleBackgroundMessage));
}

}
















/*
import 'dart:io';
import 'dart:math';

import 'package:alzheimer_smartcare/global_controllers/text_to_speech_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../screens/patient/Schedule/schedule.dart';


class NotificationServices {

  static final TextToSpeechService ttsService = TextToSpeechService();

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      "resource://drawable/notiicon",
      [
        NotificationChannel(
          channelKey: 'flutter_schedule_app_channel',
          channelName: 'Flutter Schedule App Channel',
          channelDescription: 'This channel is resposible for showing Flutter Schedule App notifications.',
          importance: NotificationImportance.Max,
          defaultPrivacy: NotificationPrivacy.Public,
          defaultColor: Colors.transparent,
          locked: true,
          enableVibration: true,
          //icon: "resource://drawable/notiicon",
          //playSound: true,
          //soundSource: "resource://raw/correct" ,
        ),
      ],
    );
  }


  static Future<void> scheduleNotification({
    required Schedule schedule,
  }) async {
    Random random = Random();

    // Calculate the delay until the scheduled time
    final now = DateTime.now();
    final notificationTime = DateTime(
      schedule.time.year,
      schedule.time.month,
      schedule.time.day,
      schedule.time.hour,
      schedule.time.minute,
    );
    final delay = notificationTime.isBefore(now)
        ? Duration.zero
        : notificationTime.difference(now);

    // Schedule the notification
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: random.nextInt(1000000) + 1,
        channelKey: 'flutter_schedule_app_channel',
        title: "Reminder",
        body: schedule.details,
        category: NotificationCategory.Reminder,
        notificationLayout: NotificationLayout.BigPicture,
        locked: true,
        wakeUpScreen: true,
        autoDismissible: false,
        fullScreenIntent: true,
        backgroundColor: Colors.transparent,
      ),
      schedule: NotificationCalendar(
        minute: schedule.time.minute,
        hour: schedule.time.hour,
        day: schedule.time.day,
        weekday: schedule.time.weekday,
        month: schedule.time.month,
        year: schedule.time.year,
        preciseAlarm: true,
        allowWhileIdle: true,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ), // NotificationCalendar
      actionButtons: [
        NotificationActionButton(
          key: "Close",
          label: "Close Reminder",
          autoDismissible: true,
        ),
      ],
    );

    // Wait for the notification time
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }

    // Speak the text
    await ttsService.speak(schedule.details);
  }
}*/
