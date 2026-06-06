import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/vehicle_model.dart';
import 'package:pits_app/src/shared/custom_loading.dart';

class Vehicle extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback onTap;

  const Vehicle(this.vehicle, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: screenSize.height * 0.1,
        width: screenSize.width,
        padding: EdgeInsets.all(screenSize.width * 0.03),
        margin: EdgeInsets.only(bottom: screenSize.height * 0.01),
        decoration: BoxDecoration(
          color: config.accent.withOpacity(0.8),
          borderRadius: BorderRadius.circular(screenSize.height * 0.015),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      vehicle.brandName ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      vehicle.typeVehicleName ?? '',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      vehicle.licensePlate ?? '',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            if (vehicle.image != null && vehicle.image!.isNotEmpty)
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: vehicle.image!,
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