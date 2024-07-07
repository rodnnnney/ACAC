import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  HomeCard(
      {super.key,
      required this.displayIMG,
      required this.text,
      required this.routeName});

  final String displayIMG;
  final String text;
  final Function(BuildContext, String) routeName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        routeName(context, text);
      },
      child: Card(
        elevation: 2,
        child: SizedBox(
          width: 120,
          height: 130,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: displayIMG,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
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
