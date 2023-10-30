import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_test/login/login_screen.dart';
import 'package:flutter_auth_test/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

import '../functions/funtions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isObscure = true;
  File? selectedImage;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Signup"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap:() => onImageClick(),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.3),
                    maxRadius: 90,
                    minRadius: 80,
                    child: selectedImage != null
                        ? Image.file(selectedImage!)
                        : const Icon(
                            Icons.person,
                            size: 100,
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                myTextField(
                  emailController,
                  "Email",
                  "Enter Email",
                  validator: (v) => emailValidator(v),
                ),
                myTextField(
                  passwordController,
                  "Password",
                  "Password Controller",
                  validator: (v) => passwordValidator(v),
                  isPassword: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                    onPressed: () => onSignUpTap(),
                    child: const Text('SignUp'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Already have a Account ? ',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: ' Login ',
                            style: const TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                    (route) => false);
                              }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: () => onGoogleTap(),
                    child: Card(
                      elevation: 4,
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.all(6),
        
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
        
                          children: [
                            const Spacer(),
                            Image.asset(
                              'assets/images/google.png',
                              width: 35,
                              height: 35,
                            ),
                            const Spacer(),
                            const Text('SignUp With Google',style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myTextField(
      TextEditingController controller, String label, String hint,
      {bool isPassword = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        validator: validator,
        keyboardType: isPassword ? TextInputType.emailAddress : null,
        controller: controller,
        obscureText: isPassword ? isObscure : false,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: () => onEyeTap(),
                  child: isObscure
                      ? const Icon(
                          Icons.visibility_off,
                          color: Colors.black,
                        )
                      : const Icon(
                          Icons.visibility,
                          color: Colors.black,
                        ))
              : null,
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
          border: InputBorder.none,
          fillColor: Colors.black12,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  void onEyeTap() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  String? emailValidator(String? value) {
    String email = emailController.text.toString();
    bool isValid = EmailValidator.validate(email);

    if (value == null || value.isEmpty) {
      return "Email is required";
    } else if (!isValid) {
      return "Please Enter Valid Email";
    }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null; // Return null if the input is valid
  }

  onSignUpTap() async {
    if (formKey.currentState!.validate()) {
      String email = emailController.text.toString();
      String password = passwordController.text.toString();

      bool isUserCreated = await authService.signup(email, password);
      if (isUserCreated) {
        emailController.clear();
        passwordController.clear();
        // navigation

      }
    }
  }

  onGoogleTap() {}
  onImageClick() async {
    Functions functions = Functions();
    selectedImage = await functions.pickImage();



  }
}
