import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/customer_update_model.dart';
import 'package:pits_app/src/services/customer_service.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared/custom_snackbar.dart';
import 'package:pits_app/src/shared/custom_text_field.dart';
import 'package:pits_app/src/shared/logo.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:pits_app/src/utils/validators.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final customerService = CustomerService();
  final prefs = PreferenciasUsuario();

  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;
    final sizeBox = screenSize.height * 0.06;
    final sizeFont = screenSize.height * 0.022;

    return Scaffold(
      appBar: AppBar(title: Text('Cambiar mi contraseña')),
      body: IgnorePointer(
        ignoring: loading,
        child: Container(
          height: screenSize.height - kToolbarHeight - MediaQuery.of(context).padding.top,
          padding: EdgeInsets.symmetric(horizontal: sizeBox / 4),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/background.png"),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                config.secondary.withOpacity(0.95),
                BlendMode.modulate,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                width: screenSize.width,
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.01,
                  horizontal: screenSize.width * 0.05,
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.04),
                    Logo(
                      height: screenSize.height * 0.2,
                      width: screenSize.width * 0.8,
                      tag: "logoWelcome",
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                    CustomTextField(
                      sizeBox: sizeBox,
                      sizeFont: sizeFont,
                      colorFondo: config.primary,
                      colorTexto: Colors.white,
                      colorHintText: Colors.white60,
                      controller: _passwordController,
                      margin: EdgeInsets.symmetric(vertical: sizeBox / 4),
                      hintText: 'Nueva Contraseña',
                      keyboardType: TextInputType.text,
                      validator: comprobarCampoNoVacio,
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    CustomTextField(
                      sizeBox: sizeBox,
                      sizeFont: sizeFont,
                      colorFondo: config.primary,
                      colorTexto: Colors.white,
                      colorHintText: Colors.white60,
                      controller: _passwordConfirmController,
                      margin: EdgeInsets.symmetric(vertical: sizeBox / 4),
                      hintText: 'Confirmar Contraseña',
                      keyboardType: TextInputType.text,
                      validator: comprobarCampoNoVacio,
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    SizedBox(height: screenSize.height * 0.03),
                    loading
                        ? CustomLoading()
                        : CustomButton(
                            color: config.accent.withOpacity(0.9),
                            text: "Cambiar Contraseña",
                            height: sizeBox,
                            fontSize: sizeFont,
                            onTap: _cambiarContrasenia,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _cambiarContrasenia() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _passwordConfirmController.text) {
      mostrarSnackbar("Las contraseñas no coinciden", Colors.red, context);
      return;
    }

    setState(() => loading = true);

    try {
      final customer = CustomerUpdateModel.fromJson(
        json.decode(prefs.customerInfo),
      );
      customer.password = _passwordController.text;

      final res = await customerService.putCustomer(customer.id!, customer);

      if (res != null && res.id != null) {
        mostrarSnackbar("Contraseña actualizada correctamente", Colors.green, context);
        setState(() {
          _passwordController.text = '';
          _passwordConfirmController.text = '';
        });
      } else {
        mostrarSnackbar("No se pudo actualizar la contraseña", Colors.red, context);
      }
    } catch (e) {
      mostrarSnackbar("Error: $e", Colors.red, context);
    } finally {
      setState(() => loading = false);
    }
  }
}