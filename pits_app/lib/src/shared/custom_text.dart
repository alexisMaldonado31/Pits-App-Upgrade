import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color colorText;
  final TextAlign textAlign;
  final TextDecoration textDecoration;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 10.0,
    this.fontWeight = FontWeight.normal,
    this.colorText = Colors.black,
    this.textAlign = TextAlign.left,
    this.textDecoration = TextDecoration.none,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(
        fontSize: this.fontSize,
        fontWeight: this.fontWeight,
        fontFamily: 'Gothic',
        color: colorText,
        decoration: this.textDecoration,
      ),
      textAlign: textAlign,
      textScaleFactor: 1,
    );
  }
}
