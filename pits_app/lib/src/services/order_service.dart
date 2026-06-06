import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:pits_app/src/models/customer_model.dart';
import 'package:pits_app/src/models/order_model.dart';
import 'package:pits_app/src/models/register_review_model.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:pits_app/src/models/create_order_model.dart';

class OrderService {
  final prefs = PreferenciasUsuario();
  final headers = {"Content-Type": "application/json"};

  Future<List<OrderModel>> getOrders() async {
    final customer = CustomerModel.fromJson(json.decode(prefs.customerInfo));
    final uri = Uri.parse('${prefs.url}/orders/${customer.id}');
    try {
      final res = await http.get(uri, headers: headers);
      return orderModelFromJson(res.body);
    } catch (e) {
      return [];
    }
  }

  Future<RegisterReviewModel> registerReview(RegisterReviewModel review) async {
    final uri = Uri.parse('${prefs.url}/review/register');
    final body = {
      "establishment_id": review.establishmentId,
      "stars": review.stars,
      "comment": review.comment,
      "order_id": review.orderId,
    };
    try {
      final res = await http.post(uri, headers: headers, body: jsonEncode(body));
      return RegisterReviewModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      return RegisterReviewModel();
    }
  }

  Future<bool> paymentOrder(CreateOrderModel order) async {
    final uri = Uri.parse('${prefs.url}/order/register');
    final body = {
      "customer_id": order.customerId,
      "establishment_id": order.establishmentId,
      "payment_type": order.paymentType,
      "discount": order.discount,
      "discount_code": order.discountCode,
      "subtotal": order.subtotal,
      "tax": order.tax?.toStringAsFixed(2),
      "total": order.total,
      "status": order.status,
      "reference": order.reference?.isEmpty ?? true
          ? ""
          : order.reference!.substring(0, min(10, order.reference!.length)),
      "transaction_id": order.transactionId,
      "authorization_number": order.authorizationNumber,
      "products": order.products
              ?.map((e) => {
                    "product_service_id": e.productServiceId,
                    "quantity": e.quantity,
                    "product_service_type": e.productServiceType,
                    "unit_price": e.unitPrice,
                    "schedule_date": e.scheduleDate,
                    "schedule_hour": e.scheduleHour,
                    "tax": e.tax,
                    "row_price": e.rowPrice,
                    "car_id": e.carId,
                  })
              .toList() ??
          [],
    };

    try {
      await http.post(uri, headers: headers, body: jsonEncode(body));
      return true;
    } catch (e) {
      return false;
    }
  }
}