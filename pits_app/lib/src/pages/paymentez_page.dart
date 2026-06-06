import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/customer_model.dart';
import 'package:pits_app/src/models/payment_checkout.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentezPage extends StatefulWidget {
  final double orderAmount;
  final double orderVat;
  final String orderReference;

  const PaymentezPage({
    super.key,
    required this.orderAmount,
    required this.orderVat,
    required this.orderReference,
  });

  @override
  State<PaymentezPage> createState() => _PaymentezPageState();
}

class _PaymentezPageState extends State<PaymentezPage> {
  final prefs = PreferenciasUsuario();
  WebViewController? _controller;
  bool loading = true;
  String? error;

  // Credenciales servidor
  static const _serverAppCode = 'PITS-EC-SERVER';
  static const _serverAppKey = 'mbNGduZn4wT2KYP0QbNO5TtsobASgZ';
  // Credenciales cliente
  static const _clientAppCode = 'PITS-EC-SERVER';
  static const _clientAppKey = 'mbNGduZn4wT2KYP0QbNO5TtsobASgZ';

  @override
  void initState() {
    super.initState();
    _initPayment();
  }

  String _generateAuthToken() {
    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final uniqTokenString = _serverAppKey + timestamp;
    final hash = sha256.convert(utf8.encode(uniqTokenString)).toString();
    final raw = '$_serverAppCode;$timestamp;$hash';
    return base64Encode(utf8.encode(raw));
  }

  Future<String?> _getReference(CustomerModel customer) async {
    final authToken = _generateAuthToken();
    final devReference = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

    final body = {
      "locale": "es",
      "order": {
        "amount": widget.orderAmount,
        "description": "Pitsmotors App Consumos",
        "vat": widget.orderVat,
        "dev_reference": devReference,
        "taxable_amount": widget.orderAmount - widget.orderVat,
        "tax_percentage": 15,
      },
      "user": {
        "id": customer.id.toString(),
        "email": customer.email,
      },
      "conf": {
        "allowed_card_types": "0",
        "invalid_card_type_message": "Solo tarjeta de Crédito",
        "style_version": "2",
        "theme": {
          "logo": "https://pitsmotors.com/img/logo.png",
          "primary_color": "#F8C824",
        }
      }
    };

    try {
      final res = await http.post(
        Uri.parse('https://ccapi.paymentez.com/v2/transaction/init_reference/'),
        headers: {
          'Content-Type': 'application/json',
          'Auth-Token': authToken,
        },
        body: jsonEncode(body),
      );

      print('Paymentez STATUS: ${res.statusCode}');
      print('Paymentez BODY: ${res.body}');

      final data = jsonDecode(res.body);
      return data['reference'];
    } catch (e) {
      print('Error obteniendo reference: $e');
      return null;
    }
  }

  Future<void> _initPayment() async {
    final customerInfo = CustomerModel.fromJson(json.decode(prefs.customerInfo));
    final reference = await _getReference(customerInfo);

    if (reference == null) {
      setState(() {
        error = 'No se pudo inicializar el pago. Intenta de nuevo.';
        loading = false;
      });
      return;
    }

    final html = '''
      <!DOCTYPE html>
      <html>
      <head>
        <title>Pago</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.paymentez.com/ccapi/sdk/payment_checkout_3.0.0.min.js"></script>
      </head>
      <body>
        <button id="pay-btn" style="display:none">Pagar</button>
        <script>
          let paymentCheckout = new PaymentCheckout.modal({
            client_app_code: '$_clientAppCode',
            client_app_key: '$_clientAppKey',
            locale: 'es',
            env_mode: 'prod',
            onOpen: function() { console.log('modal open'); },
            onClose: function() { console.log('modal closed'); },
            onResponse: function(response) {
              console.log(JSON.stringify(response));
              if (messageHandler) {
                messageHandler.postMessage(JSON.stringify(response));
              }
            }
          });

          // Abre automáticamente al cargar
          window.onload = function() {
            paymentCheckout.open({
              reference: '$reference',
            });
          };

          window.addEventListener('popstate', function() {
            paymentCheckout.close();
          });
        </script>
      </body>
      </html>
    ''';

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'messageHandler',
        onMessageReceived: (message) {
          final data = jsonDecode(message.message);
          // Maneja error
          if (data['error'] != null) {
            Navigator.pop(context, null);
            return;
          }
          // Maneja transacción
          if (data['transaction'] != null) {
            final transaction = Transaction.fromJson(data['transaction']);
            Navigator.pop(context, transaction.toJson());
          }
        },
      )
      ..loadRequest(
        Uri.dataFromString(
          html,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ),
      );

    setState(() {
      _controller = controller;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Pago con Tarjeta")),
      backgroundColor: config.primary,
      body: loading
          ? Center(child: CustomLoading())
          : error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          error!,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              loading = true;
                              error = null;
                            });
                            _initPayment();
                          },
                          child: Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : WebViewWidget(controller: _controller!),
    );
  }
}