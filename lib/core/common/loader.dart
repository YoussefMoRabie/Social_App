import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      child: SpinKitThreeBounce(
        color: color ?? Palette.primary,
        size: 30.0,
      ),
    );
  }
}
