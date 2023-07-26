import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/auth/screens/widgets/custom_submit_button.dart';
import 'package:social_app/features/auth/screens/widgets/custom_text_field.dart';
import 'package:social_app/features/auth/screens/widgets/screen_toggle_button.dart';

import '../controller/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.toggleScreen});
  final void Function() toggleScreen;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final passConfirmationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitForm(
    WidgetRef ref,
  ) {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).signUp(
          context, emailController.text.trim(), passController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * 0.9,
          height: size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //title of the screen
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  child: const Text(
                    "Create New Account 🔥",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              //form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: emailController,
                      validator: (p0) => emailValidator(p0),
                      icon: Icons.email,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      controller: passController,
                      validator: (p0) => passValidator(p0),
                      icon: Icons.key,
                      isPassword: true,
                      hintText: "Password",
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      controller: passConfirmationController,
                      validator: (p0) =>
                          passConfirmValidator(p0, passController.text),
                      icon: Icons.key,
                      isPassword: true,
                      hintText: "Confirm Password",
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Consumer(
                    builder: (context, ref, child) => CustomSubmitButton(
                      label: "Sign Up",
                      onPressed: () => _submitForm(ref),
                    ),
                  ),
                  ScreenToggleButton(
                      onPressed: widget.toggleScreen,
                      buttonLabel: "Log In",
                      message: "already a member?"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
