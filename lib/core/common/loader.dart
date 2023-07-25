import 'package:flutter/material.dart';
import '../../theme/pallete.dart';

class Loader extends StatelessWidget {
  final Color? color;
  const Loader({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color != null ? color! : Pallete.white,
      ),
    );
  }
}
