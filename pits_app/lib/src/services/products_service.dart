import 'package:http/http.dart' as http;
import 'package:pits_app/src/models/productos_model.dart';
import 'package:pits_app/src/models/schedule_model.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

class ProductsService {
  final prefs = PreferenciasUsuario();
  final headers = {"Content-Type": "application/json"};

  Future<List<ProductsModel>> getProductsByEstablishment(
      int establishmentId) async {
    final uri =
        Uri.parse('${prefs.url}/products_establishment/$establishmentId');
    try {
      final res = await http.get(uri, headers: headers);
      return productsModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> getSchedulesByEstablishmentProduct(
    int establishmentId,
    int productId,
    String fecha,
  ) async {
    final uri = Uri.parse(
        '${prefs.url}/schedules/$establishmentId/$fecha/$productId');
    try {
      final res = await http.get(uri, headers: headers);
      return scheduleModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }
}