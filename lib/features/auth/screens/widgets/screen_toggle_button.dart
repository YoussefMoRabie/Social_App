import 'package:flutter/material.dart';

import '../../../../theme/pallete.dart';

class ScreenToggleButton extends StatelessWidget {
  const ScreenToggleButton(
      {super.key,
      required this.onPressed,
      required this.buttonLabel,
      required this.message});
  final void Function() onPressed;
  final String message;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            // backgroundColor: Pallete.primary,
            foregroundColor: Pallete.primary,
          ),
          child: Text(
            buttonLabel,
          ),
        ),
      ],
    );
  }
}
