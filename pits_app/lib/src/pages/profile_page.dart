import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/customer_model.dart';
import 'package:pits_app/src/models/customer_update_model.dart';
import 'package:pits_app/src/models/province_model.dart';
import 'package:pits_app/src/pages/change_password_page.dart';
import 'package:pits_app/src/services/customer_service.dart';
import 'package:pits_app/src/services/provinces_service.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/custom_dropdown.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared/custom_snackbar.dart';
import 'package:pits_app/src/shared/custom_text_button.dart';
import 'package:pits_app/src/shared/custom_text_field.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:pits_app/src/utils/validators.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formProfileKey = GlobalKey<FormState>();
  final prefs = PreferenciasUsuario();
  final customerService = CustomerService();
  final provinceService = ProvincesService();

  List<ProvinceModel> provinces = [];

  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _emailController = TextEditingController();
  final _identificacionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _direccionController = TextEditingController();
  final _kmRadioController = TextEditingController();
  final keyProvince = GlobalKey<FormFieldState>();
  int? provinceSelected;

  bool loading = false;
  bool loadingProvinces = false;

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _identificacionController.dispose();
    _telefonoController.dispose();
    _ciudadController.dispose();
    _direccionController.dispose();
    _kmRadioController.dispose();
    super.dispose();
  }

  Future<void> loadProvinces() async {
    setState(() => loadingProvinces = true);
    provinces = await provinceService.getProvinces();
    setState(() => loadingProvinces = false);
  }

  void loadForm() {
    final customerInfo = CustomerModel.fromJson(json.decode(prefs.customerInfo));
    _nombresController.text = customerInfo.firstname ?? '';
    _apellidosController.text = customerInfo.lastname ?? '';
    _emailController.text = customerInfo.email ?? '';
    _identificacionController.text = customerInfo.document ?? '';
    _telefonoController.text = customerInfo.mobile ?? '';
    _ciudadController.text = customerInfo.city ?? '';
    _direccionController.text = customerInfo.address ?? '';
    _kmRadioController.text = customerInfo.kilometersRadio ?? '';
    provinceSelected = customerInfo.provinceId;
    keyProvince.currentState?.didChange(customerInfo.provinceId);
  }

  Future<void> loadPage() async {
    await loadProvinces();
    loadForm();
  }

  @override
  void initState() {
    super.initState();
    loadPage();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;
    final sizeBox = screenSize.height * 0.06;
    final sizeFont = screenSize.height * 0.022;
    final colorFondoInput = config.primary;
    final colorTexto = Colors.white;

    return Scaffold(
      appBar: AppBar(title: Text("Datos Personales")),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.01,
          horizontal: screenSize.width * 0.05,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              config.secondary.withOpacity(0.95),
              BlendMode.modulate,
            ),
          ),
        ),
        height: screenSize.height - kToolbarHeight - MediaQuery.of(context).padding.top,
        width: screenSize.width,
        child: IgnorePointer(
          ignoring: loading,
          child: SingleChildScrollView(
            child: Form(
              key: _formProfileKey,
              child: Column(
                children: [
                  IgnorePointer(
                    ignoring: true,
                    child: CustomTextField(
                      sizeBox: sizeBox,
                      sizeFont: sizeFont,
                      colorFondo: colorFondoInput,
                      colorTexto: colorTexto,
                      colorHintText: Colors.white60,
                      controller: _emailController,
                      margin: EdgeInsets.symmetric(
                          horizontal: sizeBox / 4, vertical: sizeBox / 4),
                      hintText: 'Correo Electrónico',
                      keyboardType: TextInputType.emailAddress,
                      validator: comprobarCorreo,
                      label: true,
                    ),
                  ),
                  CustomTextButton(
                    text: "Cambiar contraseña",
                    padding: EdgeInsets.zero,
                    textColor: colorTexto,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordPage(),
                        ),
                      );
                    },
                  ),
                  Divider(color: Colors.white),
                  CustomTextField(
                    sizeBox: sizeBox,
                    sizeFont: sizeFont,
                    colorFondo: colorFondoInput,
                    colorTexto: colorTexto,
                    colorHintText: Colors.white60,
                    controller: _nombresController,
                    margin: EdgeInsets.symmetric(
                        horizontal: sizeBox / 4, vertical: sizeBox / 4),
                    hintText: 'Nombres',
                    keyboardType: TextInputType.text,
                    validator: comprobarSoloLetras,
                    label: true,
                  ),
                  CustomTextField(
                    sizeBox: sizeBox,
                    sizeFont: sizeFont,
                    colorFondo: colorFondoInput,
                    colorTexto: colorTexto,
                    colorHintText: Colors.white60,
                    controller: _apellidosController,
                    margin: EdgeInsets.symmetric(
                        horizontal: sizeBox / 4, vertical: sizeBox / 4),
                    hintText: 'Apellidos',
                    keyboardType: TextInputType.text,
                    validator: comprobarSoloLetras,
                    label: true,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          sizeBox: sizeBox,
                          sizeFont: sizeFont,
                          colorFondo: colorFondoInput,
                          colorTexto: colorTexto,
                          colorHintText: Colors.white60,
                          controller: _identificacionController,
                          margin: EdgeInsets.symmetric(
                              horizontal: sizeBox / 4, vertical: sizeBox / 4),
                          hintText: 'Identificación',
                          keyboardType: TextInputType.text,
                          validator: comprobarCampoNoVacio,
                          label: true,
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          sizeBox: sizeBox,
                          sizeFont: sizeFont,
                          colorFondo: colorFondoInput,
                          colorTexto: colorTexto,
                          colorHintText: Colors.white60,
                          controller: _telefonoController,
                          margin: EdgeInsets.symmetric(
                              horizontal: sizeBox / 4, vertical: sizeBox / 4),
                          hintText: 'Teléfono',
                          keyboardType: TextInputType.number,
                          validator: comprobarSoloNumeros,
                          label: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: loadingProvinces
                            ? CustomLoading()
                            : CustomDropDown(
                                items: provinces
                                    .map((e) => CustomDropDownItem(
                                          content: e.name,
                                          index: e.id,
                                        ))
                                    .toList(),
                                llave: keyProvince,
                                sizeBox: sizeBox,
                                indexResponse: false,
                                colorFondo: colorFondoInput,
                                colorTexto: Colors.white,
                                hintText: "Provincia",
                                sizeFont: sizeFont,
                                label: 'Provincia',
                                margin: EdgeInsets.symmetric(
                                    horizontal: sizeBox / 4,
                                    vertical: sizeBox / 4),
                                obligatorio: true,
                                initialValue: provinceSelected,
                                validator: (value) => value != null,
                                onChanged: (value) {
                                  setState(() => provinceSelected = value);
                                },
                              ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          sizeBox: sizeBox,
                          sizeFont: sizeFont,
                          colorFondo: colorFondoInput,
                          colorTexto: colorTexto,
                          colorHintText: Colors.white60,
                          controller: _ciudadController,
                          margin: EdgeInsets.symmetric(
                              horizontal: sizeBox / 4, vertical: sizeBox / 4),
                          hintText: 'Ciudad',
                          keyboardType: TextInputType.text,
                          validator: comprobarCampoNoVacio,
                          label: true,
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    sizeBox: sizeBox,
                    sizeFont: sizeFont,
                    colorFondo: colorFondoInput,
                    colorTexto: colorTexto,
                    colorHintText: Colors.white60,
                    controller: _direccionController,
                    margin: EdgeInsets.symmetric(
                        horizontal: sizeBox / 4, vertical: sizeBox / 4),
                    hintText: 'Dirección',
                    keyboardType: TextInputType.text,
                    validator: comprobarCampoNoVacio,
                    label: true,
                  ),
                  Divider(color: Colors.white),
                  CustomTextField(
                    sizeBox: sizeBox,
                    sizeFont: sizeFont,
                    colorFondo: colorFondoInput,
                    colorTexto: colorTexto,
                    colorHintText: Colors.white60,
                    controller: _kmRadioController,
                    margin: EdgeInsets.symmetric(
                        horizontal: sizeBox / 4, vertical: sizeBox / 4),
                    hintText: 'Rango de Búsqueda (Km)',
                    keyboardType: TextInputType.number,
                    label: true,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizeBox / 4),
                    child: loading
                        ? CustomLoading()
                        : CustomButton(
                            color: config.accent,
                            text: "Editar Usuario",
                            height: sizeBox,
                            fontSize: sizeFont,
                            onTap: _actualizarUsuario,
                            colorText: config.primary,
                          ),
                  ),
                  SizedBox(height: 30), // 👈 agrega esto al final
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _actualizarUsuario() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_formProfileKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final customer = CustomerUpdateModel.fromJson(
        json.decode(prefs.customerInfo),
      );

      customer.firstname = _nombresController.text;
      customer.lastname = _apellidosController.text;
      customer.document = _identificacionController.text;
      customer.mobile = _telefonoController.text;
      customer.city = _ciudadController.text;
      customer.address = _direccionController.text;
      customer.provinceId = provinceSelected;
      customer.kilometersRadio = _kmRadioController.text;

      final res = await customerService.putCustomer(customer.id!, customer);

      if (res != null && res.id != null) {
        prefs.customerInfo = jsonEncode(res.toJson());
        mostrarSnackbar('Actualizado Correctamente', Colors.green, context);
      } else {
        mostrarSnackbar('Error al actualizar', Colors.redAccent, context);
      }
    } catch (e) {
      mostrarSnackbar('Error: $e', Colors.redAccent, context);
    } finally {
      setState(() => loading = false);
    }
  }
}