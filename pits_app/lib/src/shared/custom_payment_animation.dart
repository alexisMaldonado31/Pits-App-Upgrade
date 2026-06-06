import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class CustomPaymentAnimation extends StatefulWidget {
  const CustomPaymentAnimation({super.key});

  @override
  State<CustomPaymentAnimation> createState() => _CustomPaymentAnimationState();
}

class _CustomPaymentAnimationState extends State<CustomPaymentAnimation> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final config = AppConfig.of(context);

    return AlertDialog(
      backgroundColor: config.primary,
      title: CustomText(
        text: "Tu orden se ha registrado con éxito. ¡Te esperamos!",
        colorText: config.accent,
        fontSize: screenSize.width * 0.04,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.bold,
      ),
      content: SizedBox(
        height: screenSize.height * 0.4,
        width: screenSize.width * 0.6,
        child: Image.asset(
          "assets/gifs/paymentOrder.gif",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}