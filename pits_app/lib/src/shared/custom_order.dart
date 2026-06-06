import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/order_model.dart';
import 'package:pits_app/src/models/register_review_model.dart';
import 'package:pits_app/src/pages/details_order_page.dart';
import 'package:pits_app/src/services/order_service.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared/custom_richtext.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:pits_app/src/shared/custom_text_field.dart';
import 'package:pits_app/src/utils/validators.dart';

class CustomOrder extends StatefulWidget {
  final OrderModel orderModel;
  final Function(bool) onReview;

  const CustomOrder({
    super.key,
    required this.orderModel,
    required this.onReview,
  });

  @override
  State<CustomOrder> createState() => _CustomOrderState();
}

class _CustomOrderState extends State<CustomOrder> {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;
    final order = widget.orderModel;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.4,
      decoration: BoxDecoration(
        color: config.accent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(screenSize.height * 0.015),
      ),
      margin: EdgeInsets.all(screenSize.width * 0.05),
      padding: EdgeInsets.all(screenSize.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomRichText(
            title: "Establecimiento",
            content: order.establishmentName ?? '',
            fontSize: screenSize.width * 0.04,
          ),
          CustomRichText(
            title: "Tipo de Pago",
            content: order.paymentType ?? '',
            fontSize: screenSize.width * 0.04,
          ),
          CustomRichText(
            title: "Estado del Pedido",
            content: order.status ?? '',
            fontSize: screenSize.width * 0.04,
          ),
          CustomRichText(
            title: "Fecha Pedido",
            content: order.createdAt?.toIso8601String().substring(0, 10) ?? '',
            fontSize: screenSize.width * 0.04,
          ),
          Divider(color: Colors.white),
          CustomRichText(
            title: "Subtotal",
            content: order.subtotal ?? '',
            fontSize: screenSize.width * 0.04,
          ),
          CustomRichText(
            title: "IVA",
            content: order.tax ?? '',
            fontSize: screenSize.width * 0.04,
          ),
          CustomRichText(
            title: "Total",
            content: order.total ?? '',
            fontSize: screenSize.width * 0.04,
          ),
          Spacer(),
          CustomButton(
            color: config.secondary,
            colorText: Colors.white,
            fontSize: screenSize.width * 0.05,
            height: screenSize.height * 0.06,
            text: 'Ver Detalles',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsOrderPage(
                    products: order.products ?? [],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: screenSize.height * 0.01),
          if ((order.status == 'FINALIZADA' || order.status == 'CANCELADA') &&
              order.reviewed == false)
            CustomButton(
              color: config.secondary,
              colorText: Colors.white,
              fontSize: screenSize.width * 0.05,
              height: screenSize.height * 0.06,
              text: 'Calificar',
              onTap: () async {
                final response = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) => AlertReview(
                    orderId: order.id!,
                    establishmentId: order.establishmentId!,
                  ),
                );
                widget.onReview(response ?? false);
              },
            ),
        ],
      ),
    );
  }
}

class AlertReview extends StatefulWidget {
  final int orderId;
  final int establishmentId;

  const AlertReview({
    super.key,
    required this.orderId,
    required this.establishmentId,
  });

  @override
  State<AlertReview> createState() => _AlertReviewState();
}

class _AlertReviewState extends State<AlertReview> {
  final orderService = OrderService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  double rating = 0.0;
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return IgnorePointer(
      ignoring: loading,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: config.secondary,
        title: CustomText(
          text: 'Calificar Órden',
          colorText: Colors.white,
          textAlign: TextAlign.center,
          fontSize: screenSize.width * 0.045,
          fontWeight: FontWeight.bold,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.02,
          horizontal: screenSize.width * 0.04,
        ),
        content: SizedBox(
          height: screenSize.height * 0.5,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  itemCount: 5,
                  allowHalfRating: true,
                  itemSize: screenSize.width * 0.08,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (value) => setState(() => rating = value),
                ),
                SizedBox(height: screenSize.height * 0.05),
                CustomTextField(
                  sizeBox: screenSize.height * 0.15,
                  sizeFont: screenSize.width * 0.04,
                  obligatorio: true,
                  label: true,
                  hintText: 'Comentario',
                  colorTexto: Colors.white,
                  colorHintText: Colors.white,
                  colorFondo: config.primary,
                  colorLabel: Colors.white,
                  controller: commentController,
                  maxLines: 5,
                  validator: comprobarCampoNoVacio,
                ),
                Spacer(),
                loading
                    ? CustomLoading()
                    : CustomButton(
                        color: config.accent,
                        colorText: Colors.white,
                        fontSize: screenSize.width * 0.045,
                        height: screenSize.height * 0.05,
                        text: 'Calificar',
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (!_formKey.currentState!.validate()) return;

                          setState(() => loading = true);

                          final review = RegisterReviewModel(
                            comment: commentController.text,
                            establishmentId: widget.establishmentId,
                            orderId: widget.orderId,
                            stars: rating,
                          );

                          final response =
                              await orderService.registerReview(review);
                          setState(() => loading = false);
                          Navigator.pop(context, response.orderId != null);
                        },
                      ),
                SizedBox(height: screenSize.height * 0.01),
                if (!loading)
                  CustomButton(
                    color: config.accent,
                    colorText: Colors.white,
                    fontSize: screenSize.width * 0.045,
                    height: screenSize.height * 0.05,
                    text: 'Cerrar',
                    onTap: () => Navigator.pop(context, false),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}