class ItemCarritoModel {
  int? idItemCarrito;
  int? idProducto;
  String? descripcionProducto;
  int? cantidadProducto;
  int? stock;
  double? precioProducto;
  double? precioIva;
  double? precioDescuento;
  String? imagenUrl;
  String? tipo;
  String? horario;
  int? vehicleId;
  String? vehicleInfo;
  String? nombre;

  ItemCarritoModel({
    this.idItemCarrito,
    this.idProducto,
    this.descripcionProducto,
    this.cantidadProducto,
    this.stock,
    this.precioProducto,
    this.precioDescuento,
    this.precioIva,
    this.imagenUrl,
    this.tipo,
    this.horario,
    this.vehicleId,
    this.vehicleInfo,
    this.nombre,
  });

  factory ItemCarritoModel.fromJson(Map<String, dynamic> json) =>
      ItemCarritoModel(
        idItemCarrito: json["idItemCarrito"],
        idProducto: json["idProducto"],
        descripcionProducto: json["descripcionProducto"],
        cantidadProducto: json["cantidadProducto"],
        stock: json['stock'],
        precioProducto: json["precioProducto"]?.toDouble(),
        precioIva: json["precioIva"]?.toDouble(),
        precioDescuento: json["precioDescuento"]?.toDouble(),
        imagenUrl: json["imagenUrl"],
        tipo: json["tipo"],
        horario: json["horario"],
        vehicleId: json["vehicleId"],
        vehicleInfo: json["vehicleInfo"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "idItemCarrito": idItemCarrito,
        "idProducto": idProducto,
        "descripcionProducto": descripcionProducto,
        "cantidadProducto": cantidadProducto,
        "stock": stock,
        "precioProducto": precioProducto,
        "precioIva": precioIva,
        "precioDescuento": precioDescuento,
        "imagenUrl": imagenUrl,
        "tipo": tipo,
        "horario": horario,
        "vehicleId": vehicleId,
        "vehicleInfo": vehicleInfo,
        "nombre": nombre,
      };
}