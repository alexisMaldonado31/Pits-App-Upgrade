import 'package:http/http.dart' as http;
import 'package:pits_app/src/models/categories_model.dart';
import 'package:pits_app/src/models/establishments_model.dart';
import 'package:pits_app/src/models/review_model.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

class CategoriesService {
  final prefs = PreferenciasUsuario();
  final headers = {"Content-Type": "application/json"};

  Future<List<CategoriesModel>> getCategories() async {
    final uri = Uri.parse('${prefs.url}/categories');
    try {
      final res = await http.get(uri, headers: headers);
      return categoriesModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }

  Future<List<EstablishmentsModel>> getEstablishmentsByCategory(
      int category) async {
    final uri =
        Uri.parse('${prefs.url}/establishments_category/$category');
    try {
      final res = await http.get(uri, headers: headers);
      return establishmentsModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }

  Future<EstablishmentsModel?> getEstablishmentsById(int id) async {
    final uri = Uri.parse('${prefs.url}/establishment/$id');
    try {
      final res = await http.get(uri, headers: headers);
      return establishmentModelFromJson(res.body);
    } catch (e) {
      return null;
    }
  }

  Future<List<EstablishmentsModel>> getEstablishmentsBySearch(
      String search) async {
    final uri = Uri.parse('${prefs.url}/products_search/$search');
    try {
      final res = await http.get(uri, headers: headers);
      return establishmentsModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }

  Future<List<ReviewModel>> getReviewsByEstablishment(
      int establishmentId) async {
    final uri =
        Uri.parse('${prefs.url}/reviews_establishment/$establishmentId');
    try {
      final res = await http.get(uri, headers: headers);
      return reviewModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }
}