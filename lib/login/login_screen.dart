
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_test/home/home_screen.dart';
import 'package:flutter_auth_test/services/auth_service.dart';
import 'package:flutter_auth_test/signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService authService = AuthService();
  bool isObscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Form(
                key: formKey,
                child: SizedBox(
                  height: 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildTextField(
                        emailController,
                        "Email",
                        "Enter Email",
                        validator: (v) => emailValidator(v),
                      ),
                      buildTextField(
                        passwordController,
                        "Password",
                        "Enter Password",
                        isPassword: true,
                      ),
                      ElevatedButton(
                        onPressed: () => onLoginTap(),
                        child: const Text('Login'),
                      ),
                      RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                                text: 'Need an Account ? ',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: ' SignUp Now ',
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => const SignupScreen(),
                                        ),
                                            (route) => false);
                                  }),
                          ])),



                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  TextFormField buildTextField(TextEditingController emailController, String label, String hint, {bool isPassword = false, String? Function(String?)? validator}) {
    return TextFormField(
      validator: validator,
      keyboardType: isPassword ? TextInputType.emailAddress : null,
      controller: emailController,
      obscureText: isPassword ? isObscure : false,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? GestureDetector(
            onTap: () => onEyeTap(),
            child: isObscure
                ? Icon(
              Icons.visibility_off,
              color: Colors.black,
            )
                : Icon(
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
    );
  }

  void onEyeTap() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  Future<void> onLoginTap() async {
    if (formKey.currentState!.validate()) {
      String password = passwordController.text.toString();
      String email = emailController.text.toString();

      bool isUserLogin = await authService.login(email, password);
      if (isUserLogin) {
        emailController.clear();
        passwordController.clear();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
                (route) => false);
        print('User Logined');
      } else {
        String? error = authService.error;
      }
    }
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

}
