import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/bloc/item_carrito_bloc.dart';
import 'package:pits_app/src/models/item_carrito_model.dart';
import 'package:pits_app/src/models/productos_model.dart';
import 'package:pits_app/src/models/schedule_modal_response_model.dart';
import 'package:pits_app/src/models/vehicle_model.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/custom_modal_schedule_service.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class Products extends StatefulWidget {
  final ProductsModel product;
  final List<VehicleModel> vehicles;

  const Products({
    super.key,
    required this.product,
    required this.vehicles,
  });

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final itemsCarritoBloc = ItemsCarritoBloc();

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * 0.4,
      width: screenSize.width * 0.4,
      padding: EdgeInsets.all(screenSize.width * 0.03),
      decoration: BoxDecoration(
        color: config.accent.withOpacity(0.8),
        borderRadius: BorderRadius.circular(screenSize.height * 0.015),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: widget.product.featuredImage ?? '',
              placeholder: (_, __) => LinearProgressIndicator(),
              height: screenSize.height * 0.15,
              width: screenSize.height * 0.15,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Icon(Icons.error),
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          CustomText(
            text: widget.product.name ?? '',
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.left,
            fontSize: screenSize.width * 0.03,
          ),
          SizedBox(height: screenSize.height * 0.02),
          _precio(
            widget.product.price ?? '0',
            widget.product.offer ?? false,
            widget.product.offerPrice ?? '0',
            screenSize,
          ),
          Spacer(),
          CustomButton(
            onTap: () async {
              try {
                var itemCarrito = ItemCarritoModel(
                  idProducto: widget.product.id,
                  cantidadProducto: 1,
                  precioProducto: widget.product.offer == true
                      ? double.parse(widget.product.offerPrice ?? '0')
                      : double.parse(widget.product.price ?? '0'),
                  precioIva: widget.product.offer == true
                      ? double.parse(widget.product.offerPriceWithTax ?? '0')
                      : double.parse(widget.product.priceWithTax ?? '0'),
                  precioDescuento: widget.product.offer == true
                      ? double.parse(widget.product.priceWithTax ?? '0') -
                          double.parse(
                              widget.product.offerPriceWithTax ?? '0')
                      : 0,
                  descripcionProducto: widget.product.description,
                  imagenUrl: '',
                  tipo: widget.product.type,
                  horario: '',
                  vehicleId: 0,
                  vehicleInfo: '',
                  nombre: widget.product.name,
                );

                if (widget.product.type == 'SERVICIO') {
                  final scheduleResponse =
                      await showDialog<ScheduleModalResponseModel>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => CustomModalScheduleService(
                      product: widget.product,
                      vehicles: widget.vehicles,
                    ),
                  );

                  if (scheduleResponse != null) {
                    itemCarrito.horario = scheduleResponse.schedule;
                    itemCarrito.vehicleId = scheduleResponse.vehicleId ?? 0;
                    itemCarrito.vehicleInfo = scheduleResponse.vehicleInfo ?? '';
                  } else {
                    return;
                  }
                }

                await itemsCarritoBloc.agregarItemCarrito(
                    itemCarrito, context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            color: Colors.white,
            text: "Agregar al carrito",
            height: screenSize.height * 0.05,
            fontSize: screenSize.width * 0.03, // 👈 agrega esto
            colorText: config.primary,
          ),
        ],
      ),
    );
  }

  Widget _precio(
      String price, bool offer, String offerPrice, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (offer)
          CustomText(
            text: '\$ $offerPrice',
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            fontSize: screenSize.width * 0.05,
          ),
        CustomText(
          text: '\$ $price',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
          fontSize: screenSize.width * 0.04,
          textDecoration:
              offer ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ],
    );
  }
}