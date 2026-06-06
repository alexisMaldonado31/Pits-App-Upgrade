import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/bloc/item_carrito_bloc.dart';
import 'package:pits_app/src/models/create_order_model.dart';
import 'package:pits_app/src/models/customer_model.dart';
import 'package:pits_app/src/models/item_carrito_model.dart';
import 'package:pits_app/src/models/payment_checkout.dart';
import 'package:pits_app/src/models/total_model.dart';
import 'package:pits_app/src/pages/paymentez_page.dart';
import 'package:pits_app/src/services/order_service.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared/custom_payment_animation.dart';
import 'package:pits_app/src/shared/custom_richtext.dart';
import 'package:pits_app/src/shared/custom_snackbar.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

class PaymentPage extends StatefulWidget {
  final int establishmentId;

  const PaymentPage({super.key, required this.establishmentId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int radioValue = 0;
  Total? _totalClass;
  int customerId = 0;
  bool cargando = false;

  final itemsCarritoBloc = ItemsCarritoBloc();
  final prefs = PreferenciasUsuario();
  final paymentService = OrderService();

  @override
  void initState() {
    super.initState();
    _loadCustomerId();
  }

  Future<void> _loadCustomerId() async {
    final customerInfo =
        CustomerModel.fromJson(json.decode(prefs.customerInfo));
    customerId = customerInfo.id ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return StreamBuilder<List<ItemCarritoModel>>(
      stream: itemsCarritoBloc.itemsCarritoStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final itemsCarrito = snapshot.data!;

        if (itemsCarrito.isEmpty) {
          return Container(
            color: config.primary.withOpacity(0.8),
            child: Column(
              children: [CloseButton(color: config.accent)],
            ),
          );
        }

        return IgnorePointer(
          ignoring: cargando,
          child: Scaffold(
            appBar: AppBar(title: Text("Pago del Pedido")),
            backgroundColor: config.primary,
            body: Column(
              children: [
                SizedBox(height: screenSize.height * 0.05),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<int>(
                        value: 0,
                        groupValue: radioValue,
                        onChanged: (v) => setState(() => radioValue = v!),
                        activeColor: config.accent,
                        title: CustomText(
                          text: "Efectivo",
                          fontSize: screenSize.width * 0.05,
                          fontWeight: FontWeight.bold,
                          colorText: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<int>(
                        value: 1,
                        groupValue: radioValue,
                        onChanged: (v) => setState(() => radioValue = v!),
                        activeColor: config.accent,
                        title: CustomText(
                          text: "Tarjeta",
                          fontSize: screenSize.width * 0.05,
                          fontWeight: FontWeight.bold,
                          colorText: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.05),
                Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: itemsCarrito.length,
                    itemBuilder: (context, i) => _itemCarrito(
                      itemsCarrito[i],
                      config.accent,
                      screenSize.width * 0.04,
                    ),
                  ),
                ),
                _totalCarrito(config.accent, config.primary),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                    vertical: screenSize.height * 0.05,
                  ),
                  child: cargando
                      ? CustomLoading()
                      : _paymentButton(
                          itemsCarrito,
                          buttonColor: config.accent,
                          fontSize: screenSize.width * 0.05,
                          height: screenSize.height * 0.06,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _itemCarrito(
      ItemCarritoModel item, Color color, double fontSize) {
    return Column(
      children: [
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    text: item.nombre ?? '',
                    colorText: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                  SizedBox(width: fontSize / 2),
                  FaIcon(FontAwesomeIcons.tags,
                      color: Colors.white, size: fontSize),
                ],
              ),
              if (item.tipo == 'SERVICIO') ...[
                CustomText(
                  text: 'Horario: ${item.horario ?? ''}',
                  colorText: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: fontSize * 0.8,
                ),
                if (item.vehicleInfo != null)
                  CustomText(
                    text: 'Vehículo: ${item.vehicleInfo}',
                    colorText: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 0.8,
                  ),
              ],
              CustomText(
                text: item.descripcionProducto ?? '',
                colorText: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: fontSize * 0.9,
              ),
              Row(
                children: [
                  CustomText(
                    text: 'Cantidad: ${item.cantidadProducto}',
                    colorText: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize * 0.9,
                  ),
                  SizedBox(width: fontSize / 2),
                  CustomText(
                    text: 'PVP: ${item.precioProducto}',
                    colorText: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize * 0.9,
                  ),
                ],
              ),
              CustomText(
                text:
                    'Total: ${((item.cantidadProducto ?? 0) * (item.precioProducto ?? 0)).toStringAsFixed(2)}',
                colorText: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize * 0.9,
              ),
            ],
          ),
        ),
        Divider(color: Colors.white),
      ],
    );
  }

  Widget _totalCarrito(Color colorBoton, Color colorTexto) {
    return StreamBuilder<Total>(
      stream: itemsCarritoBloc.totalCarritoStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        _totalClass = snapshot.data!;
        final total = _totalClass!;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomRichText(
                title: 'Total',
                content:
                    '${((total.iva ?? 0) - (total.descuento ?? 0)).toStringAsFixed(2)} \$',
                colorContent: Colors.white,
                colorTitle: colorBoton,
                fontSize: 18,
              ),
              Row(
                children: [
                  CustomRichText(
                    title: 'Subtotal',
                    content: '${(total.subtotal ?? 0).toStringAsFixed(2)} \$',
                    colorContent: Colors.white,
                    colorTitle: colorBoton,
                    fontSize: 14,
                  ),
                  SizedBox(width: 8),
                  CustomRichText(
                    title: 'IVA',
                    content:
                        '${((total.iva ?? 0) - (total.subtotal ?? 0)).toStringAsFixed(2)} \$',
                    colorContent: Colors.white,
                    colorTitle: colorBoton,
                    fontSize: 14,
                  ),
                  SizedBox(width: 8),
                  CustomRichText(
                    title: 'Ahorro',
                    content: '${(total.descuento ?? 0).toStringAsFixed(2)} \$',
                    colorContent: Colors.white,
                    colorTitle: colorBoton,
                    fontSize: 14,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _paymentButton(
    List<ItemCarritoModel> itemsCarrito, {
    required Color buttonColor,
    required double fontSize,
    required double height,
  }) {
    return StreamBuilder<Total>(
      stream: itemsCarritoBloc.totalCarritoStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        _totalClass = snapshot.data!;

        return CustomButton(
          color: buttonColor,
          colorText: Colors.white,
          fontSize: fontSize,
          height: height,
          text: 'Pagar',
          onTap: () async {
            final orderReference =
                DateTime.now().millisecondsSinceEpoch.toString();
            await _onlinePayment(
              _totalClass!.iva ?? 0,
              ((_totalClass!.iva ?? 0) - (_totalClass!.subtotal ?? 0)),
              orderReference,
              itemsCarrito,
              radioValue,
            );
          },
        );
      },
    );
  }

  Future<void> _onlinePayment(
    double totalOrder,
    double totalIva,
    String orderReference,
    List<ItemCarritoModel> itemsCarrito,
    int radioValue,
  ) async {
    if (radioValue == 0) {
      await _generateOrder(itemsCarrito: itemsCarrito);
    } else {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentezPage(
            orderAmount: totalOrder,
            orderVat: totalIva,
            orderReference: orderReference,
          ),
        ),
      );

      if (result == null) {
        mostrarSnackbar(
            "Completa el pago para generar el pedido", Colors.red, context);
        return;
      }

      final transaction = Transaction.fromJson(result);
      if (transaction.status != 'success') {
        mostrarSnackbar("No se pudo completar el pago", Colors.red, context);
        return;
      }

      await _generateOrder(
        itemsCarrito: itemsCarrito,
        orderReference: transaction.devReference ?? '',
        transactionId: transaction.id ?? '',
        authorizationNumber: transaction.authorizationCode ?? '',
      );

      mostrarSnackbar(
          "Pago realizado correctamente", Colors.green, context);
    }
  }

  Future<void> _generateOrder({
    required List<ItemCarritoModel> itemsCarrito,
    String orderReference = '',
    String transactionId = '',
    String authorizationNumber = '',
  }) async {
    final order = CreateOrderModel(
      customerId: customerId,
      establishmentId: widget.establishmentId,
      paymentType: radioValue == 0 ? "EFECTIVO" : "TARJETA",
      discount: 0,
      discountCode: '',
      subtotal: _totalClass?.subtotal ?? 0,
      tax: (_totalClass?.iva ?? 0) - (_totalClass?.subtotal ?? 0),
      total: _totalClass?.iva ?? 0,
      status: "PENDIENTE",
      reference: orderReference,
      transactionId: transactionId,
      authorizationNumber: authorizationNumber,
      products: itemsCarrito
          .map((e) => ProductOrder(
                productServiceId: e.idProducto,
                quantity: e.cantidadProducto,
                productServiceType: e.tipo,
                unitPrice: e.precioProducto,
                scheduleDate: (e.horario?.isEmpty ?? true)
                    ? ''
                    : e.horario!.substring(0, 10),
                scheduleHour: (e.horario?.isEmpty ?? true)
                    ? ''
                    : e.horario!.substring(11),
                tax: e.precioIva,
                rowPrice: (e.cantidadProducto ?? 0) * (e.precioProducto ?? 0),
                carId: e.vehicleId,
              ))
          .toList(),
    );

    setState(() => cargando = true);

    final res = await paymentService.paymentOrder(order);

    setState(() => cargando = false);

    if (res) {
      await showDialog(
        context: context,
        builder: (_) => CustomPaymentAnimation(),
      );
      await itemsCarritoBloc.borrarAllItemsCarrito();
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      mostrarSnackbar("No se pudo realizar el Pedido", Colors.red, context);
    }
  }
}