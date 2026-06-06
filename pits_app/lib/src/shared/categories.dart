import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/categories_model.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class Categorie extends StatelessWidget {
  final CategoriesModel categorie;
  final VoidCallback onTap;

  const Categorie({
    super.key,
    required this.categorie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: screenSize.height * 0.2,
        width: screenSize.width * 0.27,
        padding: EdgeInsets.all(screenSize.width * 0.03),
        decoration: BoxDecoration(
          color: config.accent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(screenSize.height * 0.015),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: categorie.image ?? '',
              placeholder: (context, url) => CustomLoading(),
              height: screenSize.height * 0.1,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: screenSize.height * 0.02),
            CustomText(
              text: categorie.name ?? '',
              colorText: config.primary,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              fontSize: screenSize.width * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}