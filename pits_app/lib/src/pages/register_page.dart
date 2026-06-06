import 'package:flutter/material.dart';
import 'package:pits_app/src/models/customer_create_model.dart';
import 'package:pits_app/src/services/customer_service.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/custom_snackbar.dart';
import 'package:pits_app/src/shared/custom_text_field.dart';
import 'package:pits_app/src/shared/logo.dart';
import 'package:pits_app/src/utils/validators.dart';
import '../../app_config.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final customerService = CustomerService();

  bool _check = false;
  bool _checkConfirm = true;

  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _identificacionController =
      TextEditingController();

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
        title: Text('REGÍSTRATE'),
      ),
      body: Container(
        height:
            screenSize.height -
            kToolbarHeight -
            MediaQuery.of(context).padding.top,
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              width: screenSize.width,
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.02,
                horizontal: screenSize.width * 0.05,
              ),
              child: Column(
                children: [
                  Logo(
                    height: screenSize.height * 0.075,
                    width: screenSize.width * 0.5,
                    tag: "logoWelcome",
                  ),
                  _crearInputNombre(
                    sizeBox,
                    sizeFont,
                    colorFondoInput,
                    colorTexto,
                  ),
                  _crearInputApellidos(
                    sizeBox,
                    sizeFont,
                    colorFondoInput,
                    colorTexto,
                  ),
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
                  _crearInputIdentificacion(
                    sizeBox,
                    sizeFont,
                    colorFondoInput,
                    colorTexto,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.height * 0.06 / 4,
                    ),
                    child: _crearCheckTerminosCondiciones(
                      config.accent,
                      config.accent,
                      sizeFont,
                    ),
                  ),
                  _crearTextButtonTerminosCondiciones(
                    config.accent,
                    screenSize,
                  ),
                  SizedBox(height: screenSize.height * 0.025),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.height * 0.06 / 4,
                    ),
                    child: CustomButton(
                      color: config.accent,
                      text: "Crear Cuenta",
                      height: sizeBox,
                      fontSize: sizeFont,
                      onTap: _registrarUsuario,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearTextButtonTerminosCondiciones(Color color, Size screenSize) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
      };
      if (states.any(interactiveStates.contains)) {
        return color.withOpacity(0.4);
      }
      return color.withOpacity(0.1);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.height * 0.06 / 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(getColor),
            ),
            onPressed: () async {
              final uri = Uri.parse('https://pitsmotors.com/terminosCondiciones.pdf');
              try {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } catch (e) {
                await launchUrl(uri, mode: LaunchMode.platformDefault);
              }
            },
            child: Text(
              "Ver Terminos y condiciones",
              textAlign: TextAlign.left,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: color,
                fontSize: screenSize.height * 0.018,
                fontFamily: 'Helvetica',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearInputNombre(
    double sizeBox,
    double sizeFont,
    Color colorFondoInput,
    Color colorTexto,
  ) {
    return CustomTextField(
      label: true,
      sizeBox: sizeBox,
      sizeFont: sizeFont,
      colorFondo: colorFondoInput,
      colorTexto: colorTexto,
      colorHintText: Colors.white60,
      controller: _nombresController,
      margin: EdgeInsets.symmetric(
        horizontal: sizeBox / 4,
        vertical: sizeBox / 6,
      ),
      hintText: 'Nombres',
      keyboardType: TextInputType.text,
      validator: comprobarSoloLetras,
    );
  }

  Widget _crearInputApellidos(
    double sizeBox,
    double sizeFont,
    Color colorFondoInput,
    Color colorTexto,
  ) {
    return CustomTextField(
      label: true,
      sizeBox: sizeBox,
      sizeFont: sizeFont,
      colorFondo: colorFondoInput,
      colorTexto: colorTexto,
      colorHintText: Colors.white60,
      controller: _apellidosController,
      margin: EdgeInsets.symmetric(
        horizontal: sizeBox / 4,
        vertical: sizeBox / 6,
      ),
      hintText: 'Apellidos',
      keyboardType: TextInputType.text,
      validator: comprobarSoloLetras,
    );
  }

  Widget _crearInputIdentificacion(
    double sizeBox,
    double sizeFont,
    Color colorFondoInput,
    Color colorTexto,
  ) {
    return CustomTextField(
      label: true,
      sizeBox: sizeBox,
      sizeFont: sizeFont,
      colorFondo: colorFondoInput,
      colorTexto: colorTexto,
      colorHintText: Colors.white60,
      controller: _identificacionController,
      margin: EdgeInsets.symmetric(
        horizontal: sizeBox / 4,
        vertical: sizeBox / 6,
      ),
      hintText: 'Identificación',
      keyboardType: TextInputType.text,
    );
  }

  Widget _crearInputEmail(
    double sizeBox,
    double sizeFont,
    Color colorFondoInput,
    Color colorTexto,
  ) {
    return CustomTextField(
      label: true,
      sizeBox: sizeBox,
      sizeFont: sizeFont,
      colorFondo: colorFondoInput,
      colorTexto: colorTexto,
      colorHintText: Colors.white60,
      controller: _emailController,
      margin: EdgeInsets.symmetric(
        horizontal: sizeBox / 4,
        vertical: sizeBox / 6,
      ),
      hintText: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: comprobarCorreo,
    );
  }

  Widget _crearInputContrasenia(
    double sizeBox,
    double sizeFont,
    Color colorFondoInput,
    Color colorTexto,
  ) {
    return CustomTextField(
      label: true,
      sizeBox: sizeBox,
      sizeFont: sizeFont,
      colorFondo: colorFondoInput,
      colorTexto: colorTexto,
      colorHintText: Colors.white60,
      controller: _passwordController,
      margin: EdgeInsets.symmetric(
        horizontal: sizeBox / 4,
        vertical: sizeBox / 6,
      ),
      hintText: 'Contraseña',
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: comprobarCampoNoVacio,
    );
  }

  Widget _crearCheckTerminosCondiciones(
    Color activeColor,
    Color disableColor,
    double fontSize,
  ) {
    Color getColor(Set<WidgetState> states) {
      if (!_checkConfirm) {
        return Colors.red;
      }
      return disableColor;
    }

    return Row(
      children: [
        Checkbox(
          value: _check,
          checkColor: Colors.white,
          fillColor: WidgetStateColor.resolveWith(getColor),
          onChanged: (value) {
            setState(() {
              _check = value ?? false;
              if (_check) {
                _checkConfirm = true;
              }
            });
          },
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _check = !_check;
                if (_check) {
                  _checkConfirm = true;
                }
              });
            },
            child: Text(
              'Acepto términos y condiciones',
              textAlign: TextAlign.left,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: _checkConfirm ? activeColor : Colors.red,
                fontSize: fontSize,
                fontFamily: 'Helvetica',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _registrarUsuario() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_formKey.currentState!.validate()) return;

    if (!_check) {
      setState(() => _checkConfirm = false);
      return;
    }

    _formKey.currentState!.save();

    final customerCreation = CustomerCreateModel(
      firstname: _nombresController.text,
      lastname: _apellidosController.text,
      email: _emailController.text,
      document: _identificacionController.text,
      password: _passwordController.text,
    );

    try {
      final res = await customerService.postRegisterCustomer(customerCreation);

      if (res.id != null) {
        mostrarSnackbar('Registro éxitoso', Colors.green, context);
        Navigator.popAndPushNamed(context, 'login');
      } else {
        mostrarSnackbar('No se pudo registrar el usuario', Colors.redAccent, context);
      }

    } catch (e) {
      // Muestra el mensaje de la excepción lanzada en el servicio
      mostrarSnackbar(e.toString().replaceAll('Exception: ', ''), Colors.redAccent, context);
    }
  }
}
