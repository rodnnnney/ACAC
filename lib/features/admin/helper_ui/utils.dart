import 'package:ACAC/models/Restaurant.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/models/User.dart';
import 'package:flutter/cupertino.dart';

enum TimePeriod { day, week, month, threeMonths, sixMonths, year, allTime }

// Filters all restaurant cards by time period
List<Restaurant> filterByTimePeriod(List<Restaurant> cards, TimePeriod period) {
  final startDate = getStartDateForPeriod(period);
  return cards
      .where((card) => card.createdAt!.getDateTimeInUtc().isAfter(startDate))
      .toList();
}

// Filters all users by time period
List<User> filterUsersByTimePeriod(List<User> users, TimePeriod period) {
  final startDate = getStartDateForPeriod(period);
  return users
      .where((user) => user.createdAt!.getDateTimeInUtc().isAfter(startDate))
      .toList();
}

// Gets past period
TimePeriod getPreviousPeriod(TimePeriod currentPeriod) {
  switch (currentPeriod) {
    case TimePeriod.day:
      return TimePeriod.day; // Can't go shorter than a day
    case TimePeriod.week:
      return TimePeriod.day;
    case TimePeriod.month:
      return TimePeriod.week;
    case TimePeriod.threeMonths:
      return TimePeriod.month;
    case TimePeriod.sixMonths:
      return TimePeriod.threeMonths;
    case TimePeriod.year:
      return TimePeriod.sixMonths;
    case TimePeriod.allTime:
      return TimePeriod.year;
  }
}

List<Restaurant> filterRestaurantsByTimePeriod(
    List<Restaurant> restaurants, TimePeriod period) {
  final startDate = getStartDateForPeriod(period);
  return restaurants
      .where((restaurant) =>
          restaurant.createdAt!.getDateTimeInUtc().isAfter(startDate))
      .toList();
}

// Cut off date until today
DateTime getStartDateForPreviousPeriod(TimePeriod period) {
  final currentPeriodStart = getStartDateForPeriod(period);
  final now = DateTime.now();
  final periodDuration = now.difference(currentPeriodStart);
  return currentPeriodStart.subtract(periodDuration);
}

String getPeriodDisplay(TimePeriod selectedPeriod) {
  String periodString = selectedPeriod.toString().toLowerCase();
  int dotIndex = periodString.indexOf('.');
  if (dotIndex != -1 && dotIndex < periodString.length - 1) {
    String result = periodString.substring(dotIndex + 1);
    switch (result) {
      case "week":
        return "Week";
      case "month":
        return "Months";
      case "threemonths":
        return "3 Months";
      case "sixmonths":
        return "6 Months";
      case "alltime":
        return "ALL";
    }
  }
  return periodString;
}

// Turns enum into time window
DateTime getStartDateForPeriod(TimePeriod period) {
  final now = DateTime.now();
  switch (period) {
    case TimePeriod.day:
      return now.subtract(const Duration(days: 1));
    case TimePeriod.week:
      return now.subtract(const Duration(days: 7));
    case TimePeriod.month:
      return now.subtract(const Duration(days: 30));
    case TimePeriod.threeMonths:
      return now.subtract(const Duration(days: 90));
    case TimePeriod.sixMonths:
      return now.subtract(const Duration(days: 180));
    case TimePeriod.year:
      return now.subtract(const Duration(days: 365));
    case TimePeriod.allTime:
      return DateTime(2022);
  }
}

// Iterate through user savings
double calculateTotalUserSavings(List<Restaurant> cards) {
  return cards.fold(0.0, (sum, card) {
    return sum + (card.averagePrice * 10 / 100);
  });
}

// Iterate through restaurant savings
double calculateTotalRestaurantRevenue(List<Restaurant> cards) {
  return cards.fold(0.0, (sum, card) {
    return sum + (card.averagePrice * 90 / 100);
  });
}

// Function to calculate revenue for a restaurant
double calculateRestaurantRevenue(
    Restaurant restaurant, List<Restaurant> generalList) {
  final timesVisited = generalList.where((r) => r == restaurant).length;
  return timesVisited * restaurant.averagePrice * 0.9;
}

double userSavings(Restaurant restaurant, List<Restaurant> generalList) {
  final timesVisited = generalList.where((r) => r == restaurant).length;
  return timesVisited * restaurant.averagePrice * 0.1;
}

Map<String, double> calculateRevenueMap(List<Restaurant> restaurants) {
  Map<String, double> map = {};
  for (var restaurant in restaurants) {
    if (map.containsKey(restaurant.restaurant)) {
      map[restaurant.restaurant] =
          (map[restaurant.restaurant] ?? 0) + (restaurant.averagePrice * 0.9);
    } else {
      map[restaurant.restaurant] = restaurant.averagePrice * 0.9;
    }
  }
  return map;
}

Map<String, double> calculateUserSavings(List<Restaurant> restaurants) {
  Map<String, double> map = {};
  for (var restaurant in restaurants) {
    if (map.containsKey(restaurant.restaurant)) {
      map[restaurant.restaurant] =
          (map[restaurant.restaurant] ?? 0) + (restaurant.averagePrice * 0.1);
    } else {
      map[restaurant.restaurant] = restaurant.averagePrice * 0.1;
    }
  }
  return map;
}

// Function to retrieve restaurant card information
RestaurantInfoCard getInfo(
    List<RestaurantInfoCard> infoList, String checkName) {
  for (var info in infoList) {
    if (info.restaurantName == checkName) {
      return info;
    }
  }
  throw ErrorDescription('$checkName not found');
}
