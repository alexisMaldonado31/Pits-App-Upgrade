import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pits_app/src/bloc/carrito_bloc.dart';
import 'package:pits_app/src/bloc/db_provider.dart';
import 'package:pits_app/src/models/item_carrito_model.dart';
import 'package:pits_app/src/models/total_model.dart';
import 'package:pits_app/src/shared/custom_snackbar.dart';

class ItemsCarritoBloc {
  static final ItemsCarritoBloc _singleton = ItemsCarritoBloc._internal();
  factory ItemsCarritoBloc() => _singleton;

  final carritoBloc = CarritoBloc();

  ItemsCarritoBloc._internal() {
    obtenerItemsCarrito();
  }

  final _itemsCarritoController =
      StreamController<List<ItemCarritoModel>>.broadcast();
  final _totalCarritoController = StreamController<Total>.broadcast();

  Stream<List<ItemCarritoModel>> itemsCarritoStream() {
    obtenerItemsCarrito();
    return _itemsCarritoController.stream;
  }

  Stream<Total> totalCarritoStream() {
    obtenerTotalCarrito();
    return _totalCarritoController.stream;
  }

  void dispose() {
    _itemsCarritoController.close();
    _totalCarritoController.close();
  }

  Future<void> obtenerItemsCarrito() async {
    _itemsCarritoController.sink
        .add(await DBProvider.db.getAllItemsCarrito());
  }

  Future<void> obtenerTotalCarrito() async {
    _totalCarritoController.sink.add(await DBProvider.db.totalCarrito());
  }

  Future<int> agregarItemCarrito(
      ItemCarritoModel itemCarrito, BuildContext context) async {
    int idItemCarrito =
        await DBProvider.db.existeProductoEnCarrito(itemCarrito.idProducto!);
    int resIdItemCarrito;

    if (idItemCarrito == 0) {
      resIdItemCarrito = await DBProvider.db.nuevoItemCarrito(itemCarrito);
    } else {
      itemCarrito.idItemCarrito = idItemCarrito;
      await DBProvider.db.updateItemCarrito(itemCarrito);
      resIdItemCarrito = idItemCarrito;
    }

    obtenerItemsCarrito();
    carritoBloc.carritoStream();
    carritoBloc.itemAgregado();
    mostrarSnackbar("Tu producto se agregó al carrito", Colors.green, context);
    return resIdItemCarrito;
  }

  Future<void> actualizarCantidadItemCarrito(
      ItemCarritoModel itemCarrito, int cambioCantidad) async {
    if ((itemCarrito.cantidadProducto ?? 0) + cambioCantidad == 0) {
      await DBProvider.db.deleteItemCarrito(itemCarrito.idItemCarrito!);
    } else {
      itemCarrito.cantidadProducto =
          (itemCarrito.cantidadProducto ?? 0) + cambioCantidad;
      await DBProvider.db.updateItemCarrito(itemCarrito);
    }
    obtenerItemsCarrito();
    carritoBloc.carritoStream();
  }

  Future<void> borrarItemCarrito(int id) async {
    await DBProvider.db.deleteItemCarrito(id);
    obtenerItemsCarrito();
    carritoBloc.carritoStream();
  }

  Future<void> borrarAllItemsCarrito() async {
    await DBProvider.db.deleteAllItemsCarrito();
    obtenerItemsCarrito();
  }
}