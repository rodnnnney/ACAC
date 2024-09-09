import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: GestureDetector(
                  // onTap: () async {
                  //   final picker = ImagePicker();
                  //   final XFile? pickedFile =
                  //       await picker.pickImage(source: ImageSource.gallery);
                  //   if (pickedFile != null) {
                  //     print(pickedFile);
                  //   } else {
                  //     debugPrint('No image selected.');
                  //   }
                  // },
                  child: Icon(Icons.camera_alt_outlined)),
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
                    controller: headerText,
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
    );
  }
}
