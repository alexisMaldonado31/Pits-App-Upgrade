import 'package:http/http.dart' as http;
import 'package:pits_app/src/models/advertisement_model.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

class AdvertisementService {
  final prefs = PreferenciasUsuario();

  Future<List<AdvertisementModel>> getAdvertisements() async {
    final uri = Uri.parse('${prefs.url}/advertisements');
    try {
      final res = await http.get(uri);
      return advertisementModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }
}