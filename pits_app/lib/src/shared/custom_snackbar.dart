import 'package:flutter/material.dart';

void mostrarSnackbar(String mensaje, Color colorAlert, BuildContext context) {
  final snackbar = SnackBar(
    content: Text(mensaje, style: TextStyle(color: Colors.white)),
    duration: Duration(milliseconds: 2000),
    backgroundColor: colorAlert,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
