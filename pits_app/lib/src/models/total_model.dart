class Total {
  double? subtotal;
  double? iva;
  double? descuento;

  Total({this.subtotal, this.iva, this.descuento});

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        subtotal: json["subtotal"]?.toDouble() ?? 0.0,
        iva: json["iva"]?.toDouble() ?? 0.0,
        descuento: json["descuento"]?.toDouble() ?? 0.0,
      );

  double totalCarrito() {
    return (subtotal ?? 0) + (iva ?? 0) - (descuento ?? 0);
  }
}