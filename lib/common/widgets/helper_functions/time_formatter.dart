import 'package:ACAC/models/ModelProvider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

// Helper Class to convert Time object from RestaurantInfoCard
// Into readable times for user

List<String> splitHour(String hour) {
  if (hour == "Open 24 hours") {
    // Handle the case where the restaurant is open 24 hours
    return ["Open 24 hours", "Open 24 hours"];
  } else if (hour == "Closed") {
    // Handle the case where the restaurant is closed
    return ["Closed", "Closed"];
  } else {
    // Split the normal hour format, e.g., "10:00 AM - 10:00 PM"
    return hour.split(' - ');
  }
}

Color timeColor(DateTime currentTime, String openTimeStr, String closeTimeStr) {
  // Return red if the restaurant is explicitly marked as 'closed'
  if (openTimeStr.toLowerCase() == 'closed' ||
      closeTimeStr.toLowerCase() == 'closed') {
    return Colors.red;
  }

  if (openTimeStr.toLowerCase() == 'open 24 hours' ||
      closeTimeStr.toLowerCase() == 'open 24 hours') {
    return Colors.green;
  }

  // Helper function to safely parse TimeOfDay
  TimeOfDay? parseTimeOfDaySafely(String timeStr) {
    try {
      return parseTimeOfDay(timeStr);
    } catch (e) {
      safePrint(e);
      return null; // Return null if parsing fails
    }
  }

  // Parse the opening and closing times
  TimeOfDay? openTime = parseTimeOfDaySafely(openTimeStr);
  TimeOfDay? closeTime = parseTimeOfDaySafely(closeTimeStr);

  // If times cannot be parsed, assume closed
  if (openTime == null || closeTime == null) {
    safePrint('Error parsing time');
    return Colors.red;
  }

  // Create DateTime objects for opening and closing times
  DateTime openDateTime = DateTime(currentTime.year, currentTime.month,
      currentTime.day, openTime.hour, openTime.minute);
  DateTime closeDateTime = DateTime(currentTime.year, currentTime.month,
      currentTime.day, closeTime.hour, closeTime.minute);

  // If the closing time is after midnight, add one day to closeDateTime
  if (closeTime.hour < openTime.hour ||
      (closeTime.hour == openTime.hour && closeTime.minute < openTime.minute)) {
    closeDateTime = closeDateTime.add(const Duration(days: 1));
  }

  // Color determination based on current time
  if (currentTime.isBefore(openDateTime.subtract(const Duration(hours: 1)))) {
    return Colors.red; // More than 1 hour before opening
  } else if (currentTime
      .isAfter(closeDateTime.add(const Duration(minutes: 30)))) {
    return Colors.red; // More than 30 minutes after closing
  } else if (currentTime
          .isAfter(openDateTime.subtract(const Duration(hours: 1))) &&
      currentTime.isBefore(openDateTime)) {
    return Colors.orange; // Within 1 hour before opening
  } else if (currentTime
          .isAfter(closeDateTime.subtract(const Duration(minutes: 30))) &&
      currentTime.isBefore(closeDateTime)) {
    return Colors.orange; // Within 30 minutes before closing
  } else if (currentTime.isAfter(openDateTime) &&
      currentTime.isBefore(closeDateTime)) {
    return Colors.green; // During open hours
  } else {
    return Colors.red; // Default to closed
  }
}

TimeOfDay parseTimeOfDay(String timeString) {
  // Remove any extra whitespace and convert to uppercase
  timeString = timeString.trim().toUpperCase();

  // Use regex to match time format
  final RegExp timeRegex = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$');
  final match = timeRegex.firstMatch(timeString);

  if (match == null) {
    throw FormatException('Invalid time format: $timeString');
  }

  int hour = int.parse(match.group(1)!);
  final int minute = int.parse(match.group(2)!);
  final String amPm = match.group(3)!;

  // Handle AM/PM
  if (amPm == 'PM' && hour != 12) {
    hour += 12;
  } else if (amPm == 'AM' && hour == 12) {
    hour = 0;
  }

  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
    throw FormatException('Invalid time: $timeString');
  }

  return TimeOfDay(hour: hour, minute: minute);
}

String getHour(RestaurantInfoCard rest, int weekday) {
  String start = "";
  String stop = "";

  // Extract the start and stop times based on the weekday
  switch (weekday) {
    case 1:
      start = rest.hours.monday.start;
      stop = rest.hours.monday.stop;
      break;
    case 2:
      start = rest.hours.tuesday.start;
      stop = rest.hours.tuesday.stop;
      break;
    case 3:
      start = rest.hours.wednesday.start;
      stop = rest.hours.wednesday.stop;
      break;
    case 4:
      start = rest.hours.thursday.start;
      stop = rest.hours.thursday.stop;
      break;
    case 5:
      start = rest.hours.friday.start;
      stop = rest.hours.friday.stop;
      break;
    case 6:
      start = rest.hours.saturday.start;
      stop = rest.hours.saturday.stop;
      break;
    case 7:
      start = rest.hours.sunday.start;
      stop = rest.hours.sunday.stop;
      break;
    default:
      return "Closed";
  }

  // Check if the restaurant is open 24 hours
  if (start == "Open 24 hours" && stop == "Open 24 hours") {
    return "Open 24 hours";
  }

  // Helper function to convert the string time into a number for comparison
  int extractHour(String time) {
    final hourPart = time.split(":")[0];
    return int.tryParse(hourPart) ?? 0;
  }

  // Helper function to add AM/PM based on time and assumption logic
  String formatTime(String time, bool isOpening) {
    // If AM/PM already present, return as is
    if (time.toLowerCase().contains('am') ||
        time.toLowerCase().contains('pm')) {
      return time;
    }

    // Extract hour for comparison
    int hour = extractHour(time);

    if (isOpening) {
      // Assume 4:00 AM - 11:59 AM are morning times
      if (hour >= 4 && hour < 12) {
        return "$time AM";
      } else {
        return "$time PM"; // Anything else is PM
      }
    } else {
      // Assume closing times are PM unless they are midnight or morning hours
      if (hour >= 1 && hour < 12) {
        return "$time PM";
      } else {
        return "$time AM"; // Midnight or early morning
      }
    }
  }

  // Format the start and stop times if AM/PM is missing
  start = formatTime(start, true); // For opening time
  stop = formatTime(stop, false); // For closing time

  // Return the formatted hours for non-24-hour days
  return '$start - $stop';
}
