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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Image.asset("images/card.JPG"),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Row(
                    children: [const Text('Email:'), Text(name)],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [Text('Expiry Date:'), Text('12/12/2024')],
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Column(
                      children: [
                        Text('Questions or Concerns?'),
                        Text('Reach out ACAC on instagram'),
                        Text("asiancanadianscarleton@gmail.com")
                      ],
                    ),
                  )
                ],
              )
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
