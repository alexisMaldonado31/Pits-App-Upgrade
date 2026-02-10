import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);
    var size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.width * 0.2,
      width: size.width * 0.2,
      child: Stack(
        children: [
          Align(
            alignment: Alignment(0, 0),
            child: SizedBox(
              height: size.width * 0.15,
              width: size.width * 0.15,
              child: CircularProgressIndicator(
                backgroundColor: config.accent,
                color: config.secondary,
                strokeWidth: size.width * 0.02,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: size.width * 0.15,
              width: size.width * 0.15,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/logos/iconoPITS.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
