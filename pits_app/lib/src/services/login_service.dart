import 'dart:convert';
import 'package:pits_app/src/models/customer_model.dart';
import 'package:pits_app/src/models/parameters_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

class LoginService {
  final prefs = PreferenciasUsuario();

  final headers = {"Content-Type": "application/json"};

  Uri _buildUri(String path) {
    final base = prefs.url.endsWith('/')
        ? prefs.url.substring(0, prefs.url.length - 1)
        : prefs.url;
    return Uri.parse('$base$path');
  }

  Future<CustomerModel?> login(String email, String password) async {
    final uri = _buildUri('/login');

    final body = {"email": email, "password": password};

    final res = await http.post(uri, body: jsonEncode(body), headers: headers);

    try {
      return CustomerModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      return null;
    }
  }

  Future<CustomerModel?> loginGoogle(GoogleSignInAccount account) async {
    final uri = _buildUri('/login_google');

    final body = {
      "displayName": account.displayName,
      "email": account.email,
      "id": account.id,
      "photoUrl": account.photoUrl,
    };

    final res = await http.post(uri, body: jsonEncode(body), headers: headers);

    try {
      return CustomerModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      return null;
    }
  }

  Future<CustomerModel?> loginFacebook(Map<String, dynamic> userData) async {
    final uri = _buildUri('/login_facebook');

    final body = {
      "name": userData["name"],
      "email": userData["email"],
      "id": userData["id"],
    };

    final res = await http.post(uri, body: jsonEncode(body), headers: headers);

    try {
      return CustomerModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      return null;
    }
  }

  Future<bool> forgetPassword(String email) async {
    final uri = _buildUri('/forget_password');

    final body = {"email": email};

    final res = await http.post(uri, body: jsonEncode(body), headers: headers);

    try {
      return res.body == 'true';
    } catch (e) {
      return false;
    }
  }

  Future<ParametersModel?> getParameters() async {
    final uri = _buildUri('/parameters');

    final res = await http.get(uri, headers: headers);

    try {
      return ParametersModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      return null;
    }
  }
}
