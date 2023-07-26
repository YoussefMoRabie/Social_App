import 'package:flutter/material.dart';
import 'package:social_app/theme/pallete.dart';

class CustomSubmitButton extends StatelessWidget {
  const CustomSubmitButton(
      {super.key, required this.label, required this.onPressed});
  final Widget label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Palette.primary,
          minimumSize: const Size(double.infinity, 50)),
      onPressed: onPressed,
      child: label,
    );
  }
}
