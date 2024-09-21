import 'dart:io';

import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/widgets/ui/response_pop_up.dart';
import 'package:ACAC/features/admin/new_restaurant_card.dart';
import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class RestaurantCardView extends ConsumerStatefulWidget {
  const RestaurantCardView({super.key});

  @override
  ConsumerState<RestaurantCardView> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<RestaurantCardView> {
  @override
  Widget build(BuildContext context) {
    var test = ref.watch(restaurantInfoCardListProvider);
    final ScreenshotController screenshotController = ScreenshotController();

    Future<void> captureAndSave() async {
      HapticFeedback.heavyImpact();
      try {
        final image = await screenshotController.capture();
        if (image == null) {
          safePrint('Failed to capture screenshot');
          return;
        }
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/screenshot.png';
        // Save the image as a file
        final test = await File(imagePath).writeAsBytes(image);
        safePrint(test);
        // Save to the gallery
        final result = await ImageGallerySaver.saveFile(imagePath);
        safePrint('Save result: $result');
      } catch (e) {
        safePrint('Error capturing or saving screenshot: $e');
      }
    }

    Future<void> captureAndShare() async {
      try {
        final image = await screenshotController.capture();
        if (image == null) {
          safePrint('Failed to capture screenshot');
          return;
        }
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/qr_code.png';
        await File(imagePath).writeAsBytes(image);

        await Share.shareXFiles([XFile(imagePath)],
            text: 'Check out this QR code!');
      } catch (e) {
        safePrint('Error capturing or sharing screenshot: $e');
      }
    }

    return test.when(
      data: (marketingCardList) {
        marketingCardList.sort((a, b) {
          if (a.createdAt == null || b.createdAt == null) return 0;
          return a.createdAt!
              .getDateTimeInUtc()
              .compareTo(b.createdAt!.getDateTimeInUtc());
        });
        return Scaffold(
          floatingActionButton: AddCardGreenPlusButton(
            destination: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewRestaurantCard(),
                ),
              );
            },
          ),
          appBar: AppBar(
            title: const Text('Restaurant Cards'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 600,
                    child: ListView.builder(
                      itemCount: marketingCardList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 32,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    marketingCardList[index]
                                                        .imageLogo),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                marketingCardList[index]
                                                    .restaurantName,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                final code = PrettyQrView.data(
                                                  data: marketingCardList[index]
                                                      .id,
                                                  errorCorrectLevel:
                                                      QrErrorCorrectLevel.H,
                                                  decoration:
                                                      PrettyQrDecoration(
                                                    image:
                                                        PrettyQrDecorationImage(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              marketingCardList[
                                                                      index]
                                                                  .imageLogo,
                                                            ),
                                                            scale: 0.25),
                                                  ),
                                                );
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        AppTheme.kWhite,
                                                    title: const Text(
                                                        'Generated QR Code'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Center(
                                                        child: Screenshot(
                                                          controller:
                                                              screenshotController,
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                                children: [
                                                                  // Text(
                                                                  //   marketingCardList[
                                                                  //           index]
                                                                  //       .restaurantName,
                                                                  //   style: const TextStyle(
                                                                  //       fontWeight:
                                                                  //           FontWeight
                                                                  //               .bold,
                                                                  //       fontSize:
                                                                  //           30),
                                                                  // ),
                                                                  Container(
                                                                    padding: const EdgeInsets
                                                                        .all(
                                                                        AppTheme.round *
                                                                            1.5),
                                                                    height: 200,
                                                                    width: 200,
                                                                    child: code,
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          TextButton(
                                                            child: const Text(
                                                                'Download QR'),
                                                            onPressed:
                                                                () async {
                                                              await captureAndSave();
                                                              if (context
                                                                  .mounted) {
                                                                Navigator.pop(
                                                                    context);
                                                                const ResponsePopUp(
                                                                  response: ''
                                                                      'QR code downloaded',
                                                                  location:
                                                                      DelightSnackbarPosition
                                                                          .top,
                                                                  icon: Icons
                                                                      .check,
                                                                  color: AppTheme
                                                                      .kGreen2,
                                                                ).showToast(
                                                                    context);
                                                              }
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: const Text(
                                                                'Share'),
                                                            onPressed:
                                                                () async {
                                                              await captureAndShare();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: const Icon(
                                                    Icons.qr_code_rounded),
                                              )),
                                          const SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child:
                                                const Icon(Icons.edit_outlined),
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.redAccent,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class AddCardGreenPlusButton extends StatelessWidget {
  final VoidCallback destination;

  const AddCardGreenPlusButton({
    super.key,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: destination,
      child: SizedBox(
        height: 60,
        width: 60,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: AppTheme.kGreen2, borderRadius: BorderRadius.circular(8)),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
