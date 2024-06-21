import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/presentation_layer/pages/scanner.dart';
import 'package:flutter/material.dart';

class DiscountCard extends StatelessWidget {
  static String id = 'discount_card';
  const DiscountCard({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Image.asset("images/card.JPG"),
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    child: Image.asset("images/card1.JPG"),
                  ),
                  Positioned(
                    left: MediaQuery.sizeOf(context).width * 0.12,
                    top: MediaQuery.sizeOf(context).height * 0.05,
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 20, color: Color(0xff364037)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBarBottom(
        id: QRViewExample.id,
      ),
    );
  }
}
