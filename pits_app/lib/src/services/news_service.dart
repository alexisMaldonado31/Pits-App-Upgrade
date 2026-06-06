import 'package:http/http.dart' as http;
import 'package:pits_app/src/models/news_model.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

class NewsService {
  final prefs = PreferenciasUsuario();
  final headers = {"Content-Type": "application/json"};

  Future<List<NewsModel>> getNews() async {
    final uri = Uri.parse('${prefs.url}/news');
    try {
      final res = await http.get(uri, headers: headers);
      return newsModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }
}