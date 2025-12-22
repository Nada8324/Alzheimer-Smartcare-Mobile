import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

// This File Writen By ICONIC ** never forget this **

extension EmptyPadding on num {
  SizedBox get sbH => SizedBox(height: toDouble());

  SizedBox get sbW => SizedBox(width: toDouble());
}

String getRoundedHour(DateTime date) {
  int hour = date.hour;

  // Round the hour to the nearest correct hour
  if (date.minute >= 30) {
    hour = (hour + 1) % 12;
  }

  return hour.toString().padLeft(2, '0');
}

// extension GetRoundedHour on DateTime {}

extension CurrencyFormatExtension on num {
  String toCurrencyFormat() {
    final format = NumberFormat.currency(
      symbol: 'EGP',
      decimalDigits: 0,
      locale: 'en_US',
    ); // You can customize the currency symbol here
    return format.format(this);
  }
}

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isTomorrow() {
    final yesterday = DateTime.now().add(const Duration(days: 1));
    return yesterday.day == day && yesterday.month == month && yesterday.year == year;
  }

  String toDateFormat({String? format, String? locale}) {
    final formatter = DateFormat(format ?? 'EE, d MMM hh:mm', locale ?? 'en');
    return formatter.format(this);
  }
}

extension MapExtension on Map<String, dynamic> {
  Map<String, dynamic> removeNulls() => removeNullsFromMap(this);
}

Map<String, dynamic> removeNullsFromMap(Map<String, dynamic> json) => json
  ..removeWhere((String key, dynamic value) => value == null)
  ..map<String, dynamic>((key, value) => MapEntry(key, removeNulls(value)));

List removeNullsFromList(List list) => list
  ..removeWhere((value) => value == null)
  ..map((e) => removeNulls(e)).toList();

removeNulls(e) =>
    (e is List) ? removeNullsFromList(e) : (e is Map<String, dynamic> ? removeNullsFromMap(e) : e);
