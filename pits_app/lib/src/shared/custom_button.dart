import 'package:flutter/material.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class CustomButton extends StatelessWidget {
  final Color? color;
  final double? height;
  final double fontSize;
  final VoidCallback? onTap;
  final String text;
  final Color colorText;

  const CustomButton({
    super.key,
    required this.text,
    required this.fontSize,
    this.color,
    this.height,
    this.onTap,
    this.colorText = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey.withValues(alpha: 0.3),
        child: Container(
          height: height,
          alignment: Alignment.center,
          child: CustomText(
            text: text,
            colorText: colorText,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
