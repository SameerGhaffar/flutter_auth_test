import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_auth_test/services/firestore_service.dart';
import 'package:mime/mime.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseService _firebaseService = FirebaseService();
  Reference _imageRefrence = FirebaseStorage.instance.ref("Images");

  Future<bool> uploadProfilePic(File image) async {
    try {
      final metadata = lookupMimeType(image.path);
      final UploadTask uploadTask = _imageRefrence
          .child(DateTime.now().toIso8601String())
          .putFile(image.absolute, SettableMetadata(contentType: metadata));
      final TaskSnapshot downloadUrl = await uploadTask.whenComplete(() {});
      final String url = (await downloadUrl.ref.getDownloadURL());
      if(await _firebaseService.addImage(url)){
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
