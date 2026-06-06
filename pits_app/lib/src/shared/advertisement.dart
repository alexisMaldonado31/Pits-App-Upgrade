import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/advertisement_model.dart';
import 'package:pits_app/src/pages/establishment_page.dart';
import 'package:pits_app/src/services/categories_service.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Advertisement extends StatefulWidget {
  final AdvertisementModel advertisement;
  const Advertisement(this.advertisement, {super.key});

  @override
  State<Advertisement> createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  final categoriesService = CategoriesService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () async {
        setState(() => loading = true);

        final establishment = await categoriesService
            .getEstablishmentsById(widget.advertisement.establishmentId!);

        setState(() => loading = false);

        if (establishment != null) {
          pushScreen(
            context,
            screen: EstablishmentPage(establishment: establishment),
            withNavBar: false,
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: screenSize.height * 0.28,
        decoration: BoxDecoration(
          color: config.accent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(screenSize.height * 0.015),
        ),
        padding: EdgeInsets.all(screenSize.width * 0.03),
        margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
        child: loading
            ? Center(child: CustomLoading())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.advertisement.name ?? '',
                    colorText: config.primary,
                    fontSize: screenSize.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    text: widget.advertisement.shortDescription ?? '',
                    colorText: config.primary,
                    fontSize: screenSize.width * 0.035,
                    fontWeight: FontWeight.w400,
                  ),
                  Divider(color: Colors.white),
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: widget.advertisement.image ?? '',
                      width: double.infinity,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => CustomLoading(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}