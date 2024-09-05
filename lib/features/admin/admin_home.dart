import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:ACAC/features/user_auth/data/user_list_controller.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/models/User.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/consts/globals.dart';

// Define an enum for time periods
enum TimePeriod { day, week, month, threeMonths, sixMonths, year, allTime }

// Create a provider for the selected time period
final selectedTimePeriodProvider =
    StateProvider<TimePeriod>((ref) => TimePeriod.allTime);

class AdminHome extends ConsumerWidget {
  static const String id = '/Admin_home';

  const AdminHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantInfoCardsAsync = ref.watch(restaurantInfoCardListProvider);
    final userAsyncList = ref.watch(userListControllerProvider);
    final selectedTimePeriod = ref.watch(selectedTimePeriodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTimePeriodToggle(ref),
            restaurantInfoCardsAsync.when(
              data: (restaurantInfoCards) => _buildRestaurantStats(
                  restaurantInfoCards, selectedTimePeriod),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
            userAsyncList.when(
              data: (users) => _buildUserStats(users, selectedTimePeriod),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePeriodToggle(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          TextButton(
              onPressed: () {},
              style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(Size.zero),
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5)),
                  backgroundColor: WidgetStateProperty.all(AppTheme.kGreen2)),
              child: const Text(
                '1W',
                style: TextStyle(color: Colors.white),
              )),
          const SizedBox(width: 30),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.kGreen2,
              ),
              child: const Text('1W', style: TextStyle(color: Colors.white))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<TimePeriod>(
              value: ref.watch(selectedTimePeriodProvider),
              onChanged: (TimePeriod? newValue) {
                if (newValue != null) {
                  ref.read(selectedTimePeriodProvider.notifier).state =
                      newValue;
                }
              },
              items: TimePeriod.values
                  .map<DropdownMenuItem<TimePeriod>>((TimePeriod value) {
                return DropdownMenuItem<TimePeriod>(
                  value: value,
                  child: Text(_getTimePeriodString(value)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimePeriodString(TimePeriod period) {
    switch (period) {
      case TimePeriod.day:
        return 'Past 1 Day';
      case TimePeriod.week:
        return 'Past 7 Days';
      case TimePeriod.month:
        return 'Past 1 Month';
      case TimePeriod.threeMonths:
        return 'Past 3 Months';
      case TimePeriod.sixMonths:
        return 'Past 6 Months';
      case TimePeriod.year:
        return 'Past 1 Year';
      case TimePeriod.allTime:
        return 'All Time';
    }
  }

  Widget _buildRestaurantStats(
      List<RestaurantInfoCard> restaurantInfoCards, TimePeriod selectedPeriod) {
    // Filter restaurantInfoCards based on selectedPeriod
    final filteredCards =
        _filterByTimePeriod(restaurantInfoCards, selectedPeriod);

    // Sort the filteredCards by timesVisited
    filteredCards.sort((a, b) => b.timesVisited.compareTo(a.timesVisited));

    // Calculate total visits
    final totalVisits =
        filteredCards.fold(0, (sum, card) => sum + card.timesVisited);

    // Calculate total savings
    final totalSavings = filteredCards.fold(0.0, (sum, card) {
      final cuisineValue = int.parse(card.cuisineType.firstWhere(
        (element) => int.tryParse(element) != null,
      ));
      return sum +
          (card.timesVisited *
              (cuisineValue * double.parse(card.discountPercent) / 100));
    });

    final previousTotalVisits = totalVisits - 50; // Example: 50 new visits
    final previousTotalSavings =
        totalSavings - 100; // Example: $100 more savings

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AdminInfoCardWithChange(
            description: 'Total Restaurant Visits',
            displayStat: totalVisits.toString(),
            emoji: '👀',
            change: totalVisits - previousTotalVisits,
            changeDescription: 'vs previous period',
          ),
          AdminInfoCardWithChange(
            description: 'Total Estimated Savings',
            displayStat: "\$${totalSavings.toStringAsFixed(2)}",
            emoji: '💸',
            change: totalSavings.toInt() - previousTotalSavings.toInt(),
            changeDescription: 'vs previous period',
            isCurrency: true,
            descriptionTextSize: 11,
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats(List<User> users, TimePeriod selectedPeriod) {
    final filteredUsers = _filterUsersByTimePeriod(users, selectedPeriod);
    final currentUserCount = filteredUsers.length;

    // Calculate the number of users in the previous period
    final previousPeriodEnd = _getStartDateForPeriod(selectedPeriod);
    final previousPeriodStart = _getStartDateForPreviousPeriod(selectedPeriod);
    final usersInPreviousPeriod = users
        .where((user) =>
            user.createdAt!.getDateTimeInUtc().isAfter(previousPeriodStart) &&
            user.createdAt!.getDateTimeInUtc().isBefore(previousPeriodEnd))
        .length;

    final newUsersThisPeriod = currentUserCount - usersInPreviousPeriod;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          AdminInfoCardWithChange(
            description: 'Total Users',
            displayStat: currentUserCount.toString(),
            emoji: '👯',
            change: newUsersThisPeriod,
            changeDescription: 'vs previous period',
          ),
        ],
      ),
    );
  }

  List<RestaurantInfoCard> _filterByTimePeriod(
      List<RestaurantInfoCard> cards, TimePeriod period) {
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
        return DateTime(1970); // Return a very old date for "All Time"
    }
  }

  DateTime _getStartDateForPreviousPeriod(TimePeriod period) {
    final currentPeriodStart = _getStartDateForPeriod(period);
    final now = DateTime.now();
    final periodDuration = now.difference(currentPeriodStart);
    return currentPeriodStart.subtract(periodDuration);
  }
}

// The AdminInfoCardWithChange widget remains unchanged

class AdminInfoCardWithChange extends StatelessWidget {
  const AdminInfoCardWithChange({
    super.key,
    required this.description,
    required this.displayStat,
    required this.emoji,
    required this.change,
    required this.changeDescription,
    this.isCurrency = false,
    this.descriptionTextSize = 12,
  });

  final String description;
  final String emoji;
  final String displayStat;
  final int change;
  final String changeDescription;
  final bool isCurrency;
  final double descriptionTextSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                maxLines: 1,
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
    );
  }
}
