import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/services/login_service.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared/custom_snackbar.dart';
import 'package:pits_app/src/shared/custom_text_field.dart';
import 'package:pits_app/src/shared/logo.dart';
import 'package:pits_app/src/utils/validators.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool loading = false;
  bool redirect = false;

  final _formKey = GlobalKey<FormState>();
  final loginService = LoginService();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;
    final sizeBox = screenSize.height * 0.06;
    final sizeFont = screenSize.height * 0.022;

    return Scaffold(
      appBar: AppBar(
        title: Text('Olvidé mi contraseña'),
      ),
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
                    Text(
                      "Ingrese el correo electrónico con el que se registró por primera vez.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: sizeFont,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    if (redirect)
                      Text(
                        "En un momento será redirigido a la pantalla de Login.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize.height * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    SizedBox(height: screenSize.height * 0.03),
                    CustomTextField(
                      sizeBox: sizeBox,
                      sizeFont: sizeFont,
                      colorFondo: config.primary,
                      colorTexto: Colors.white,
                      colorHintText: Colors.white60,
                      controller: _emailController,
                      margin: EdgeInsets.symmetric(vertical: sizeBox / 4),
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: comprobarCorreo,
                      prefixIcon: Icons.person_rounded,
                    ),
                    loading
                        ? CustomLoading()
                        : CustomButton(
                            color: config.accent.withOpacity(0.9),
                            text: "Recuperar Contraseña",
                            height: sizeBox,
                            fontSize: sizeFont,
                            onTap: _recuperarContrasenia,
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

  Future<void> _recuperarContrasenia() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final res = await loginService.forgetPassword(_emailController.text);

      if (res) {
        setState(() => redirect = true);
        mostrarSnackbar(
          "Se ha enviado un correo con la nueva clave provisional.",
          Colors.green,
          context,
        );
        Timer(Duration(seconds: 3), () => Navigator.pop(context));
      } else {
        mostrarSnackbar(
          "El correo proporcionado no se encuentra registrado.",
          Colors.red,
          context,
        );
      }
    } catch (e) {
      mostrarSnackbar(
        "Error de conexión. Intenta de nuevo.",
        Colors.red,
        context,
      );
    } finally {
      setState(() => loading = false);
    }
  }
}