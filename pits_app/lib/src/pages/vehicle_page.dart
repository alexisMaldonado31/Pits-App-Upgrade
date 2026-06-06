import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/brand_model.dart';
import 'package:pits_app/src/models/create_vehicle_model.dart';
import 'package:pits_app/src/models/customer_model.dart';
import 'package:pits_app/src/models/vehicle_model.dart';
import 'package:pits_app/src/models/vehicletype_model.dart';
import 'package:pits_app/src/services/vehicle_service.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/custom_dropdown.dart';
import 'package:pits_app/src/shared/custom_snackbar.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:pits_app/src/shared/custom_text_field.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:pits_app/src/utils/validators.dart' as validators;

class VehiclePage extends StatefulWidget {
  final VehicleModel vehicleModel;
  const VehiclePage({super.key, required this.vehicleModel});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  final vehicleServices = VehiclesService();
  final prefs = PreferenciasUsuario();
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  File? imageFile;
  final controllerPlaca = TextEditingController();
  final controllerChassis = TextEditingController();
  final controllerKilometraje = TextEditingController();

  final keyVehicleType = GlobalKey<FormFieldState>();
  final keyBrand = GlobalKey<FormFieldState>();
  int vehicleTypeSelect = 0;
  int brandSelect = 0;

  List<BrandModel> brands = [];
  List<VehicleTypeModel> vehiclesTypes = [];

  bool cargandoBrands = false;
  bool cargandoVehicleTypes = false;
  bool guardando = false;
  bool cargandoFormulario = false;
  bool onSale = false;
  bool _checkConfirm = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    controllerPlaca.dispose();
    controllerChassis.dispose();
    controllerKilometraje.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      cargandoVehicleTypes = true;
      cargandoBrands = true;
      cargandoFormulario = true;
    });

    brands = await vehicleServices.getBrands();
    vehiclesTypes = await vehicleServices.getVehiclesType();

    if (widget.vehicleModel.id != null) {
      controllerChassis.text = widget.vehicleModel.chassis ?? '';
      controllerPlaca.text = widget.vehicleModel.licensePlate ?? '';
      controllerKilometraje.text =
          widget.vehicleModel.kilometers?.toString() ?? '';
      vehicleTypeSelect = widget.vehicleModel.typeVehicleId ?? 0;
      brandSelect = widget.vehicleModel.brandId ?? 0;
      onSale = widget.vehicleModel.onSale ?? false;
    }

    setState(() {
      cargandoVehicleTypes = false;
      cargandoBrands = false;
      cargandoFormulario = false;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        mostrarSnackbar('Permiso de cámara denegado', Colors.red, context);
        return;
      }
    }
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  void _showImagePicker() {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      backgroundColor: config.secondary,
      builder: (_) => SizedBox(
        height: screenSize.height * 0.15,
        child: Column(
          children: [
            ListTile(
              onTap: () => _pickImage(ImageSource.camera),
              title: CustomText(
                text: "Cámara",
                fontSize: screenSize.width * 0.04,
                fontWeight: FontWeight.w500,
                colorText: Colors.white,
              ),
              leading: Icon(Icons.camera_alt_outlined,
                  size: screenSize.width * 0.08, color: Colors.white),
            ),
            ListTile(
              onTap: () => _pickImage(ImageSource.gallery),
              title: CustomText(
                text: "Galería",
                fontSize: screenSize.width * 0.04,
                fontWeight: FontWeight.w500,
                colorText: Colors.white,
              ),
              leading: Icon(Icons.photo,
                  size: screenSize.width * 0.08, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardarAuto() async {
    if (!onSale) setState(() => _checkConfirm = false);
    if (!formKey.currentState!.validate()) return;

    setState(() => guardando = true);

    final customerInfo =
        CustomerModel.fromJson(json.decode(prefs.customerInfo));

    // ✅ Validar placa duplicada (crear y editar)
    final vehiculos = await vehicleServices.getMyVehicles();
    final placaExiste = vehiculos.any(
      (v) =>
          v.licensePlate?.toLowerCase() ==
              controllerPlaca.text.toLowerCase().trim() &&
          v.id != widget.vehicleModel.id,
    );
    if (placaExiste) {
      mostrarSnackbar(
          "Ya tienes un vehículo con esa placa", Colors.red, context);
      setState(() => guardando = false);
      return;
    }

    final createVehicle = CreateVehicleModel(
      brandId: brandSelect,
      typeVehicleId: vehicleTypeSelect,
      chassis: controllerChassis.text,
      licensePlate: controllerPlaca.text,
      customerId: customerInfo.id,
      image: imageFile?.path ?? '',
      kilometraje: controllerKilometraje.text,
      onSale: onSale ? 1 : 0,
    );

    final success = widget.vehicleModel.id != null
        ? await vehicleServices.putVehicleModel(
            widget.vehicleModel.id!, createVehicle)
        : await vehicleServices.postVehicleModel(createVehicle);

    setState(() => guardando = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      mostrarSnackbar("Error al guardar el vehículo", Colors.red, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Mis Autos")),
      backgroundColor: config.primary,
      body: cargandoFormulario
          ? Center(
              child: CircularProgressIndicator(color: config.accent),
            )
          : IgnorePointer(
              ignoring: guardando,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.05,
                          vertical: screenSize.height * 0.02,
                        ),
                        child: InkWell(
                          onTap: _showImagePicker,
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt_rounded,
                                  size: screenSize.width * 0.08,
                                  color: config.accent),
                              SizedBox(width: screenSize.width * 0.05),
                              CustomText(
                                text: widget.vehicleModel.id == null
                                    ? "Seleccionar Foto"
                                    : "Editar Foto",
                                fontSize: screenSize.width * 0.04,
                                fontWeight: FontWeight.bold,
                                colorText: Colors.white,
                              ),
                              Spacer(),
                              if (imageFile != null)
                                SizedBox(
                                  width: screenSize.width * 0.3,
                                  height: screenSize.height * 0.1,
                                  child: Image.file(imageFile!,
                                      fit: BoxFit.fill),
                                )
                              else if (widget.vehicleModel.image != null &&
                                  widget.vehicleModel.image!.isNotEmpty)
                                SizedBox(
                                  width: screenSize.width * 0.3,
                                  height: screenSize.height * 0.1,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.vehicleModel.image!,
                                    fit: BoxFit.fill,
                                    placeholder: (_, __) =>
                                        LinearProgressIndicator(),
                                    errorWidget: (_, __, ___) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: config.secondary,
                        height: screenSize.height * 0.05,
                        width: double.infinity,
                        alignment: Alignment(-0.9, 0),
                        child: CustomText(
                          text: 'INFORMACIÓN BÁSICA',
                          colorText: config.accent,
                          fontSize: screenSize.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      cargandoVehicleTypes
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.02),
                              child: LinearProgressIndicator(
                                  color: config.accent),
                            )
                          : CustomDropDown(
                              items: vehiclesTypes
                                  .map((e) => CustomDropDownItem(
                                      content: e.name, index: e.id))
                                  .toList(),
                              llave: keyVehicleType,
                              sizeBox: screenSize.height * 0.06,
                              indexResponse: false,
                              colorFondo: config.secondary,
                              colorTexto: Colors.white,
                              hintText: "Seleccione un Tipo de Auto",
                              sizeFont: screenSize.width * 0.035,
                              label: 'Tipo de Auto',
                              margin: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.02),
                              obligatorio: true,
                              initialValue: widget.vehicleModel.typeVehicleId,
                              validator: (value) => value != null,
                              onChanged: (value) =>
                                  setState(() => vehicleTypeSelect = value),
                            ),
                      cargandoBrands
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.02),
                              child: LinearProgressIndicator(
                                  color: config.accent),
                            )
                          : CustomDropDown(
                              items: brands
                                  .map((e) => CustomDropDownItem(
                                      content: e.name, index: e.id))
                                  .toList(),
                              llave: keyBrand,
                              sizeBox: screenSize.height * 0.06,
                              indexResponse: false,
                              colorFondo: config.secondary,
                              colorTexto: Colors.white,
                              hintText: "Seleccione una Marca",
                              sizeFont: screenSize.width * 0.035,
                              label: 'Marca',
                              margin: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.02),
                              obligatorio: true,
                              initialValue: widget.vehicleModel.brandId,
                              validator: (value) => value != null,
                              onChanged: (value) =>
                                  setState(() => brandSelect = value),
                            ),
                      SizedBox(height: screenSize.height * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.02),
                        child: CustomTextField(
                          sizeFont: screenSize.width * 0.035,
                          hintText: 'Placa',
                          sizeBox: screenSize.height * 0.06,
                          colorFondo: config.secondary,
                          colorTexto: Colors.white,
                          label: true,
                          controller: controllerPlaca,
                          obligatorio: true,
                          validator: validators.comprobarCampoNoVacio,
                          colorHintText: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.02),
                        child: CustomTextField(
                          sizeFont: screenSize.width * 0.035,
                          hintText: 'Chasis',
                          sizeBox: screenSize.height * 0.06,
                          colorFondo: config.secondary,
                          colorTexto: Colors.white,
                          label: true,
                          controller: controllerChassis,
                          colorHintText: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.02),
                        child: CustomTextField(
                          sizeFont: screenSize.width * 0.035,
                          hintText: 'Kilometraje',
                          sizeBox: screenSize.height * 0.06,
                          colorFondo: config.secondary,
                          colorTexto: Colors.white,
                          label: true,
                          controller: controllerKilometraje,
                          colorHintText: Colors.white,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      _crearCheckOnSale(
                        config.accent,
                        config.secondary,
                        screenSize.width * 0.035,
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.02),
                        child: guardando
                            ? CircularProgressIndicator(color: config.accent)
                            : CustomButton(
                                color: config.accent,
                                colorText: config.primary,
                                text: widget.vehicleModel.id != null
                                    ? "Editar Auto"
                                    : "Guardar Auto",
                                fontSize: screenSize.width * 0.04,
                                height: screenSize.height * 0.05,
                                onTap: _guardarAuto,
                              ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _crearCheckOnSale(
      Color activeColor, Color disableColor, double fontSize) {
    Color getColor(Set<WidgetState> states) {
      if (!_checkConfirm) return Colors.red;
      return disableColor;
    }

    return Row(
      children: [
        Checkbox(
          value: onSale,
          checkColor: activeColor,
          fillColor: WidgetStateColor.resolveWith(getColor),
          onChanged: (value) {
            setState(() {
              onSale = value ?? false;
              if (onSale) _checkConfirm = true;
            });
          },
        ),
        InkWell(
          onTap: () {
            setState(() {
              onSale = !onSale;
              if (onSale) _checkConfirm = true;
            });
          },
          child: Text(
            'En Venta',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: fontSize,
              fontFamily: 'Helvetica',
            ),
          ),
        ),
      ],
    );
  }
}