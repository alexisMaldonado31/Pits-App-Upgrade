import 'package:flutter/material.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  const CustomTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        CustomText(
          text: text,
          colorText: Colors.white,
          fontSize: screenSize.width * 0.075,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        Divider(color: Colors.white),
        SizedBox(height: screenSize.height * 0.005),
      ],
    );
  }
}