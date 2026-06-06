import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/establishments_model.dart';
import 'package:pits_app/src/shared/custom_richtext.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:pits_app/src/utils/distancia_lat_long.dart' as distanceLatLng;
import 'package:pits_app/src/pages/establishment_page.dart';

class Establishment extends StatelessWidget {
  final EstablishmentsModel establishment;
  final LatLng latLng;

  const Establishment({
    super.key,
    required this.establishment,
    required this.latLng,
  });

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EstablishmentPage(
              establishment: establishment,
            ),
          ),
        );
      },
      child: Container(
        height: screenSize.height * 0.21,
        margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.01,
          horizontal: screenSize.width * 0.03,
        ),
        decoration: BoxDecoration(
          color: config.accent.withOpacity(0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: establishment.logo ?? '',
              placeholder: (context, url) =>
                  SizedBox(child: LinearProgressIndicator()),
              height: screenSize.height * 0.2,
              width: screenSize.height * 0.22,
              fit: BoxFit.fill,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(width: screenSize.width * 0.05),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          establishment.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenSize.width * 0.045,
                            fontFamily: 'Gothic',
                          ),
                        ),
                      ),
                      if (establishment.subscriptionName == 'GOLD')
                        Icon(FontAwesomeIcons.medal, color: Colors.amberAccent, size: 16),
                    ],
                  ),
                  Divider(color: Colors.white),
                  CustomRichText(
                    title: 'Ciudad',
                    content: establishment.city ?? '',
                  ),
                  CustomRichText(
                    title: 'Distancia',
                    content:
                        '${distanceLatLng.distanciaKm(
                      double.parse(establishment.latitude ?? '0'),
                      double.parse(establishment.longitude ?? '0'),
                      latLng.latitude,
                      latLng.longitude,
                    )} Km',
                  ),
                  Spacer(),
                  CustomText(
                    text: 'Valoración:',
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.left,
                    fontSize: screenSize.width * 0.035,
                  ),
                  SizedBox(height: screenSize.height * 0.005),
                  RatingBar.builder(
                    initialRating: (establishment.stars ?? 0).toDouble(),
                    minRating: 1,
                    itemCount: 5,
                    allowHalfRating: true,
                    itemSize: screenSize.width * 0.05,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (_) {},
                    ignoreGestures: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}