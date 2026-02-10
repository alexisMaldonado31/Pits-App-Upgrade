import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/customer_model.dart';
import 'package:pits_app/src/services/login_service.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared/custom_snackbar.dart';
import 'package:pits_app/src/shared/custom_text_button.dart';
import 'package:pits_app/src/shared/custom_text_field.dart';
import 'package:pits_app/src/shared/logo.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:pits_app/src/utils/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final loginService = LoginService();
  final prefs = PreferenciasUsuario();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    final sizeBox = screenSize.height * 0.06;
    final sizeFont = screenSize.height * 0.022;
    final colorFondoInput = config.primary;
    final colorTexto = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text('LOG-IN'),
        centerTitle: true,
        backgroundColor: config.secondary,
      ),
      body: IgnorePointer(
        ignoring: loading,
        child: Container(
          height:
              screenSize.height -
              kToolbarHeight -
              MediaQuery.of(context).padding.top,
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
                    _crearInputEmail(
                      sizeBox,
                      sizeFont,
                      colorFondoInput,
                      colorTexto,
                    ),
                    _crearInputContrasenia(
                      sizeBox,
                      sizeFont,
                      colorFondoInput,
                      colorTexto,
                    ),
                    SizedBox(height: screenSize.height * 0.05),
                    _crearButtonIniciarSesion(
                      config.accent.withOpacity(0.9),
                      sizeBox,
                      sizeFont,
                    ),
                    _crearTextButtonOlvideContrasenia(Colors.white, screenSize),
                    // CustomFacebookButton(),
                    // ButtonLoginGoogle(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearInputEmail(
    double sizeBox,
    double sizeFont,
    Color colorFondoInput,
    Color colorTexto,
  ) {
    return CustomTextField(
      sizeBox: sizeBox,
      sizeFont: sizeFont,
      colorFondo: colorFondoInput,
      colorTexto: colorTexto,
      colorHintText: Colors.white60,
      controller: _emailController,
      margin: EdgeInsets.symmetric(vertical: sizeBox / 4),
      hintText: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: comprobarCorreo,
      prefixIcon: Icons.person_rounded,
    );
  }

  Widget _crearInputContrasenia(
    double sizeBox,
    double sizeFont,
    Color colorFondoInput,
    Color colorTexto,
  ) {
    return CustomTextField(
      sizeBox: sizeBox,
      sizeFont: sizeFont,
      colorFondo: colorFondoInput,
      colorTexto: colorTexto,
      colorHintText: Colors.white60,
      controller: _passwordController,
      margin: EdgeInsets.symmetric(vertical: sizeBox / 4),
      hintText: 'Contraseña',
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: comprobarCampoNoVacio,
      prefixIcon: Icons.lock_open_rounded,
    );
  }

  Widget _crearButtonIniciarSesion(
    Color color,
    double sizeBox,
    double sizeFont,
  ) {
    return loading
        ? CustomLoading()
        : CustomButton(
            color: color,
            text: "Iniciar Sesión",
            height: sizeBox,
            fontSize: sizeFont,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              if (!_formKey.currentState!.validate()) return;

              setState(() {
                loading = true;
              });

              var res = await loginService.login(
                _emailController.text,
                _passwordController.text,
              );

              if (res!.id != null) {
                prefs.customerInfo = customerModelToJson(res);
                var parameters = await loginService.getParameters();
                prefs.whatsapp = parameters!.whatsapp;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'home',
                  (route) => false,
                );
              } else {
                mostrarSnackbar(
                  'Error al iniciar sesión',
                  Colors.redAccent,
                  context,
                );
              }

              setState(() {
                loading = false;
              });
            },
          );
  }

  Widget _crearTextButtonOlvideContrasenia(Color color, Size screenSize) {
    return CustomTextButton(
      text: "Olvidé mi contraseña",
      padding: EdgeInsets.zero,
      textColor: color,
      onTap: () {
        // Navigator.push(
        //   context,
        //   new MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
        // );
      },
    );
  }
}
