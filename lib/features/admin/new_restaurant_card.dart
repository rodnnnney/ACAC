import 'dart:io';

import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/widgets/ui/CustomCheckBox.dart';
import 'package:ACAC/common/widgets/ui/confirm_quit.dart';
import 'package:ACAC/features/admin/helper_ui/PreviewImagePick.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewRestaurantCard extends ConsumerStatefulWidget {
  const NewRestaurantCard({super.key});

  @override
  ConsumerState<NewRestaurantCard> createState() => _NewRestaurantCardState();
}

class _NewRestaurantCardState extends ConsumerState<NewRestaurantCard> {
  late TextEditingController RestaurantNameController;
  late TextEditingController descriptionTextController;
  late TextEditingController gMapsTextController;
  Prediction locationPrediction = Prediction();

  @override
  void initState() {
    super.initState();
    RestaurantNameController = TextEditingController();
    descriptionTextController = TextEditingController();
    gMapsTextController = TextEditingController();
  }

  @override
  void dispose() {
    RestaurantNameController.dispose();
    descriptionTextController.dispose();
    gMapsTextController.dispose();
    super.dispose();
  }

  // 1. restaurantName: restaurantName, ✅
  // 2. location: LatLong(latitude: x, longitude: y), ✅
  // 3. address: '', ✅
  // 4. imageSrc: '',  ✅
  // 5. imageLogo: '', ✅
  // 6. scannerDataMatch: '', ✅
  // 7. hours: Time ✅
  // 8. rating: rating, ✅
  // 9. cuisineType: [], ❌
  // 10. reviewNum: reviewNum,  ✅
  // 11. discounts: [],
  // 12. discountPercent: '',
  // 13. phoneNumber: '', ✅
  // 14. gMapsLink: '',  ✅
  // 15. websiteLink: '',✅
  // 16. topRatedItemsImgSrc: [], ❌
  // 17. topRatedItemsName: [], ❌
  // timesVisited: 0,

  File? restaurantPreview;
  File? restaurantLogo;
  File? dish1;
  File? dish2;
  File? dish3;

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
                          destination: () {},
                          title: '',
                          subtitle: '',
                          actionButton: '',
                        );
                        // final data = await getPlaceDetails(
                        //     locationPrediction.placeId!);
                        // safePrint(data);
                        //
                        // final obj = parseOpeningHours(data);
                        // safePrint(obj);
                      },
                    );
                  },
                  child: const CustomCheckBox(
                    color: AppTheme.kAlertRed,
                    iconData: Icons.close,
                  ),
                ),
                GestureDetector(
                  // onTap: () async {
                  //   if (restaurantPreview.path != '' &&
                  //       RestaurantNameController.text.isNotEmpty &&
                  //       descriptionTextController.text.isNotEmpty) {
                  //     try {
                  //       FocusScope.of(context).unfocus();
                  //       HapticFeedback.heavyImpact();
                  //       // Upload file using Amplify Storage
                  //       final result = await Amplify.Storage.uploadFile(
                  //         path: StoragePath.fromString(
                  //             'public/${_restaurant.uri.pathSegments.last}'),
                  //         // onProgress: (progress) {
                  //         //   safePrint(
                  //         //       'Fraction completed: ${progress.fractionCompleted}');
                  //         // },
                  //         localFile: AWSFile.fromPath(_restaurant.path),
                  //       ).result;
                  //       await marketing.addMarketingCard(
                  //           imageUrl:
                  //               ('${dotenv.get("S3PATH")}${result.uploadedItem.path}'),
                  //           headerText: RestaurantNameController.text,
                  //           descriptionText: descriptionTextController.text);
                  //       safePrint(
                  //           'Successfully uploaded file: ${result.uploadedItem.path}');
                  //       if (context.mounted) {
                  //         Navigator.pop(context);
                  //       }
                  //     } on StorageException catch (e) {
                  //       safePrint(e.message);
                  //     }
                  //   }
                  //   return;
                  // },
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
                    width: 100,
                  ),
                  ImagePickerPreview(
                    imageFile: dish2,
                    onImagePicked: (file) => setState(() => dish2 = file),
                    label: 'Dish 2',
                    height: 100,
                    width: 100,
                  ),
                  ImagePickerPreview(
                    imageFile: dish3,
                    onImagePicked: (file) => setState(() => dish3 = file),
                    label: 'Dish 3',
                    height: 100,
                    width: 100,
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
                      controller: RestaurantNameController,
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
                      onTap: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return RestaurantCategory();
                        //     });
                      },
                      child: Container(
                        child: Text('Button'),
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
