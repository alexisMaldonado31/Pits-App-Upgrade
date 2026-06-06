import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String title;
  final String content;
  final Color colorTitle;
  final Color colorContent;
  final double fontSize;

  const CustomRichText({
    super.key,
    required this.title,
    required this.content,
    this.colorContent = Colors.black,
    this.colorTitle = Colors.black,
    this.fontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorTitle,
              fontSize: fontSize,
              fontFamily: 'Gothic',
            ),
          ),
          TextSpan(
            text: content,
            style: TextStyle(
              color: colorContent,
              fontSize: fontSize,
              fontFamily: 'Gothic',
            ),
          ),
        ],
      ),
    );
  }
}