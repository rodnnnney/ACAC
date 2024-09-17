import 'dart:io';

import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/widgets/ui/CustomCheckBox.dart';
import 'package:ACAC/common/widgets/ui/confirm_quit.dart';
import 'package:ACAC/features/home/controller/marketing_card_controller.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewMarketingCard extends ConsumerStatefulWidget {
  const NewMarketingCard();

  @override
  ConsumerState<NewMarketingCard> createState() => _NewMarketingCardState();
}

class _NewMarketingCardState extends ConsumerState<NewMarketingCard> {
  late TextEditingController headerText;
  late TextEditingController descriptionText;
  final double round = 7.0;
  File? marketingCardFile;

  // Required Elements:
  // imageUrl
  // headerText
  // descriptionText

  @override
  void initState() {
    super.initState();
    headerText = TextEditingController();
    descriptionText = TextEditingController();
  }

  @override
  void dispose() {
    headerText.dispose();
    descriptionText = TextEditingController();
    super.dispose();
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // Get file path
    );

    if (result != null) {
      setState(() {
        marketingCardFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final marketing = ref.read(marketingCardControllerProvider.notifier);
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
                GestureDetector(
                  onTap: () async {
                    safePrint(marketingCardFile!.path);
                    safePrint(headerText.text);
                    safePrint(headerText.text);
                    if (marketingCardFile!.path != '' &&
                        headerText.text.isNotEmpty &&
                        descriptionText.text.isNotEmpty) {
                      try {
                        safePrint('here');
                        FocusScope.of(context).unfocus();
                        HapticFeedback.heavyImpact();
                        final result = await Amplify.Storage.uploadFile(
                          path: StoragePath.fromString(
                              'public/${marketingCardFile!.uri.pathSegments.last}'),
                          localFile: AWSFile.fromPath(marketingCardFile!.path),
                        ).result;
                        await marketing.addMarketingCard(
                            imageUrl:
                                ('${dotenv.get("S3PATH")}${result.uploadedItem.path}'),
                            headerText: headerText.text,
                            descriptionText: descriptionText.text);
                        safePrint(
                            'Successfully uploaded file: ${result.uploadedItem.path}');
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } on StorageException catch (e) {
                        safePrint(e.message);
                      }
                    }
                    return;
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
              GestureDetector(
                onTap: () async {
                  pickImage();
                },
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: marketingCardFile != null
                        ? DecorationImage(
                            image: FileImage(marketingCardFile!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppTheme.roundedRadius * 5),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.camera_alt_outlined,
                            size: 50, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: headerText,
                      decoration: InputDecoration(
                        labelText: 'Header Text',
                        labelStyle: const TextStyle(color: Color(0xff2E2E2E)),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(round),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff2E2E2E), width: 2),
                          borderRadius: BorderRadius.circular(round),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(round),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(round),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionText,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Description Text',
                        alignLabelWithHint: true,
                        labelStyle: const TextStyle(color: Color(0xff2E2E2E)),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(round),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff2E2E2E), width: 2),
                          borderRadius: BorderRadius.circular(round),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(round),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(round),
                        ),
                      ),
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
