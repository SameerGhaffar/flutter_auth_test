import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Functions {
  Future<File?> pickImage() async {
    try {
      ImagePicker picker = ImagePicker();
      // You can change this to ImageSource.camera or ImageSource.gallery as needed.
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
}
