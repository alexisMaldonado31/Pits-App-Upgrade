import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/bloc/item_carrito_bloc.dart';
import 'package:pits_app/src/models/item_carrito_model.dart';
import 'package:pits_app/src/models/total_model.dart';
import 'package:pits_app/src/shared/custom_richtext.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:pits_app/src/pages/payment_page.dart';

class BottomSheetCarrito extends StatefulWidget {
  final Color primaryColor;
  final int establishmentId;

  const BottomSheetCarrito(this.primaryColor, this.establishmentId,
      {super.key});

  @override
  State<BottomSheetCarrito> createState() => _BottomSheetCarritoState();
}

class _BottomSheetCarritoState extends State<BottomSheetCarrito> {
  final itemsCarritoBloc = ItemsCarritoBloc();
  final prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final config = AppConfig.of(context);

    return StreamBuilder<List<ItemCarritoModel>>(
      stream: itemsCarritoBloc.itemsCarritoStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final itemsCarrito = snapshot.data!;

        return Container(
          color: config.primary.withOpacity(0.8),
          child: Column(
            children: [
              CloseButton(color: config.accent),
              if (itemsCarrito.isEmpty)
                Expanded(
                  child: Center(
                    child: CustomText(
                      text: 'El carrito está vacío',
                      colorText: Colors.white,
                      fontSize: screenSize.width * 0.04,
                    ),
                  ),
                )
              else ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: CustomText(
                    text: 'Elimina un producto deslizando',
                    colorText: config.accent,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                    fontSize: screenSize.width * 0.03,
                  ),
                ),
                Divider(color: Colors.grey, height: 3),
                SizedBox(
                  height: screenSize.height * 0.3,
                  child: ListView.builder(
                    itemCount: itemsCarrito.length,
                    itemBuilder: (context, i) =>
                        _itemCarrito(itemsCarrito[i], config.accent,
                            screenSize.width * 0.04),
                  ),
                ),
                Divider(color: Colors.grey, height: 0.5),
                Spacer(),
                _totalCarrito(screenSize.width, screenSize.height,
                    config.accent, widget.primaryColor),
                Spacer(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _itemCarrito(
      ItemCarritoModel item, Color color, double fontSize) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (_) =>
          itemsCarritoBloc.borrarItemCarrito(item.idItemCarrito!),
      child: Column(
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
            trailing: _acciones(item, color),
          ),
          Divider(color: Colors.white),
        ],
      ),
    );
  }

  Widget _acciones(ItemCarritoModel item, Color color) {
    return Column(
      children: [
        if (item.tipo != 'SERVICIO')
          InkWell(
            onTap: () =>
                itemsCarritoBloc.actualizarCantidadItemCarrito(item, 1),
            child: Icon(Icons.add_circle, color: color),
          ),
        Spacer(),
        InkWell(
          onTap: () =>
              itemsCarritoBloc.actualizarCantidadItemCarrito(item, -1),
          child: Icon(Icons.remove_circle, color: color),
        ),
      ],
    );
  }

  Widget _totalCarrito(
      double maxW, double maxH, Color colorBoton, Color colorTexto) {
    return StreamBuilder<Total>(
      stream: itemsCarritoBloc.totalCarritoStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final total = snapshot.data!;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: maxW * 0.25, right: 0, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomRichText(
                    title: 'Total',
                    content: '${((total.iva ?? 0) - (total.descuento ?? 0)).toStringAsFixed(2)} \$',
                    colorContent: Colors.white,
                    colorTitle: colorBoton,
                    fontSize: maxW * 0.055,
                  ),
                  Row(
                    children: [
                      CustomRichText(
                        title: 'Subtotal',
                        content: '${(total.subtotal ?? 0).toStringAsFixed(2)} \$',
                        colorContent: Colors.white,
                        colorTitle: colorBoton,
                        fontSize: maxW * 0.035,
                      ),
                      SizedBox(width: maxW * 0.02),
                      CustomRichText(
                        title: 'IVA',
                        content: '${((total.iva ?? 0) - (total.subtotal ?? 0)).toStringAsFixed(2)} \$',
                        colorContent: Colors.white,
                        colorTitle: colorBoton,
                        fontSize: maxW * 0.035,
                      ),
                      SizedBox(width: maxW * 0.02),
                      CustomRichText(
                        title: 'Ahorro',
                        content: '${(total.descuento ?? 0).toStringAsFixed(2)} \$',
                        colorContent: Colors.white,
                        colorTitle: colorBoton,
                        fontSize: maxW * 0.035,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentPage(
                      establishmentId: widget.establishmentId,
                    ),
                  ),
                );
                if (res != null) {
                  Navigator.pop(context, true);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: maxW * 0.2), // 👈 empieza desde la mitad
                child: Container(
                  height: maxH * 0.06,
                  width: maxW,
                  decoration: BoxDecoration(
                    color: colorBoton,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "Pagar",
                      fontSize: maxW * 0.05,
                      fontWeight: FontWeight.bold,
                      colorText: colorTexto,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}