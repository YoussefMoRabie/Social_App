import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:social_app/core/common/custom_submit_button.dart';
import 'package:social_app/core/common/custom_text_field.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/models/user_model.dart';

import '../../../core/utils.dart';
import '../../../theme/pallete.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _username = TextEditingController();
  UserModel? userData;
  File? image;

  @override
  void initState() {
    userData = ref.read(userProvider);
    _username.text = userData!.name;
    super.initState();
  }

  void updateProfile(BuildContext context, WidgetRef ref) async {
    final res = await pickImage();
    File? image;
    if (res == null) {
      return;
    }
    image = File(res.files.first.path!);
    ref.read(authControllerProvider.notifier).updateProfile(
          context: context,
          currentUser: userData!,
          image: image,
        );
    // ignore: use_build_context_synchronously
  }

  void submitEdit() {
    ref.read(authControllerProvider.notifier).updateProfile(
          context: context,
          currentUser: userData!,
          username: _username.text.trim(),
        );
  }

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
                          child: userData!.profilePic == ""
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 60,
                                )
                              : Image(
                                  image: NetworkImage(userData!.profilePic),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
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
                            onPressed: () => updateProfile(context, ref),
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
                        validator: (p0) {
                          return null;
                        },
                        hintText: "Username",
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                      ),

                      const SizedBox(height: 30),
                      // -- Form Submit Button
                      CustomSubmitButton(
                        label: const Text(
                          "Update Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: submitEdit,
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
