import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:pits_app/src/bloc/carrito_bloc.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class Carrito extends StatefulWidget {
  final Color colorCarrito;
  final Color notificationColor;
  final Color numberColor;

  const Carrito({
    super.key,
    required this.colorCarrito,
    this.notificationColor = Colors.red,
    this.numberColor = Colors.white,
  });

  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  final carritoBloc = CarritoBloc();

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width;
    final maxH = MediaQuery.of(context).size.height;

    return StreamBuilder<int>(
      stream: carritoBloc.carritoStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Icon(Icons.shopping_cart,
              size: maxH * 0.035, color: widget.colorCarrito);
        }

        final carrito = snapshot.data ?? 0;

        return SizedBox(
          width: maxW * 0.15,
          height: maxW * 0.13,
          child: Stack(
            children: [
              Align(
                child: Icon(Icons.shopping_cart,
                    size: maxH * 0.035, color: widget.colorCarrito),
              ),
              if (carrito > 0)
                Bounce(
                  controller: (controller) =>
                      carritoBloc.bounceController = controller,
                  from: 10,
                  child: Align(
                    alignment: Alignment(0.7, -0.7),
                    child: Container(
                      height: maxW * 0.06,
                      width: maxW * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: widget.notificationColor,
                      ),
                      child: Center(
                        child: CustomText(
                          text: carrito.toString(),
                          colorText: widget.numberColor,
                          fontWeight: FontWeight.w900,
                          textAlign: TextAlign.center,
                          fontSize: maxW * 0.03,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}