import 'package:ACAC/models/ModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
