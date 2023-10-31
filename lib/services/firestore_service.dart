import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_auth_test/model/user_model.dart';
import 'package:flutter_auth_test/services/auth_service.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference images =
      FirebaseFirestore.instance.collection('Images');
  AuthService _auth = AuthService();


  Future<UserModel?> getUserData() async {
    try {
      DocumentSnapshot documentSnapshot =
      await images.doc(_auth.currentUser()!.uid).get();
      final data = documentSnapshot.data() as Map<String, dynamic>;
      return UserModel.fromMap(data);
    } catch (e) {
      print("Error retrieving data: $e");
    }
  }

  addImage(String url) async {
    try {
      DocumentReference doc = images.doc(_auth.currentUser()!.uid);
      UserModel userModel = UserModel(
          id: doc.id,
          email: _auth.currentUser()!.email ?? "email is null",
          imageUrl: url);
      await doc.set(userModel.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
