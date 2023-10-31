import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth_test/model/user_model.dart';
import 'package:flutter_auth_test/services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseService service = FirebaseService();
  UserModel? userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    userData = await service.getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: userData == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Card(
                elevation: 5,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //gfhgfhgf
                      CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.3),
                        maxRadius: 90,
                        minRadius: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Image.network(
                            userData!.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(userData!.email),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
