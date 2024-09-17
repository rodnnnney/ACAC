import 'dart:io';

import 'package:ACAC/common/consts/globals.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImagePickerPreview extends StatelessWidget {
  final File? imageFile;
  final Function(File) onImagePicked;
  final String label;
  final double height;
  final double width;

  const ImagePickerPreview({
    Key? key,
    required this.imageFile,
    required this.onImagePicked,
    required this.label,
    this.height = 300,
    this.width = double.infinity,
  }) : super(key: key);

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      onImagePicked(File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(label),
        ),
        GestureDetector(
          onTap: pickImage,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              image: imageFile != null && imageFile!.existsSync()
                  ? DecorationImage(
                      image: FileImage(imageFile!),
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
      ],
    );
  }
}
