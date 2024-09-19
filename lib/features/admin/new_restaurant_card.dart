import 'dart:io';

import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/widgets/ui/CustomCheckBox.dart';
import 'package:ACAC/common/widgets/ui/confirm_quit.dart';
import 'package:ACAC/features/admin/helper_ui/PreviewImagePick.dart';
import 'package:ACAC/features/admin/helper_ui/restaurant_category.dart';
import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:ACAC/features/home/helper_widgets/card/additional_data_dbb.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'helper_ui/gmaps_api.dart';

class NewRestaurantCard extends ConsumerStatefulWidget {
  const NewRestaurantCard({super.key});

  @override
  ConsumerState<NewRestaurantCard> createState() => _NewRestaurantCardState();
}

class _NewRestaurantCardState extends ConsumerState<NewRestaurantCard> {
  late TextEditingController restaurantNameController;
  late TextEditingController descriptionTextController;
  late TextEditingController gMapsTextController;
  late TextEditingController discountController;
  Prediction locationPrediction = Prediction();

  List<PropertyTag> tags = [];

  @override
  void initState() {
    super.initState();
    restaurantNameController = TextEditingController();
    descriptionTextController = TextEditingController();
    gMapsTextController = TextEditingController();
    discountController = TextEditingController();
  }

  @override
  void dispose() {
    restaurantNameController.dispose();
    descriptionTextController.dispose();
    gMapsTextController.dispose();
    discountController.dispose();
    super.dispose();
  }

  void filterTagSetup(List<String> infoTag) {
    // Clear old tags before adding new ones
    tags.clear();

    for (String filterTag in infoTag) {
      String tagDescription = '';
      Color cardColor = Colors.transparent;
      Color textColor = Colors.black;

      switch (filterTag.toLowerCase()) {
        case 'chinese':
          tagDescription = 'Chinese 🇨🇳';
          cardColor = Colors.red;
          textColor = Colors.white;
          break;
        case 'vietnamese':
          tagDescription = 'Vietnamese 🇻🇳';
          cardColor = const Color(0xff7BAE7F);
          textColor = Colors.white;
          break;
        case 'japanese':
          tagDescription = 'Japanese 🇯🇵';
          cardColor = Colors.transparent;
          textColor = Colors.black87;
          break;
        case 'korean':
          tagDescription = 'Korean 🇰🇷';
          cardColor = const Color(0xffB8E1FF);
          textColor = Colors.white;
          break;
        case 'desert':
          tagDescription = 'Desert 🍦';
          cardColor = const Color(0xffE5D4ED);
          textColor = Colors.white;
          break;
        case 'fried chicken':
          tagDescription = 'Fried Chicken 🍗';
          cardColor = const Color(0xffE3D888);
          textColor = Colors.white;
          break;
        case 'bubble tea':
          tagDescription = 'Bubble Tea 🧋';
          cardColor = const Color(0xff95D7AE);
          textColor = Colors.white;
          break;
        case 'noodle':
          tagDescription = 'Noodles 🍜';
          cardColor = const Color(0xffE2F1AF);
          textColor = Colors.black87;
          break;
        case '10':
          tagDescription = '\$~10💵';
          cardColor = const Color(0xff7BAE7F);
          textColor = Colors.white;
          break;
        case '15':
          tagDescription = '\$~15💵';
          cardColor = const Color(0xff7BAE7F);
          textColor = Colors.white;
          break;
        case '20':
          tagDescription = '\$~20💵';
          cardColor = const Color(0xff7BAE7F);
          textColor = Colors.white;
          break;
        case '25':
          tagDescription = '\$~25💵';
          cardColor = const Color(0xff7BAE7F);
          textColor = Colors.white;
          break;
        default:
          continue;
      }

      // Check if the tag is already present in the list
      if (!tags.any((tag) => tag.tagDescription == tagDescription)) {
        // Add the tag only if it's not already present
        tags.add(PropertyTag(
          tagDescription: tagDescription,
          cardColor: cardColor,
          textColor: textColor,
        ));
      }
    }
  }

  void updateRestaurantCategories(List<String> newCategories) {
    setState(() {
      restaurantCategories = newCategories;
      filterTagSetup(restaurantCategories);
    });
  }

  // 1. restaurantName: restaurantName, ✅
  // 2. location: LatLong(latitude: x, longitude: y), ✅
  // 3. address: '', ✅
  // 4. imageSrc: '',  ✅
  // 5. imageLogo: '', ✅
  // 6. scannerDataMatch: '', ✅
  // 7. hours: Time ✅
  // 8. rating: rating, ✅
  // 9. cuisineType: [], ✅
  // 10. reviewNum: reviewNum,  ✅
  // 11. discounts: [],
  // 12. discountPercent: '',   ✅
  // 13. phoneNumber: '', ✅
  // 14. gMapsLink: '',  ✅
  // 15. websiteLink: '',✅
  // 16. topRatedItemsImgSrc: [], ✅
  // 17. topRatedItemsName: [],✅
  // timesVisited: 0,   ✅

  File? restaurantPreview;
  File? restaurantLogo;
  File? dish1;
  File? dish2;
  File? dish3;

  List<String> restaurantCategories = [];

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // Get file path
    );

    if (result != null) {
      setState(() {
        restaurantPreview = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.read(restaurantInfoCardListProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                const Text('Create Restaurant'),
                GestureDetector(
                  onTap: () async {
                    try {
                      final restaurantInfoObject = await getRestaurantDetails(
                          locationPrediction.placeId!);
                      print(restaurantInfoObject);

                      // final restaurantReviews = restaurantInfoObject['rating'];
                      // safePrint(restaurantReviews); // double

                      // final totalRestaurantReviews =
                      //     restaurantInfoObject['number_of_reviews'];
                      // //safePrint(totalRestaurantReviews); //int
                      //
                      // final restaurantHours =
                      //     convertToTime(restaurantInfoObject["opening_hours"]);
                      // FocusScope.of(context).unfocus();

                      HapticFeedback.heavyImpact();
                      // Upload file using Amplify Storage

                      // final result = await Amplify.Storage.uploadFile(
                      //   path: StoragePath.fromString(
                      //       'public/${restaurantPreview?.uri.pathSegments.last}'),
                      //   localFile: AWSFile.fromPath(restaurantPreview!.path),
                      // ).result;
                      //
                      // await restaurant.addRestaurantInfo(
                      //     restaurantName: restaurantNameController.text.trim(),
                      //     restaurantAddress: '',
                      //     restaurantImageSrc: '',
                      //     restaurantImageLogo: '',
                      //     restaurantAttributes: [],
                      //     latLng: LatLong(latitude: '', longitude: ''),
                      //     restaurantHours: restaurantHours,
                      //     restaurantRatings: 1.0,
                      //     numRestaurantReviews: 100,
                      //     restaurantDiscountPercentage: '10',
                      //     restaurantTopItemName: [],
                      //     restaurantTopItemImage: []);

                      // safePrint(
                      //     'Successfully uploaded file: ${result.uploadedItem.path}');
                      // if (context.mounted) {
                      //   Navigator.pop(context);
                      // }
                    } on StorageException catch (e) {
                      safePrint(e.message);
                    }
                  },
                  child: const CustomCheckBox(
                    color: AppTheme.kGreen2,
                    iconData: Icons.check,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ImagePickerPreview(
                imageFile: restaurantPreview,
                onImagePicked: (file) =>
                    setState(() => restaurantPreview = file),
                label: 'Restaurant Preview',
              ),
              const SizedBox(height: 10),
              ImagePickerPreview(
                imageFile: restaurantLogo,
                onImagePicked: (file) => setState(() => restaurantLogo = file),
                label: 'Restaurant Logo',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ImagePickerPreview(
                    imageFile: dish1,
                    onImagePicked: (file) => setState(() => dish1 = file),
                    label: 'Dish 1',
                    height: 100,
                    width: (MediaQuery.of(context).size.width / 3) - 10,
                  ),
                  ImagePickerPreview(
                    imageFile: dish2,
                    onImagePicked: (file) => setState(() => dish2 = file),
                    label: 'Dish 2',
                    height: 100,
                    width: (MediaQuery.of(context).size.width / 3) - 10,
                  ),
                  ImagePickerPreview(
                    imageFile: dish3,
                    onImagePicked: (file) => setState(() => dish3 = file),
                    label: 'Dish 3',
                    height: 100,
                    width: (MediaQuery.of(context).size.width / 3) - 10,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: restaurantNameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Restaurant Name',
                        labelStyle: const TextStyle(color: Color(0xff2E2E2E)),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.round),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff2E2E2E), width: 2),
                          borderRadius: BorderRadius.circular(AppTheme.round),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [Text('Search Restaurant')],
                    ),
                    GooglePlaceAutoCompleteTextField(
                      containerHorizontalPadding: 10,
                      textEditingController: gMapsTextController,
                      googleAPIKey: dotenv.get("GOOGLE_MAPS_API_KEY"),
                      itemClick: (prediction) {
                        if (prediction.description != null) {
                          gMapsTextController.text = prediction.description!;
                        }
                        setState(() {
                          locationPrediction = prediction;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        safePrint(restaurantCategories);
                        final response = await editProperty(
                          context: context,
                          restaurantCategories: restaurantCategories,
                        );
                        if (response.isNotEmpty) {
                          updateRestaurantCategories(response);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppTheme.kGreen2,
                          borderRadius: BorderRadius.circular(AppTheme.round),
                        ),
                        child: const Text(
                          '+ Add Restaurant Tags',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    tags.isNotEmpty
                        ? SizedBox(
                            height: 40,
                            child: ListView.builder(
                              itemCount: tags.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return tags[index];
                              },
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: discountController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Discount Percentage',
                        labelStyle: const TextStyle(color: Color(0xff2E2E2E)),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.round),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff2E2E2E), width: 2),
                          borderRadius: BorderRadius.circular(AppTheme.round),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 200,
                    )
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

class SizedBoxWithImage extends StatelessWidget {
  const SizedBoxWithImage({
    super.key,
    required File restaurant,
  }) : _restaurant = restaurant;

  final File _restaurant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        width: double.infinity / 2,
        child: Image.file(_restaurant));
  }
}

class PickImageIcon extends StatelessWidget {
  const PickImageIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30)),
        child: const Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
          size: 40,
        ));
  }
}
