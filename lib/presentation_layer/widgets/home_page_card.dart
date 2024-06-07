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
    double screenHeight = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: () {
        routeName(context, text);
      },
      child: Card(
        child: Container(
          width: 120,
          height: 130,
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: displayIMG,
                  height: screenHeight * 0.15,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
