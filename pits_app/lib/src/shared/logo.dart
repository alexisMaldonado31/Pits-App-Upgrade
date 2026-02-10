import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit fit;
  final String tag;
  const Logo({
    super.key,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.tag = "",
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Container(
        height: height,
        width: width,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/logos/LogoApp.png"),
            fit: fit,
          ),
        ),
      ),
    );
  }
}
