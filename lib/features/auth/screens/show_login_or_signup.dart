import 'package:flutter/material.dart';
import 'package:social_app/features/auth/screens/login_screen.dart';
import 'package:social_app/features/auth/screens/signup_screen.dart';

class ShowLoginOrSignup extends StatefulWidget {
  const ShowLoginOrSignup({super.key});

  @override
  State<ShowLoginOrSignup> createState() => _ShowLoginOrSignupState();
}

class _ShowLoginOrSignupState extends State<ShowLoginOrSignup> {
  bool showLogin = true;

  void toggleScreen() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginScreen(toggleScreen: toggleScreen);
    } else {
      return SignupScreen(toggleScreen: toggleScreen);
    }
  }
}
