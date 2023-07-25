import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/auth/screens/widgets/custom_submit_button.dart';
import 'package:social_app/features/auth/screens/widgets/custom_text_field.dart';
import 'package:social_app/features/auth/screens/widgets/screen_toggle_button.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.toggleScreen});
  final void Function() toggleScreen;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final passConfirmationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitForm(
    WidgetRef ref,
  ) {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).signIn(
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
                    "Welcome Back 👋",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              //form
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  ],
                ),
              ),
              Column(
                children: [
                  Consumer(
                    builder: (context, ref, child) => CustomSubmitButton(
                      label: "Log In",
                      onPressed: () => _submitForm(ref),
                    ),
                  ),
                  ScreenToggleButton(
                      onPressed: widget.toggleScreen,
                      buttonLabel: "Sign Up",
                      message: "Don't have an account?")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
