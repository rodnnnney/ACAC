import 'package:flutter/material.dart';

class AdminInfoCard extends StatelessWidget {
  const AdminInfoCard(
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
