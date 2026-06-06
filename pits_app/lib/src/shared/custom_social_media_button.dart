import 'package:flutter/material.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class CustomSocialMediaButton extends StatelessWidget {
  final IconData icon;
  final String nameSocialMedia;
  final Color color;
  final VoidCallback onTap;

  const CustomSocialMediaButton({
    super.key,
    required this.icon,
    required this.nameSocialMedia,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: screenSize.height * 0.015),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              ),
              onPressed: onTap,
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.04),
                  child: Row(
                    children: [
                      Icon(icon, size: screenSize.height * 0.025),
                      VerticalDivider(
                        thickness: 0.5,
                        width: 20,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Center(
                          child: CustomText(
                            text: nameSocialMedia,
                            colorText: Colors.white,
                            textAlign: TextAlign.left,
                            fontSize: screenSize.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}