import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pits_app/src/models/customer_create_model.dart';
import 'package:pits_app/src/models/customer_model.dart';
import 'package:pits_app/src/models/customer_update_model.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

class CustomerService {
  final prefs = PreferenciasUsuario();
  final headers = {"Content-Type": "application/json"};

  Uri _buildUri(String path) {
    return Uri.parse(prefs.url).replace(path: path);
  }

  Future<CustomerModel?> getCustomer() async {
    var customer = CustomerModel.fromJson(json.decode(prefs.customerInfo));
    final uri = _buildUri('/customer/${customer.id}');

    final res = await http.get(uri, headers: headers);
    try {
      return CustomerModel.fromJson(json.decode(res.body));
    } catch (e) {
      return null;
    }
  }

  Future<CustomerModel?> putCustomer(
    int customerId,
    CustomerUpdateModel customerModel,
  ) async {
    final uri = Uri.parse(prefs.url).replace(path: '/customer/$customerId');

    final res = await http.put(
      uri,
      body: jsonEncode(customerModel), // requiere toJson()
      headers: const {'Content-Type': 'application/json'},
    );

    try {
      return CustomerModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      return null;
    }
  }

  Future<CustomerModel?> postRegisterCustomer(
    CustomerCreateModel customerModel,
  ) async {
    final uri = Uri.parse(prefs.url).replace(path: '/customer/register');

    final res = await http.post(
      uri,
      body: jsonEncode(customerModel), // requiere toJson()
      headers: headers, // asegúrate Content-Type: application/json
    );

    try {
      return CustomerModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      if (res.body.toLowerCase() == 'false') {
        return null;
      }
      return null;
    }
  }
}
