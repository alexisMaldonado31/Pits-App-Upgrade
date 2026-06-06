import 'package:http/http.dart' as http;
import 'package:pits_app/src/models/province_model.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

class ProvincesService {
  final prefs = PreferenciasUsuario();

  Future<List<ProvinceModel>> getProvinces() async {
    final uri = Uri.parse('${prefs.url}/provinces');
    try {
      final res = await http.get(uri);
      return provinceModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }
}