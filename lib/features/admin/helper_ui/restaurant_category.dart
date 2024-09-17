import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/widgets/ui/CustomCheckBox.dart';
import 'package:flutter/material.dart';

class RestaurantCategory extends StatefulWidget {
  const RestaurantCategory({super.key});

  @override
  State<RestaurantCategory> createState() => _RestaurantCategoryState();
}

class _RestaurantCategoryState extends State<RestaurantCategory> {
  List<String> restaurantTags = [];

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
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Edit Properties'),
                      Row(
                        children: [
                          CustomCheckBox(
                            color: AppTheme.kAlertRed,
                            iconData: Icons.close,
                          ),
                          const SizedBox(width: 10),
                          CustomCheckBox(
                            color: AppTheme.kGreen2,
                            iconData: Icons.check,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PropertyOption(
                              isSelected: restaurantTags.contains('Chinese'),
                              onTap: () {
                                setState(() {
                                  restaurantTags.add('Chinese');
                                });
                              },
                              onTapTextColor: AppTheme.kGreen,
                              text: 'Chinese',
                            ),
                            PropertyOption(
                              isSelected: restaurantTags.contains('Viet'),
                              onTap: () {
                                setState(() {
                                  restaurantTags.add('Viet');
                                });
                              },
                              onTapTextColor: AppTheme.kGreen,
                              text: 'Viet',
                            ),
                            PropertyOption(
                              isSelected: restaurantTags.contains('Korean'),
                              onTap: () {
                                setState(() {
                                  restaurantTags.add('Korean');
                                });
                              },
                              onTapTextColor: AppTheme.kGreen,
                              text: 'Korean',
                            ),
                            PropertyOption(
                              isSelected: restaurantTags.contains('Japanese'),
                              onTap: () {
                                if (restaurantTags.contains('Japanese')) {
                                  setState(() {
                                    restaurantTags.remove('Japanese');
                                  });
                                } else {
                                  setState(() {
                                    restaurantTags.add('Japanese');
                                  });
                                }
                              },
                              onTapTextColor: AppTheme.kGreen,
                              text: 'Japanese',
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
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
  final Color onTapTextColor;

  const PropertyOption({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.width = 60,
    this.height = 60,
    required this.onTapTextColor,
    required this.text,
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
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? onTapTextColor : const Color(0xffA9A9AB),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
