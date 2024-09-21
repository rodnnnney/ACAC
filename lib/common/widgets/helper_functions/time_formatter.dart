import 'package:ACAC/models/ModelProvider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> getStatusWithColor(
    DateTime currentTime, String openTimeStr, String closeTimeStr) {
  // Return 'closed' if the restaurant is explicitly closed
  if (openTimeStr.toLowerCase() == 'closed' ||
      closeTimeStr.toLowerCase() == 'closed') {
    return {'status': 'closed', 'color': Colors.red};
  }

  // Helper function to parse TimeOfDay safely with default fallbacks
  TimeOfDay? parseTimeOfDaySafely(String timeStr) {
    try {
      return parseTimeOfDay(timeStr);
    } catch (e) {
      return null; // If parsing fails, return null
    }
  }

  // Parse the opening and closing times
  TimeOfDay? openTime = parseTimeOfDaySafely(openTimeStr);
  TimeOfDay? closeTime = parseTimeOfDaySafely(closeTimeStr);

  // If open or close times cannot be parsed, assume it's closed
  if (openTime == null || closeTime == null) {
    return {'status': 'closed', 'color': Colors.red};
  }

  // Create DateTime objects for opening and closing times
  DateTime openDateTime = DateTime(currentTime.year, currentTime.month,
      currentTime.day, openTime.hour, openTime.minute);
  DateTime closeDateTime = DateTime(currentTime.year, currentTime.month,
      currentTime.day, closeTime.hour, closeTime.minute);

  // If the closing time is after midnight, add 1 day to closeDateTime
  if (closeTime.hour < openTime.hour ||
      (closeTime.hour == openTime.hour && closeTime.minute < openTime.minute)) {
    closeDateTime = closeDateTime.add(const Duration(days: 1));
  }

  // If the current time is before the opening time by more than 1 hour
  if (currentTime.isBefore(openDateTime.subtract(const Duration(hours: 1)))) {
    return {'status': 'closed', 'color': Colors.red};
  }
  // If the current time is more than 30 minutes after the closing time
  else if (currentTime
      .isAfter(closeDateTime.add(const Duration(minutes: 30)))) {
    return {'status': 'closed', 'color': Colors.red};
  }
  // If the current time is within 1 hour before the opening time
  else if (currentTime
          .isAfter(openDateTime.subtract(const Duration(hours: 1))) &&
      currentTime.isBefore(openDateTime)) {
    return {'status': 'opening soon', 'color': Colors.orange};
  }
  // If the current time is within 30 minutes before the closing time
  else if (currentTime
          .isAfter(closeDateTime.subtract(const Duration(minutes: 30))) &&
      currentTime.isBefore(closeDateTime)) {
    return {'status': 'closing soon', 'color': Colors.orange};
  }
  // If the current time is between the opening and closing times
  else if (currentTime.isAfter(openDateTime) &&
      currentTime.isBefore(closeDateTime)) {
    return {'status': 'open', 'color': Colors.green};
  }
  // Default: return closed
  else {
    return {'status': 'closed', 'color': Colors.red};
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

  safePrint(openTimeStr);
  safePrint(closeTimeStr);
  // Parse the opening and closing times
  TimeOfDay? openTime = parseTimeOfDaySafely(openTimeStr);
  TimeOfDay? closeTime = parseTimeOfDaySafely(closeTimeStr);
  //
  // TimeOfDay? openTime = parseTimeOfDaySafely(openTimeStr);
  // TimeOfDay? closeTime = parseTimeOfDaySafely(closeTimeStr);

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

Future<Map<String, dynamic>> getCurrentStatusWithColor(
    String openTimeStr, String closeTimeStr) async {
  return getStatusWithColor(DateTime.now(), openTimeStr, closeTimeStr);
}

String getOpeningTime(int weekday, List<RestaurantInfoCard> rest, int index) {
  switch (weekday) {
    case 1:
      return rest[index].hours.monday.start;
    case 2:
      return rest[index].hours.tuesday.start;
    case 3:
      return rest[index].hours.wednesday.start;
    case 4:
      return rest[index].hours.thursday.start;
    case 5:
      return rest[index].hours.friday.start;
    case 6:
      return rest[index].hours.saturday.start;
    case 7:
      return rest[index].hours.sunday.start;
    default:
      return 'Closed';
  }
}

String getClosingTime(int weekday, List<RestaurantInfoCard> rest, int index) {
  switch (weekday) {
    case 1:
      return rest[index].hours.monday.stop;
    case 2:
      return rest[index].hours.tuesday.stop;
    case 3:
      return rest[index].hours.wednesday.stop;
    case 4:
      return rest[index].hours.thursday.stop;
    case 5:
      return rest[index].hours.friday.stop;
    case 6:
      return rest[index].hours.saturday.stop;
    case 7:
      return rest[index].hours.sunday.stop;
    default:
      return 'Closed';
  }
}

String getHours(List<RestaurantInfoCard> rest, int index, int weekday) {
  switch (weekday) {
    case 1:
      return ('${rest[index].hours.monday.start} - '
          '${rest[index].hours.monday.stop}');
    case 2:
      return ('${rest[index].hours.tuesday.start} - '
          '${rest[index].hours.tuesday.stop}');
    case 3:
      return ('${rest[index].hours.wednesday.start} - '
          '${rest[index].hours.wednesday.stop}');
    case 4:
      return ('${rest[index].hours.thursday.start} - '
          '${rest[index].hours.thursday.stop}');
    case 5:
      return ('${rest[index].hours.friday.start} - '
          '${rest[index].hours.friday.stop}');
    case 6:
      return ('${rest[index].hours.saturday.start} - '
          '${rest[index].hours.saturday.stop}');
    case 7:
      return ('${rest[index].hours.sunday.start} - '
          '${rest[index].hours.sunday.stop}');
    default:
      return "Closed";
  }
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

  // Return the formatted hours for non-24-hour days
  return '$start - $stop';
}

String getHoursSingle(RestaurantInfoCard rest, int weekday) {
  switch (weekday) {
    case 1:
      return ('${rest.hours.monday.start} - '
          '${rest.hours.monday.stop}');
    case 2:
      return ('${rest.hours.tuesday.start} - '
          '${rest.hours.tuesday.stop}');
    case 3:
      return ('${rest.hours.wednesday.start} - '
          '${rest.hours.wednesday.stop}');
    case 4:
      return ('${rest.hours.thursday.start} - '
          '${rest.hours.thursday.stop}');
    case 5:
      return ('${rest.hours.friday.start} - '
          '${rest.hours.friday.stop}');
    case 6:
      return ('${rest.hours.saturday.start} - '
          '${rest.hours.saturday.stop}');
    case 7:
      return ('${rest.hours.sunday.start} - '
          '${rest.hours.sunday.stop}');
    default:
      return "Closed";
  }
}

String getOpeningTimeSingle(int weekday, RestaurantInfoCard rest) {
  switch (weekday) {
    case 1:
      return rest.hours.monday.start;
    case 2:
      return rest.hours.tuesday.start;
    case 3:
      return rest.hours.wednesday.start;
    case 4:
      return rest.hours.thursday.start;
    case 5:
      return rest.hours.friday.start;
    case 6:
      return rest.hours.saturday.start;
    case 7:
      return rest.hours.sunday.start;
    default:
      return 'Closed';
  }
}

String getClosingTimeSingle(int weekday, RestaurantInfoCard rest) {
  switch (weekday) {
    case 1:
      return rest.hours.monday.stop;
    case 2:
      return rest.hours.tuesday.stop;
    case 3:
      return rest.hours.wednesday.stop;
    case 4:
      return rest.hours.thursday.stop;
    case 5:
      return rest.hours.friday.stop;
    case 6:
      return rest.hours.saturday.stop;
    case 7:
      return rest.hours.sunday.stop;
    default:
      return 'Closed';
  }
}
