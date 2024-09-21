import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/features/admin/helper_ui/utils.dart';
import 'package:ACAC/features/admin/restaurant_card_view.dart';
import 'package:ACAC/features/home/controller/restaurant_list_controller.dart';
import 'package:ACAC/features/user_auth/data/user_list_controller.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'cost_breakdown.dart';
import 'helper_ui/AdminCard.dart';
import 'helper_ui/TimeFilter.dart';
import 'marketing_card_page.dart';

class AdminHome extends ConsumerStatefulWidget {
  static const String id = '/Admin_home';

  const AdminHome({super.key});

  @override
  ConsumerState<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
  TimePeriod time = TimePeriod.threeMonths;
  int hovered = 2;
  final formatCurrency = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
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
            individualScans.when(
              data: (restaurantInfoCards) => _buildRestaurantStats(
                  restaurantInfoCards, time, userAsyncList),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RestaurantCardView(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme.kGreen2,
                      ),
                      child: const Text(
                        'Restaurant Cards',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MarketingCardsView(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme.kGreen2,
                      ),
                      child: const Text('Marketing Cards',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // Expanded(
                //   child: Container(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(8),
                //       color: AppTheme.kGreen2,
                //     ),
                //     child: const Text('ACAC Events',
                //         style: TextStyle(color: Colors.white)),
                //   ),
                // )
              ],
            )
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
        filterByTimePeriod(restaurantCards, selectedPeriod);

    final previousPeriodCards =
        filterByTimePeriod(restaurantCards, getPreviousPeriod(selectedPeriod));

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
              AdminInfoCard(
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
                        restList: restaurantCards,
                        timePeriod: selectedPeriod,
                        type: 'REST',
                      ),
                    ),
                  );
                },
              ),
              AdminInfoCard(
                description: 'Estimated ACAC Member Savings',
                displayStat: "\$${formatCurrency.format(totalSavings)}",
                emoji: '💸👨🏽‍💻',
                change: totalSavings.toInt() - previousTotalSavings.toInt(),
                changeDescription:
                    'vs previous ${getPeriodDisplay(selectedPeriod)}',
                isCurrency: true,
                descriptionTextSize: 11,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CostBreakdown(
                        restList: restaurantCards,
                        timePeriod: selectedPeriod,
                        type: 'USER',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              AdminInfoCard(
                description: 'Total Restaurant Visits',
                displayStat: currentPeriodCards.length.toString(),
                emoji: '👀',
                change: currentPeriodCards.length - previousPeriodCards.length,
                changeDescription:
                    'vs previous ${getPeriodDisplay(selectedPeriod)}',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CostBreakdown(
                        restList: restaurantCards,
                        timePeriod: selectedPeriod,
                        type: 'REST',
                      ),
                    ),
                  );
                },
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

  Widget _buildUserStats(List<User> users, TimePeriod selectedPeriod) {
    final filteredUsers = filterUsersByTimePeriod(users, selectedPeriod);
    final currentUserCount = filteredUsers.length;

    final previousPeriodEnd = getStartDateForPeriod(selectedPeriod);
    final previousPeriodStart = getStartDateForPreviousPeriod(selectedPeriod);
    final usersInPreviousPeriod = users
        .where((user) =>
            user.createdAt!.getDateTimeInUtc().isAfter(previousPeriodStart) &&
            user.createdAt!.getDateTimeInUtc().isBefore(previousPeriodEnd))
        .length;

    final newUsersThisPeriod = currentUserCount - usersInPreviousPeriod;

    return AdminInfoCard(
      description: 'Total Users',
      displayStat: currentUserCount.toString(),
      emoji: '👯',
      change: newUsersThisPeriod,
      changeDescription: 'vs previous ${getPeriodDisplay(selectedPeriod)}',
    );
  }
}
