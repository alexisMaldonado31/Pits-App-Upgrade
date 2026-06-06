import 'package:pits_app/src/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Color textColor;
  final EdgeInsets padding;
  final VoidCallback onTap;
  final String text;

  const CustomTextButton({
    required this.text,
    this.textColor = Colors.black,
    this.padding = EdgeInsets.zero,
    required this.onTap,
  });

  EdgeInsetsGeometry getPadding(Set<MaterialState> states) {
    return EdgeInsets.symmetric(horizontal: 0, vertical: 15);
  }

  Color getSplashColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white.withOpacity(0.2);
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: padding,
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith(getPadding),
          overlayColor: MaterialStateColor.resolveWith(getSplashColor),
        ),
        onPressed: onTap,
        child: IntrinsicHeight(
          child: CustomText(
            text: text,
            colorText: textColor,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
            fontSize: screenSize.height * 0.02,
            textDecoration: TextDecoration.underline,
            decorationColor: textColor,  // 👈 mismo color que el texto
          ),
        ),
      ),
    );
  }
}
