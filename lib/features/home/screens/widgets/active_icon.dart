import 'package:flutter/material.dart';

import '../../../../theme/pallete.dart';

class ActiveIcon extends StatelessWidget {
  final IconData icon;

  const ActiveIcon({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Palette.primary,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
