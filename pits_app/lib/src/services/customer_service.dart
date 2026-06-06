import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pits_app/src/models/customer_create_model.dart';
import 'package:pits_app/src/models/customer_model.dart';
import 'package:pits_app/src/models/customer_update_model.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

class CustomerService {
  final prefs = PreferenciasUsuario();
  final headers = {"Content-Type": "application/json"};

  Future<CustomerModel?> getCustomer() async {
    final customer = CustomerModel.fromJson(json.decode(prefs.customerInfo));
    final uri = Uri.parse('${prefs.url}/customer/${customer.id}');
    try {
      final res = await http.get(uri, headers: headers);
      return CustomerModel.fromJson(json.decode(res.body));
    } catch (e) {
      return null;
    }
  }

  Future<CustomerModel?> putCustomer(
    int customerId,
    CustomerUpdateModel customerModel,
  ) async {
    final uri = Uri.parse('${prefs.url}/customer/$customerId');
    print('PUT URL: $uri');
    print('BODY: ${jsonEncode(customerModel)}');

    try {
      final res = await http.put(
        uri,
        body: jsonEncode(customerModel),
        headers: headers,
      );
      print('STATUS: ${res.statusCode}');
      print('BODY: ${res.body}');
      return CustomerModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      print('ERROR putCustomer: $e');
      return null;
    }
  }

  Future<CustomerModel> postRegisterCustomer(
    CustomerCreateModel customerModel,
  ) async {
    final uri = Uri.parse('${prefs.url}/customer/register');

    try {
      final res = await http.post(
        uri,
        body: jsonEncode(customerModel),
        headers: headers,
      );

      print('STATUS: ${res.statusCode}');
      print('BODY: ${res.body}');

      final body = res.body.trim();

      if (body.toLowerCase() == 'false' || res.statusCode != 200) {
        throw Exception('No se pudo registrar el usuario');
      }

      return CustomerModel.fromJson(jsonDecode(body));

    } on http.ClientException {
      throw Exception('Sin conexión al servidor');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}