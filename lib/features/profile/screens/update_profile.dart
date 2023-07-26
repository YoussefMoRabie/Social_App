import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:social_app/core/common/custom_submit_button.dart';
import 'package:social_app/core/common/custom_text_field.dart';

import '../../../theme/pallete.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            color: Palette.surface,
                            child: const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 60,
                            ),
                          ),
                        )
                        // child: const Image(
                        //   image: AssetImage("assets/images/profile.jpg"),
                        //   fit: BoxFit.cover,
                        // )),
                        ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Palette.primary),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(LineAwesomeIcons.camera, size: 20),
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // -- Form Fields
                Form(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _username,
                        validator: (p0) {},
                        hintText: "Username",
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: _username,
                        validator: (p0) {},
                        hintText: "Phone Number",
                        icon: Icons.phone,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 30),
                      // -- Form Submit Button
                      CustomSubmitButton(
                        label: const Text(
                          "Update Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
