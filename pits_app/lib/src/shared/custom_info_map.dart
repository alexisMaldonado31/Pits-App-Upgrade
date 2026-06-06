import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/establishments_model.dart';
import 'package:pits_app/src/shared/custom_richtext.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:pits_app/src/utils/distancia_lat_long.dart' as distanceLatLng;
import 'package:url_launcher/url_launcher.dart';
import 'package:pits_app/src/pages/establishment_page.dart';

class CustomInfoWindowMap extends StatelessWidget {
  final EstablishmentsModel establishment;
  final LatLng latLng;

  const CustomInfoWindowMap(
    this.establishment, {
    super.key,
    required this.latLng,
  });

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: config.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: establishment.logo ?? '',
                      placeholder: (_, __) => LinearProgressIndicator(),
                      errorWidget: (_, __, ___) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(height: 4),
                  CustomText(
                    text: establishment.name ?? '',
                    colorText: Colors.white,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                    fontSize: screenSize.width * 0.036,
                  ),
                  SizedBox(height: 4),
                  Center(
                    child: CustomRichText(
                      title: 'Distancia',
                      content:
                          '${distanceLatLng.distanciaKm(
                        double.parse(establishment.latitude ?? '0'),
                        double.parse(establishment.longitude ?? '0'),
                        latLng.latitude,
                        latLng.longitude,
                      )} Km',
                      colorTitle: Colors.white,
                      colorContent: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: RatingBar.builder(
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
                      unratedColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: screenSize.height * 0.03,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: config.accent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EstablishmentPage(
                              establishment: establishment,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Ver Ficha',
                        style: TextStyle(
                          color: config.primary,
                          fontSize: screenSize.width * 0.036,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: screenSize.height * 0.03,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: config.accent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () async {
                        final uri = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=${establishment.latitude},${establishment.longitude}');
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      },
                      child: Text(
                        'Ver Ruta',
                        style: TextStyle(
                          color: config.primary,
                          fontSize: screenSize.width * 0.036,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        CustomPaint(
          painter: _TrianglePainter(color: config.primary),
          size: Size(20, 10),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) => false;
}