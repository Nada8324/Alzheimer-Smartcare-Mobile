import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ReminderCardData {
  final String id; // Add this
  final String title;
  final String description;
  final String date;
  final String time;
  final List<String> backgroundLabels;
  final RxString timeLeft;

  ReminderCardData({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.backgroundLabels,
    required String initialTimeLeft,
  }) : timeLeft = initialTimeLeft.obs;
}