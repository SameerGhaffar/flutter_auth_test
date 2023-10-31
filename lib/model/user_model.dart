import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String id;
  String imageUrl;
  String email;

  UserModel({required this.id, required this.imageUrl, required this.email});

  Map<String, dynamic> toMap() {
    return {'docId': id, 'imageUrl': imageUrl, 'email': email};
  }

  factory UserModel.fromMap( Map<String, dynamic> map) {

    return UserModel(
        id: map['docId'], imageUrl: map["imageUrl"], email: map['email']);
  }
}
