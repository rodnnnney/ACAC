import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Map<String, dynamic> getStatusWithColor(
    DateTime currentTime, String openTimeStr, String closeTimeStr) {
  if (openTimeStr.toLowerCase() == 'closed' ||
      closeTimeStr.toLowerCase() == 'closed') {
    return {'status': 'closed', 'color': Colors.red};
  }

  TimeOfDay openTime = parseTimeOfDay(openTimeStr);
  TimeOfDay closeTime = parseTimeOfDay(closeTimeStr);

  DateTime openDateTime = DateTime(currentTime.year, currentTime.month,
      currentTime.day, openTime.hour, openTime.minute);
  DateTime closeDateTime = DateTime(currentTime.year, currentTime.month,
      currentTime.day, closeTime.hour, closeTime.minute);
  // Handle closing time after midnight
  if (closeTime.hour < openTime.hour) {
    closeDateTime = closeDateTime.add(const Duration(days: 1));
  }
  if (currentTime.isBefore(openDateTime.subtract(const Duration(hours: 1)))) {
    return {'status': 'closed', 'color': Colors.red};
  } else if (currentTime
      .isAfter(closeDateTime.add(const Duration(minutes: 30)))) {
    return {'status': 'closed', 'color': Colors.red};
  } else if (currentTime
          .isAfter(openDateTime.subtract(const Duration(hours: 1))) &&
      currentTime.isBefore(openDateTime)) {
    return {'status': 'opening soon', 'color': Colors.orange};
  } else if (currentTime
          .isAfter(closeDateTime.subtract(const Duration(minutes: 30))) &&
      currentTime.isBefore(closeDateTime)) {
    return {'status': 'closing soon', 'color': Colors.orange};
  } else if (currentTime.isAfter(openDateTime) &&
      currentTime.isBefore(closeDateTime)) {
    return {'status': 'open', 'color': Colors.green};
  } else {
    return {'status': 'closed', 'color': Colors.red};
  }
}

Color timeColor(DateTime currentTime, String openTimeStr, String closeTimeStr) {
  if (openTimeStr.toLowerCase() == 'closed' ||
      closeTimeStr.toLowerCase() == 'closed') {
    return Colors.red;
  }
  TimeOfDay openTime = parseTimeOfDay(openTimeStr);
  TimeOfDay closeTime = parseTimeOfDay(closeTimeStr);
  DateTime openDateTime = DateTime(currentTime.year, currentTime.month,
      currentTime.day, openTime.hour, openTime.minute);
  DateTime closeDateTime = DateTime(currentTime.year, currentTime.month,
      currentTime.day, closeTime.hour, closeTime.minute);
  // Handle closing time after midnight
  if (closeTime.hour < openTime.hour) {
    closeDateTime = closeDateTime.add(const Duration(days: 1));
  }
  if (currentTime.isBefore(openDateTime.subtract(const Duration(hours: 1)))) {
    return Colors.red;
  } else if (currentTime
      .isAfter(closeDateTime.add(const Duration(minutes: 30)))) {
    return Colors.red;
  } else if (currentTime
          .isAfter(openDateTime.subtract(const Duration(hours: 1))) &&
      currentTime.isBefore(openDateTime)) {
    return Colors.orange;
  } else if (currentTime
          .isAfter(closeDateTime.subtract(const Duration(minutes: 30))) &&
      currentTime.isBefore(closeDateTime)) {
    return Colors.orange;
  } else if (currentTime.isAfter(openDateTime) &&
      currentTime.isBefore(closeDateTime)) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

TimeOfDay parseTimeOfDay(String timeString) {
  try {
    final format = DateFormat('h:mm a');
    final DateTime dateTime = format.parse(timeString);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  } catch (e) {
    throw FormatException('Invalid time format: $timeString');
  }
}

Future<Map<String, dynamic>> getCurrentStatusWithColor(
    String openTimeStr, String closeTimeStr) async {
  return getStatusWithColor(DateTime.now(), openTimeStr, closeTimeStr);
}
