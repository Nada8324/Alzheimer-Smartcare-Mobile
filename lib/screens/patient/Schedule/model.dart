import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';

class Reminder {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime date;
  DateTime startTime;
  DateTime endTime;
  String repeat;
  String? imageBase64;
  String type;
  RxString timeLeft = 'Calculating...'.obs;
  Timer? _timer;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.repeat,
    this.imageBase64,
    required this.type,
  }) {
    startTimer();
  }
  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? repeat,
    String? image,
    String? type,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      repeat: repeat ?? this.repeat,
      imageBase64: image ?? this.imageBase64,
      type: type ?? this.type,
    );
  }
  // Convert Firestore document to Reminder
  factory Reminder.fromFirestore(DocumentSnapshot doc) {
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

  // Convert Reminder to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'date': Timestamp.fromDate(date),
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'repeat': repeat,
      'imageBase64': imageBase64,
      'type': type,
    };
  }

  // For UI time formatting
  String get formattedDate => DateFormat.yMd().format(date);
  String get formattedStartTime => DateFormat.jm().format(startTime);
  String get formattedEndTime => DateFormat.jm().format(endTime);

  void startTimer() {
    _timer?.cancel();
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimeLeft());
  }

  void _updateTimeLeft() {
    try {
      final now = DateTime.now();
      final target = startTime;
      final difference = target.difference(now);

      if (difference.isNegative) {
        timeLeft.value = 'Expired';
        _timer?.cancel();
        return;
      }

      timeLeft.value = '${difference.inDays}d '
          '${difference.inHours.remainder(24)}h '
          '${difference.inMinutes.remainder(60)}m '
          '${difference.inSeconds.remainder(60)}s';
    } catch (e) {
      timeLeft.value = 'Invalid Date';
      _timer?.cancel();
    }
  }

  void dispose() {
    _timer?.cancel();
  }

  void toggleCompletion() {
    isCompleted = !isCompleted;
  }
}