import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:pits_app/src/models/brand_model.dart';
import 'package:pits_app/src/models/create_vehicle_model.dart';
import 'package:pits_app/src/models/customer_model.dart';
import 'package:pits_app/src/models/vehicle_model.dart';
import 'package:pits_app/src/models/vehicletype_model.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

class VehiclesService {
  final prefs = PreferenciasUsuario();
  final headers = {"Content-Type": "application/json"};

  Future<List<VehicleModel>> getMyVehicles() async {
    final customerInfo = CustomerModel.fromJson(json.decode(prefs.customerInfo));
    final uri = Uri.parse('${prefs.url}/vehicles_customer/${customerInfo.id}');
    try {
      final res = await http.get(uri, headers: headers);
      return vehicleModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }

  Future<bool> postVehicleModel(CreateVehicleModel createVehicle) async {
    final url = '${prefs.url}/car/register';
    final dio = Dio();
    try {
      FormData formData;
      if (createVehicle.image != null && createVehicle.image!.isNotEmpty) {
        formData = FormData.fromMap({
          "customer_id": createVehicle.customerId,
          "brand_id": createVehicle.brandId,
          "type_vehicle_id": createVehicle.typeVehicleId,
          "license_plate": createVehicle.licensePlate,
          "chassis": createVehicle.chassis,
          "image": await MultipartFile.fromFile(createVehicle.image!),
          "kilometers": createVehicle.kilometraje,
          "on_sale": createVehicle.onSale,
        });
      } else {
        formData = FormData.fromMap({
          "customer_id": createVehicle.customerId,
          "brand_id": createVehicle.brandId,
          "type_vehicle_id": createVehicle.typeVehicleId,
          "license_plate": createVehicle.licensePlate,
          "chassis": createVehicle.chassis,
          "kilometers": createVehicle.kilometraje,
          "on_sale": createVehicle.onSale,
        });
      }
      await dio.post(url, data: formData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> putVehicleModel(int id, CreateVehicleModel createVehicle) async {
    final url = '${prefs.url}/vehicle/$id';
    final dio = Dio();
    try {
      FormData formData;
      if (createVehicle.image != null && createVehicle.image!.isNotEmpty) {
        formData = FormData.fromMap({
          "id": id,
          "customer_id": createVehicle.customerId,
          "brand_id": createVehicle.brandId,
          "type_vehicle_id": createVehicle.typeVehicleId,
          "license_plate": createVehicle.licensePlate,
          "chassis": createVehicle.chassis,
          "kilometers": createVehicle.kilometraje,
          "on_sale": createVehicle.onSale,
          "image": await MultipartFile.fromFile(createVehicle.image!),
        });
      } else {
        formData = FormData.fromMap({
          "id": id,
          "customer_id": createVehicle.customerId,
          "brand_id": createVehicle.brandId,
          "type_vehicle_id": createVehicle.typeVehicleId,
          "license_plate": createVehicle.licensePlate,
          "chassis": createVehicle.chassis,
          "kilometers": createVehicle.kilometraje,
          "on_sale": createVehicle.onSale,
        });
      }
      await dio.post(url, data: formData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<BrandModel>> getBrands() async {
    final uri = Uri.parse('${prefs.url}/brands');
    try {
      final res = await http.get(uri, headers: headers);
      return brandModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }

  Future<List<VehicleTypeModel>> getVehiclesType() async {
    final uri = Uri.parse('${prefs.url}/vehicle_types');
    try {
      final res = await http.get(uri, headers: headers);
      return vehicleTypeModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }
}