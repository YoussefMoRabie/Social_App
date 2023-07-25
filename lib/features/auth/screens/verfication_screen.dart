import 'package:flutter/material.dart';

class VerficationScreen extends StatefulWidget {
  const VerficationScreen(
      {super.key, required this.email, required this.password});
  final String email;
  final String password;

  @override
  State<VerficationScreen> createState() => _VerficationScreenState();
}

class _VerficationScreenState extends State<VerficationScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.email);
    print(widget.password);

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
                    "Did your friend give you a key? 🔑",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              // //form
              // Form(
              //   key: _formKey,
              //   child: Column(
              //     children: [
              //       CustomTextField(
              //         controller: emailController,
              //         validator: (p0) => emailValidator(p0),
              //         icon: Icons.email,
              //         hintText: "Email",
              //         keyboardType: TextInputType.emailAddress,
              //       ),
              //       const SizedBox(
              //         height: 30,
              //       ),
              //       CustomTextField(
              //         controller: passController,
              //         validator: (p0) => passValidator(p0),
              //         icon: Icons.key,
              //         isPassword: true,
              //         hintText: "Password",
              //         keyboardType: TextInputType.text,
              //       ),
              //       const SizedBox(
              //         height: 30,
              //       ),
              //       CustomTextField(
              //         controller: passConfirmationController,
              //         validator: (p0) =>
              //             passConfirmValidator(p0, passController.text),
              //         icon: Icons.key,
              //         isPassword: true,
              //         hintText: "Confirm Password",
              //         keyboardType: TextInputType.text,
              //       ),
              //     ],
              //   ),
              // ),
              // Column(
              //   children: [
              //     Consumer(
              //       builder: (context, ref, child) => CustomSubmitButton(
              //         label: "Sign Up",
              //         onPressed: () => _submitForm(ref),
              //       ),
              //     ),
              //     ScreenToggleButton(
              //         onPressed: widget.toggleScreen,
              //         buttonLabel: "Log In",
              //         message: "already a member?"),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
