import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() => _instancia;

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  /// Debe llamarse antes de usar la clase
  Future<void> initPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // GET Y SET url
  String get url => _prefs.getString('url') ?? '';

  set url(String value) {
    _prefs.setString('url', value);
  }

  // GET Y SET customerInfo
  String get customerInfo => _prefs.getString('customerInfo') ?? '';

  set customerInfo(String value) {
    _prefs.setString('customerInfo', value);
  }

  // GET Y SET whatsapp
  String get whatsapp => _prefs.getString('whatsapp') ?? '';

  set whatsapp(String value) {
    _prefs.setString('whatsapp', value);
  }

  // GET Y SET googleSign
  bool get googleSign => _prefs.getBool('googleSign') ?? false;

  set googleSign(bool value) {
    _prefs.setBool('googleSign', value);
  }

  // GET Y SET facebookSign
  bool get facebookSign => _prefs.getBool('facebookSign') ?? false;

  set facebookSign(bool value) {
    _prefs.setBool('facebookSign', value);
  }
}
