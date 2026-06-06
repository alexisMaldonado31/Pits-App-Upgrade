import 'package:vector_math/vector_math.dart' as math;
import 'dart:math';

double radioTierraKm = 6371.0;

String distanciaKm(double latitud, double longitud, double latitudOrigen,
    double longitudOrigen) {
  latitud = math.radians(latitud);
  latitudOrigen = math.radians(latitudOrigen);
  longitud = math.radians(longitud);
  longitudOrigen = math.radians(longitudOrigen);

  double dlat = latitud - latitudOrigen;
  double dlng = longitud - longitudOrigen;

  double a = sin(dlat / 2) * sin(dlat / 2) +
      cos(latitud) *
          cos(latitudOrigen) *
          (sin(dlng / 2)) *
          (sin(dlng / 2));
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distanceKm = radioTierraKm * c;
  return distanceKm.toStringAsFixed(2);
}