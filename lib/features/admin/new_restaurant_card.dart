import 'dart:io';

import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/widgets/ui/CustomCheckBox.dart';
import 'package:ACAC/common/widgets/ui/confirm_quit.dart';
import 'package:ACAC/common/widgets/ui/response_pop_up.dart';
import 'package:ACAC/features/admin/helper_ui/PreviewImagePick.dart';
import 'package:ACAC/features/admin/helper_ui/restaurant_category.dart';
import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:ACAC/features/home/helper_widgets/card/additional_data_dbb.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart'
    as googlePrediction;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'helper_ui/gmaps_api.dart';

class NewRestaurantCard extends ConsumerStatefulWidget {
  const NewRestaurantCard({
    super.key,
    this.card,
  });

  final RestaurantInfoCard? card;

  @override
  ConsumerState<NewRestaurantCard> createState() => _NewRestaurantCardState();
}

class _NewRestaurantCardState extends ConsumerState<NewRestaurantCard> {
  late TextEditingController restaurantNameController;
  late TextEditingController gMapsTextController;
  late TextEditingController discountController;
  late TextEditingController discountDescriptionController;
  late TextEditingController dish1Title;
  late TextEditingController dish2Title;
  late TextEditingController dish3Title;
  googlePrediction.Prediction locationPrediction =
      googlePrediction.Prediction();
  List<PropertyTag> tags = [];
  File? restaurantPreview;
  File? restaurantLogo;
  File? dish1;
  File? dish2;
  File? dish3;
  List<String> restaurantCategories = [];

  // googleMapsId: locationPrediction.placeId!,
  // googleMapsTextBox: locationPrediction.description!);
  // safePrint
  @override
  void initState() {
    if (widget.card != null) {
      setState(() {});

      gMapsTextController =
          TextEditingController(text: widget.card!.gMapsTextInput);
      restaurantNameController =
          TextEditingController(text: widget.card!.restaurantName);
      discountController =
          TextEditingController(text: widget.card!.discountPercent);
      discountController =
          TextEditingController(text: widget.card!.discountPercent);
      discountDescriptionController =
          TextEditingController(text: widget.card!.discountDescription);
      dish1Title =
          TextEditingController(text: widget.card!.topRatedItemsName[0]);
      dish2Title =
          TextEditingController(text: widget.card!.topRatedItemsName[1]);
      dish3Title =
          TextEditingController(text: widget.card!.topRatedItemsName[2]);
      restaurantCategories = widget.card!.cuisineType;
      updateRestaurantCategories(restaurantCategories);
      pullAllImages();
    } else {
      restaurantNameController = TextEditingController();
      gMapsTextController = TextEditingController();
      discountController = TextEditingController();
      discountDescriptionController = TextEditingController();
      dish1Title = TextEditingController();
      dish2Title = TextEditingController();
      dish3Title = TextEditingController();
    }
    super.initState();
  }

  Future<void> pullAllImages() async {
    List<File?> files = await Future.wait([
      downloadAndSaveImage(widget.card!.imageSrc),
      downloadAndSaveImage(widget.card!.imageLogo),
      downloadAndSaveImage(widget.card!.topRatedItemsImgSrc[0]),
      downloadAndSaveImage(widget.card!.topRatedItemsImgSrc[1]),
      downloadAndSaveImage(widget.card!.topRatedItemsImgSrc[2]),
    ]);
    safePrint(files);
    setState(() {
      restaurantPreview = files[0];
      restaurantLogo = files[1];
      if (files[2] != null) {
        dish1 = files[3];
      }
      if (files[3] != null) {
        dish2 = files[3];
      }
      if (files[4] != null) {
        dish3 = files[4];
      }
    });
  }

  @override
  void dispose() {
    restaurantNameController.dispose();
    gMapsTextController.dispose();
    discountController.dispose();
    dish1Title.dispose();
    dish2Title.dispose();
    dish3Title.dispose();
    super.dispose();
  }

  bool areFilesNotNull() {
    return restaurantPreview != null &&
        restaurantLogo != null &&
        dish1 != null &&
        dish2 != null &&
        dish3 != null;
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

  Future<String?> _uploadFile(String path, File? file) async {
    if (file == null) return null;
    try {
      final result = await Amplify.Storage.uploadFile(
        path: StoragePath.fromString(path),
        localFile: AWSFile.fromPath(file.path),
      ).result;
      return result.uploadedItem.path;
    } catch (e) {
      safePrint("Error uploading file $e");
    }
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
  // timesVisited: 0, ✅

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
                widget.card != null
                    ? const Text('Edit Restaurant')
                    : const Text('Create Restaurant'),
                widget.card != null
                    ? GestureDetector(
                        onTap: () async {
                          if (restaurantNameController.text.isEmpty ||
                              discountController.text.isEmpty ||
                              restaurantCategories.length >= 2 ||
                              dish1Title.text.isEmpty ||
                              dish2Title.text.isEmpty ||
                              dish3Title.text.isEmpty) {
                            setState(() {
                              const ResponsePopUp(
                                      response: "Fill out "
                                          "necessary fields",
                                      location: DelightSnackbarPosition.top,
                                      icon: Icons.error_outline,
                                      color: Colors.redAccent)
                                  .showToast(context);
                            });
                            return;
                          }

                          safePrint("EDITING");
                          try {
                            final restaurantInfoObject =
                                await getRestaurantDetails(
                                    widget.card!.googlePlacesId);
                            final s3path = dotenv.get("S3PATH");
                            //getting address
                            final restaurantAddress =
                                restaurantInfoObject['address'];
                            int comma =
                                restaurantAddress.toString().indexOf(',');
                            safePrint(restaurantAddress
                                .toString()
                                .substring(0, comma));
                            safePrint(restaurantInfoObject);

                            final websiteUrl = restaurantInfoObject['website'];
                            final phoneNumber =
                                restaurantInfoObject['phone_number'];

                            //('${dotenv.get("S3PATH")}${result.uploadedItem.path}'),

                            final restaurantRating =
                                restaurantInfoObject['rating'];
                            // safePrint(restaurantReviews); // double

                            final totalRestaurantReviews =
                                restaurantInfoObject['number_of_reviews'];
                            // //safePrint(totalRestaurantReviews); //int
                            //
                            final restaurantHours = convertToTime(
                                restaurantInfoObject["opening_hours"]);
                            // FocusScope.of(context).unfocus();

                            HapticFeedback.heavyImpact();
                            // Upload file using Amplify Storage

                            final uploadTasks = [
                              _uploadFile(
                                  'public/${restaurantPreview?.uri.pathSegments.last}',
                                  restaurantPreview),
                              _uploadFile(
                                  'public/${restaurantLogo?.uri.pathSegments.last}',
                                  restaurantLogo),
                              _uploadFile(
                                  'public/${dish1?.uri.pathSegments.last}',
                                  dish1),
                              _uploadFile(
                                  'public/${dish2?.uri.pathSegments.last}',
                                  dish2),
                              _uploadFile(
                                  'public/${dish3?.uri.pathSegments.last}',
                                  dish3),
                            ];

                            final results = await Future.wait(uploadTasks);

                            safePrint(results);

                            final rest1 = widget.card!.copyWith(
                              restaurantName:
                                  restaurantNameController.text.trim(),
                              address: restaurantAddress
                                  .toString()
                                  .substring(0, comma),
                              imageSrc: "$s3path${results[0]!}",
                              imageLogo: "$s3path${results[1]!}",
                              cuisineType: restaurantCategories,
                              location: LatLong(
                                  latitude: widget.card!.location.latitude,
                                  longitude: widget.card!.location.longitude),
                              hours: restaurantHours,
                              rating: restaurantRating,
                              reviewNum: totalRestaurantReviews,
                              discountPercent: discountController.text,
                              topRatedItemsName: [
                                dish1Title.text,
                                dish2Title.text,
                                dish3Title.text
                              ],
                              topRatedItemsImgSrc: [
                                "$s3path${results[2]!}",
                                "$s3path${results[3]!}",
                                "$s3path${results[4]!}",
                              ],
                              phoneNumber: phoneNumber.toString(),
                              websiteLink: websiteUrl.toString(),
                              discountDescription:
                                  discountDescriptionController.text,
                              gMapsLink:
                                  "${AppTheme.gmapsLink}${locationPrediction.placeId}",
                              googlePlacesId: locationPrediction.placeId ??
                                  widget.card?.googlePlacesId,
                              gMapsTextInput: locationPrediction.description ??
                                  widget.card?.gMapsTextInput,
                            );

                            await restaurant.updateRestInfo(rest1);
                            safePrint('Successfully uploaded file: $results');
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } on StorageException catch (e) {
                            safePrint(e.message);
                          }
                        },
                        child: const CustomCheckBox(
                          color: AppTheme.kGreen2,
                          iconData: Icons.check,
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          if (restaurantNameController.text.isEmpty ||
                              discountController.text.isEmpty ||
                              restaurantCategories.length >= 2 ||
                              dish1Title.text.isEmpty ||
                              dish2Title.text.isEmpty ||
                              dish3Title.text.isEmpty ||
                              areFilesNotNull()) {
                            setState(() {
                              const ResponsePopUp(
                                      response: "Fill out "
                                          "necessary fields",
                                      location: DelightSnackbarPosition.top,
                                      icon: Icons.error_outline,
                                      color: Colors.redAccent)
                                  .showToast(context);
                              return;
                            });
                          } else {
                            safePrint('CREATING NEW');
                            try {
                              final restaurantInfoObject =
                                  await getRestaurantDetails(
                                      locationPrediction.placeId!);
                              final s3path = dotenv.get("S3PATH");
                              //getting address
                              final restaurantAddress =
                                  restaurantInfoObject['address'];
                              int comma =
                                  restaurantAddress.toString().indexOf(',');
                              safePrint(restaurantAddress
                                  .toString()
                                  .substring(0, comma));
                              // getting lat lng
                              final latitude = locationPrediction.lat;
                              final longitude = locationPrediction.lng;

                              safePrint(restaurantInfoObject);

                              final websiteUrl =
                                  restaurantInfoObject['website'];
                              final phoneNumber =
                                  restaurantInfoObject['phone_number'];

                              //('${dotenv.get("S3PATH")}${result.uploadedItem.path}'),

                              final restaurantRating =
                                  restaurantInfoObject['rating'];
                              // safePrint(restaurantReviews); // double

                              final totalRestaurantReviews =
                                  restaurantInfoObject['number_of_reviews'];
                              // //safePrint(totalRestaurantReviews); //int
                              //
                              final restaurantHours = convertToTime(
                                  restaurantInfoObject["opening_hours"]);
                              // FocusScope.of(context).unfocus();

                              HapticFeedback.heavyImpact();
                              // Upload file using Amplify Storage

                              final uploadTasks = [
                                _uploadFile(
                                    'public/${restaurantPreview?.uri.pathSegments.last}',
                                    restaurantPreview),
                                _uploadFile(
                                    'public/${restaurantLogo?.uri.pathSegments.last}',
                                    restaurantLogo),
                                _uploadFile(
                                    'public/${dish1?.uri.pathSegments.last}',
                                    dish1),
                                _uploadFile(
                                    'public/${dish2?.uri.pathSegments.last}',
                                    dish2),
                                _uploadFile(
                                    'public/${dish3?.uri.pathSegments.last}',
                                    dish3),
                              ];

                              final results = await Future.wait(uploadTasks);

                              safePrint(results);

                              await restaurant.addRestaurantInfo(
                                restaurantName:
                                    restaurantNameController.text.trim(),
                                restaurantAddress: restaurantAddress
                                    .toString()
                                    .substring(0, comma),
                                restaurantImageSrc: "$s3path${results[0]!}",
                                restaurantImageLogo: "$s3path${results[1]!}",
                                restaurantAttributes: restaurantCategories,
                                latLng: LatLong(
                                    latitude: latitude!, longitude: longitude!),
                                restaurantHours: restaurantHours,
                                restaurantRatings: restaurantRating,
                                numRestaurantReviews: totalRestaurantReviews,
                                restaurantDiscountPercentage:
                                    discountController.text,
                                restaurantTopItemName: [
                                  dish1Title.text,
                                  dish2Title.text,
                                  dish3Title.text
                                ],
                                restaurantTopItemImage: [
                                  "$s3path${results[2]!}",
                                  "$s3path${results[3]!}",
                                  "$s3path${results[4]!}",
                                ],
                                restaurantPhoneNumber: phoneNumber.toString(),
                                websiteUrl: websiteUrl.toString(),
                                restaurantDiscountDescription:
                                    discountDescriptionController.text,
                                restaurantGoogleMapsLink:
                                    "${AppTheme.gmapsLink}${locationPrediction.placeId}",
                                googleMapsId: locationPrediction.placeId!,
                                googleMapsTextBox:
                                    locationPrediction.description!,
                              );
                              safePrint('Successfully uploaded file: $results');
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } on StorageException catch (e) {
                              safePrint(e.message);
                            }
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Row(
                      children: [Text('Search Restaurant*')],
                    ),
                    GooglePlaceAutoCompleteTextField(
                      containerHorizontalPadding: 10,
                      textEditingController: gMapsTextController,
                      googleAPIKey: dotenv.get("GOOGLE_MAPS_API_KEY"),
                      itemClick: (googleMapsGeneratedPrediction) {
                        if (googleMapsGeneratedPrediction.description != null) {
                          gMapsTextController.text =
                              googleMapsGeneratedPrediction.description!;
                        }
                        setState(() {
                          locationPrediction = googleMapsGeneratedPrediction;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: restaurantNameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Restaurant Name*',
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
                          '+ Add Restaurant Tags*',
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
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: discountController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Discount Percentage*',
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
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: discountDescriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Discount Description',
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
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ImagePickerPreview(
                imageFile: restaurantPreview,
                onImagePicked: (file) =>
                    setState(() => restaurantPreview = file),
                label: 'Restaurant Preview*',
              ),
              const SizedBox(height: 10),
              ImagePickerPreview(
                imageFile: restaurantLogo,
                onImagePicked: (file) => setState(() => restaurantLogo = file),
                label: 'Restaurant Logo*',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ImagePickerPreview(
                    imageFile: dish1,
                    onImagePicked: (file) => setState(() => dish1 = file),
                    label: 'Dish 1*',
                    height: 100,
                    width: (MediaQuery.of(context).size.width / 3) - 10,
                  ),
                  ImagePickerPreview(
                    imageFile: dish2,
                    onImagePicked: (file) => setState(() => dish2 = file),
                    label: 'Dish 2*',
                    height: 100,
                    width: (MediaQuery.of(context).size.width / 3) - 10,
                  ),
                  ImagePickerPreview(
                    imageFile: dish3,
                    onImagePicked: (file) => setState(() => dish3 = file),
                    label: 'Dish 3*',
                    height: 100,
                    width: (MediaQuery.of(context).size.width / 3) - 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: dish1Title,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Dish 1 Name*',
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
                      height: 12,
                    ),
                    TextFormField(
                      controller: dish2Title,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Dish 2 Name*',
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
                      height: 12,
                    ),
                    TextFormField(
                      controller: dish3Title,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Dish 3 Name*',
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
                  ],
                ),
              ),
              const SizedBox(
                height: 6,
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
