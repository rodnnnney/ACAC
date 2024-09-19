import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.displayIMG,
    required this.text,
    required this.routeName,
  });

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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, right: 10, left: 10, bottom: 5),
                  child: CachedNetworkImage(
                    imageUrl: displayIMG,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    // width
                  ),
                ),
              ),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
              const SizedBox(height: 5)
            ],
          ),
        ),
      ),
    );
  }
}

class NoImgCard extends StatelessWidget {
  const NoImgCard(
      {super.key,
      required this.text,
      required this.routeName,
      required this.iconData});

  final String text;
  final Function(BuildContext, String) routeName;
  final IconData iconData;

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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, right: 10, left: 10, bottom: 5),
                  child: Icon(
                    iconData,
                    size: 50,
                  ),
                ),
              ),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
              const SizedBox(height: 5)
            ],
          ),
        ),
      ),
    );
  }
}
