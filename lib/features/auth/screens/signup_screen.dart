import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final keyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitForm(
    WidgetRef ref,
  ) {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).signUp(
          context,
          emailController.text.trim(),
          passController.text.trim(),
          keyController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 100,
        title: Padding(
          padding: EdgeInsets.only(left: size.width * 0.02),
          child: const Text(
            "Create New Account 🔥",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
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
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: size.width * 0.02),
                            child: const Text(
                              "Did your friend give you a key? 🔑",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextField(
                          controller: keyController,
                          validator: (p0) => keyValidator(p0),
                          icon: Icons.key,
                          hintText: "Enter the key",
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Consumer(
                        builder: (context, ref, child) => CustomSubmitButton(
                          label: ref.watch(authControllerProvider)
                          ? const Loader(
                              color: Colors.white,
                            )
                          : const Text(
                              "Sign up",
                              style: TextStyle(color: Colors.white),
                            ),
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
        ),
      ),
    );
  }
}
