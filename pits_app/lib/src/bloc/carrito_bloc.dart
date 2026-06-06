import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:pits_app/src/bloc/db_provider.dart';

class CarritoBloc {
  static final CarritoBloc _singleton = CarritoBloc._internal();
  factory CarritoBloc() => _singleton;
  CarritoBloc._internal() {
    obtenerCantidadItemsCarrito();
  }

  final _carritoController = StreamController<int>.broadcast();
  AnimationController? _animationController;

  Stream<int> carritoStream() {
    obtenerCantidadItemsCarrito();
    return _carritoController.stream;
  }

  void dispose() => _carritoController.close();

  Future<void> obtenerCantidadItemsCarrito() async {
    _carritoController.sink.add(await DBProvider.db.getCountItemsCarrito());
  }

  void itemAgregado() {
    try {
      _animationController?.forward(from: 0.0);
    } catch (e) {}
  }

  set bounceController(AnimationController controller) {
    _animationController = controller;
  }
}