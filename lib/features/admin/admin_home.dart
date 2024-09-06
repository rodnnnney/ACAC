import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/features/home/controller/restaurant_list_controller.dart';
import 'package:ACAC/features/user_auth/data/user_list_controller.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'cost_breakdown.dart';

enum TimePeriod { day, week, month, threeMonths, sixMonths, year, allTime }

class AdminHome extends ConsumerStatefulWidget {
  static const String id = '/Admin_home';

  const AdminHome({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
  TimePeriod time = TimePeriod.week;
  int hovered = 0;
  final formatCurrency = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    //final restaurantInfoCardsAsync = ref.watch
    // (restaurantInfoCardListProvider);
    final individualScans = ref.watch(restaurantListControllerProvider);
    final userAsyncList = ref.watch(userListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimePeriodToggle(),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              child: individualScans.when(
                data: (restaurantInfoCards) => _buildRestaurantStats(
                    restaurantInfoCards, time, userAsyncList),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePeriodToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TimeFilter(
            uiText: '1W',
            hovered: hovered,
            uiNum: 0,
            onHover: (int num) {
              setState(() {
                hovered = 0;
                time = TimePeriod.week;
              });
            },
          ),
          const SizedBox(width: 10),
          TimeFilter(
            uiText: '1M',
            hovered: hovered,
            uiNum: 1,
            onHover: (int num) {
              setState(() {
                hovered = 1;
                time = TimePeriod.month;
              });
            },
          ),
          const SizedBox(width: 10),
          TimeFilter(
            uiText: '3M',
            hovered: hovered,
            uiNum: 2,
            onHover: (int num) {
              setState(() {
                hovered = 2;
                time = TimePeriod.threeMonths;
              });
            },
          ),
          const SizedBox(width: 10),
          TimeFilter(
            uiText: '6M',
            hovered: hovered,
            uiNum: 3,
            onHover: (int num) {
              setState(() {
                hovered = 3;
                time = TimePeriod.sixMonths;
              });
            },
          ),
          const SizedBox(width: 10),
          TimeFilter(
            uiText: 'ALL',
            hovered: hovered,
            uiNum: 4,
            onHover: (int num) {
              setState(() {
                hovered = 4;
                time = TimePeriod.allTime;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantStats(List<Restaurant> restaurantCards,
      TimePeriod selectedPeriod, AsyncValue<List<User>> userAsyncList) {
    final currentPeriodCards =
        _filterByTimePeriod(restaurantCards, selectedPeriod);

    final previousPeriodCards =
        _filterByTimePeriod(restaurantCards, getPreviousPeriod(selectedPeriod));

    final totalSavings = calculateTotalUserSavings(currentPeriodCards);
    final rest = calculateTotalRestaurantRevenue(currentPeriodCards);

    final previousTotalSavings = calculateTotalUserSavings(previousPeriodCards);
    final preRest = calculateTotalRestaurantRevenue(previousPeriodCards);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AdminInfoCardWithChange(
                description: 'Estimated Restaurant Revenue',
                displayStat: "\$${formatCurrency.format(rest)}",
                emoji: '💸👨🏻‍🍳',
                change: rest.toInt() - preRest.toInt(),
                changeDescription:
                    'vs previous ${getPeriodDisplay(selectedPeriod)}',
                isCurrency: true,
                descriptionTextSize: 11,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CostBreakdown(
                        restList:
                            restaurantCards, // Provide the actual list here
                      ),
                    ),
                  );
                },
              ),
              AdminInfoCardWithChange(
                description: 'Estimated ACAC Member Savings',
                displayStat: "\$${formatCurrency.format(totalSavings)}",
                emoji: '💸👨🏽‍💻',
                change: totalSavings.toInt() - previousTotalSavings.toInt(),
                changeDescription:
                    'vs previous ${getPeriodDisplay(selectedPeriod)}',
                isCurrency: true,
                descriptionTextSize: 11,
              ),
            ],
          ),
          Row(
            children: [
              AdminInfoCardWithChange(
                description: 'Total Restaurant Visits',
                displayStat: currentPeriodCards.length.toString(),
                emoji: '👀',
                change: currentPeriodCards.length - previousPeriodCards.length,
                changeDescription:
                    'vs previous ${getPeriodDisplay(selectedPeriod)}',
              ),
              userAsyncList.when(
                data: (users) => _buildUserStats(users, time),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ],
          )
        ],
      ),
    );
  }

  double calculateTotalUserSavings(List<Restaurant> cards) {
    return cards.fold(0.0, (sum, card) {
      return sum + (card.averagePrice * 10 / 100);
    });
  }

  double calculateTotalRestaurantRevenue(List<Restaurant> cards) {
    return cards.fold(0.0, (sum, card) {
      return sum + (card.averagePrice * 90 / 100);
    });
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

  Widget _buildUserStats(List<User> users, TimePeriod selectedPeriod) {
    final filteredUsers = _filterUsersByTimePeriod(users, selectedPeriod);
    final currentUserCount = filteredUsers.length;

    final previousPeriodEnd = _getStartDateForPeriod(selectedPeriod);
    final previousPeriodStart = _getStartDateForPreviousPeriod(selectedPeriod);
    final usersInPreviousPeriod = users
        .where((user) =>
            user.createdAt!.getDateTimeInUtc().isAfter(previousPeriodStart) &&
            user.createdAt!.getDateTimeInUtc().isBefore(previousPeriodEnd))
        .length;

    final newUsersThisPeriod = currentUserCount - usersInPreviousPeriod;

    return AdminInfoCardWithChange(
      description: 'Total Users',
      displayStat: currentUserCount.toString(),
      emoji: '👯',
      change: newUsersThisPeriod,
      changeDescription: 'vs previous ${getPeriodDisplay(selectedPeriod)}',
    );
  }

  List<Restaurant> _filterByTimePeriod(
      List<Restaurant> cards, TimePeriod period) {
    final startDate = _getStartDateForPeriod(period);
    return cards
        .where((card) => card.createdAt!.getDateTimeInUtc().isAfter(startDate))
        .toList();
  }

  List<User> _filterUsersByTimePeriod(List<User> users, TimePeriod period) {
    final startDate = _getStartDateForPeriod(period);
    return users
        .where((user) => user.createdAt!.getDateTimeInUtc().isAfter(startDate))
        .toList();
  }

  DateTime _getStartDateForPeriod(TimePeriod period) {
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

  DateTime _getStartDateForPreviousPeriod(TimePeriod period) {
    final currentPeriodStart = _getStartDateForPeriod(period);
    final now = DateTime.now();
    final periodDuration = now.difference(currentPeriodStart);
    return currentPeriodStart.subtract(periodDuration);
  }
}

class TimeFilter extends StatelessWidget {
  const TimeFilter({
    super.key,
    required this.uiText,
    required this.hovered,
    required this.uiNum,
    required this.onHover,
  });

  final String uiText;
  final int hovered;
  final int uiNum;
  final Function(int) onHover;

  @override
  Widget build(BuildContext context) {
    bool show = (hovered == uiNum);
    return GestureDetector(
      onTap: () {
        onHover(uiNum); // Call the parent’s function to update state
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: show ? AppTheme.kGreen2 : Colors.black.withOpacity(0.5),
        ),
        child: Text(uiText, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class AdminInfoCardWithChange extends StatelessWidget {
  const AdminInfoCardWithChange(
      {super.key,
      required this.description,
      required this.displayStat,
      required this.emoji,
      required this.change,
      required this.changeDescription,
      this.isCurrency = false,
      this.descriptionTextSize = 12,
      this.onTap});

  final String description;
  final String emoji;
  final String displayStat;
  final int change;
  final String changeDescription;
  final bool isCurrency;
  final double descriptionTextSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: descriptionTextSize),
                  ),
                  Text(
                    displayStat,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        change >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        color: change >= 0 ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      Text(
                        '${isCurrency ? '\$' : ''}${change.abs().toStringAsFixed(isCurrency ? 2 : 0)}',
                        style: TextStyle(
                          color: change >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    changeDescription,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
