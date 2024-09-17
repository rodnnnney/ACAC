import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/widgets/ui/CustomCheckBox.dart';
import 'package:ACAC/common/widgets/ui/confirm_quit.dart';
import 'package:ACAC/common/widgets/ui/response_pop_up.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

Future<List<String>> editProperty(
    {required BuildContext context,
    required List<String> restaurantCategories}) async {
  return showDialog<List<String>>(
    context: context,
    builder: (BuildContext context) => RestaurantCategory(
      restaurantCategories: restaurantCategories,
    ),
  ).then((value) => value ?? restaurantCategories);
}

class RestaurantCategory extends StatefulWidget {
  const RestaurantCategory({super.key, required this.restaurantCategories});

  final List<String> restaurantCategories;

  @override
  State<RestaurantCategory> createState() => _RestaurantCategoryState();
}

class _RestaurantCategoryState extends State<RestaurantCategory> {
  late List<String> restaurantTags;

  List<String> nationality = ['Chinese', 'Vietnamese', 'Japanese', 'Korean'];
  List<String> foodType = ['Desert', 'Fried Chicken', 'Bubble Tea', 'Noodle'];

  void check(String type) {
    setState(() {
      if (restaurantTags.contains(type)) {
        restaurantTags.remove(type);
      } else {
        restaurantTags.add(type);
      }
    });
  }

  void costCheck(String type) {
    setState(() {
      List<String> costValues = ['10', '15', '20', '25'];
      restaurantTags.removeWhere((tag) => costValues.contains(tag));
      setState(() {
        if (!restaurantTags.contains(type)) {
          restaurantTags.add(type);
        }
      });
    });
  }

  bool hasAtLeastOneStringInteger() {
    return restaurantTags.isNotEmpty &&
        restaurantTags.any((tag) => int.tryParse(tag) != null);
  }

  @override
  void initState() {
    super.initState();
    if (widget.restaurantCategories.isEmpty) {
      restaurantTags = [];
    } else {
      restaurantTags = widget.restaurantCategories;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(minWidth: 400, minHeight: 300),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Restaurant Properties'),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return ConfirmQuit(
                                  destination: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  title: 'Confirm Quit',
                                  subtitle: 'All progress will be lost',
                                  actionButton: 'Quit',
                                );
                              },
                            );
                          },
                          child: const CustomCheckBox(
                            color: AppTheme.kAlertRed,
                            iconData: Icons.close,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            if (hasAtLeastOneStringInteger()) {
                              Navigator.of(context).pop(restaurantTags);
                            } else {
                              setState(() {
                                const ResponsePopUp(
                                  response: 'Add at least one tag',
                                  location: DelightSnackbarPosition.top,
                                  icon: Icons.error_outline,
                                  color: AppTheme.kAlertRed,
                                ).showToast(context);
                              });
                            }
                          },
                          child: const CustomCheckBox(
                            color: AppTheme.kGreen2,
                            iconData: Icons.check,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Restaurant Tags(At least 1): ',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PropertyOption(
                            isSelected: restaurantTags.contains('Chinese'),
                            onTap: () {
                              check('Chinese');
                            },
                            onTapTextColor: AppTheme.kGreen,
                            text: 'Chinese',
                            emoji: '🇨🇳',
                          ),
                          PropertyOption(
                            isSelected: restaurantTags.contains('Vietnamese'),
                            onTap: () {
                              check('Vietnamese');
                            },
                            onTapTextColor: AppTheme.kGreen,
                            text: 'Viet',
                            emoji: '🇻🇳',
                          ),
                          PropertyOption(
                            isSelected: restaurantTags.contains('Korean'),
                            onTap: () {
                              check('Korean');
                            },
                            onTapTextColor: AppTheme.kGreen,
                            text: 'Korean',
                            emoji: '🇰🇷',
                          ),
                          PropertyOption(
                            isSelected: restaurantTags.contains('Japanese'),
                            onTap: () {
                              check('Japanese');
                            },
                            onTapTextColor: AppTheme.kGreen,
                            text: 'Japanese',
                            emoji: '🇯🇵',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PropertyOption(
                            isSelected: restaurantTags.contains('Desert'),
                            onTap: () {
                              check('Desert');
                            },
                            onTapTextColor: AppTheme.kGreen,
                            text: 'Desert',
                            emoji: '🍦',
                          ),
                          PropertyOption(
                            isSelected: restaurantTags.contains('Bubble Tea'),
                            onTap: () {
                              check('Bubble Tea');
                            },
                            onTapTextColor: AppTheme.kGreen,
                            text: 'Bubble Tea',
                            emoji: '🧋',
                          ),
                          PropertyOption(
                            isSelected: restaurantTags.contains('Noodle'),
                            onTap: () {
                              check('Noodle');
                            },
                            onTapTextColor: AppTheme.kGreen,
                            text: 'Noodle',
                            emoji: '🍜',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Estimated Restaurant Cost(Required): ',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PropertyOption(
                            isSelected: restaurantTags.contains('10'),
                            onTap: () {
                              costCheck('10');
                            },
                            onTapTextColor: AppTheme.kGreen,
                            text: '\$10',
                            emoji: '💸',
                          ),
                          PropertyOption(
                            isSelected: restaurantTags.contains('15'),
                            onTap: () {
                              costCheck('15');
                            },
                            onTapTextColor: AppTheme.kGreen,
                            text: '\$15',
                            emoji: '💸',
                          ),
                          PropertyOption(
                            isSelected: restaurantTags.contains('20'),
                            onTap: () {
                              costCheck('20');
                            },
                            onTapTextColor: AppTheme.kGreen,
                            text: '\$20',
                            emoji: '💸',
                          ),
                          PropertyOption(
                            isSelected: restaurantTags.contains('25'),
                            onTap: () {
                              costCheck('25');
                            },
                            onTapTextColor: AppTheme.kGreen,
                            text: '\$25',
                            emoji: '💸',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PropertyOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;
  final double height;
  final String emoji;
  final Color onTapTextColor;

  const PropertyOption({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.width = 65,
    this.height = 65,
    required this.onTapTextColor,
    required this.text,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? AppTheme.kGreen : Colors.grey,
        ),
        width: width,
        height: height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white, //isSelected ? onTapTextColor : const
                      // Color
                      // (0xffA9A9AB),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
