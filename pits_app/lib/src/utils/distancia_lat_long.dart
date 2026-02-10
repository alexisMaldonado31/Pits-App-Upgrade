import 'package:vector_math/vector_math.dart' as math;
import 'dart:math';

double radioTierraKm = 6371.0;

String distanciaKm(
  double latitud,
  double longitud,
  double latitudOrigen,
  double longitudOrigen,
) {
  double distanceKm;
  double dlat, dlng;
  double a;
  double c;

  //Convertimos de grados a radianes
  latitud = math.radians(latitud);
  latitudOrigen = math.radians(latitudOrigen);
  longitud = math.radians(longitud);
  longitudOrigen = math.radians(longitudOrigen);

  // Fórmula del semiverseno
  dlat = latitud - latitudOrigen;
  dlng = longitud - longitudOrigen;

  a =
      sin(dlat / 2) * sin(dlat / 2) +
      cos(latitud) * cos(latitudOrigen) * (sin(dlng / 2)) * (sin(dlng / 2));
  c = 2 * atan2(sqrt(a), sqrt(1 - a));

  distanceKm = radioTierraKm * c;

  return distanceKm.toStringAsFixed(2);
}
