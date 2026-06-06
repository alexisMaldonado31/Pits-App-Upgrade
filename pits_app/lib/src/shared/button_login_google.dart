import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn, GoogleSignInAccount;
import 'package:pits_app/src/services/login_service.dart';
import 'package:pits_app/src/shared/custom_snackbar.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

class ButtonLoginGoogle extends StatelessWidget {
  const ButtonLoginGoogle({super.key});

  static final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final prefs = PreferenciasUsuario();
    final loginService = LoginService();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(219, 68, 55, 1),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        minimumSize: Size(double.infinity, screenSize.height * 0.06), // 👈 mismo alto que Iniciar Sesión
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // 👈 cuadrado
        ),
      ),
      onPressed: () async {
        try {
          final user = await login();
          if (user == null) return;

          final loginGoogle = await loginService.loginGoogle(user);

          if (loginGoogle == null) {
            mostrarSnackbar(
                'Error al iniciar sesión con Google', Colors.redAccent, context);
            return;
          }

          if (loginGoogle.id != null) {
            prefs.customerInfo = jsonEncode(loginGoogle.toJson());
            final parameters = await loginService.getParameters();
            prefs.whatsapp = parameters?.whatsapp ?? '';
            prefs.googleSign = true;
            Navigator.pushNamedAndRemoveUntil(
              context,
              'home',
              (route) => false,
            );
          } else {
            mostrarSnackbar(
                'Error al iniciar sesión con Google', Colors.redAccent, context);
          }
        } catch (e) {
          mostrarSnackbar(
              'Error al iniciar sesión con Google', Colors.redAccent, context);
        }
      },
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: screenSize.width * 0.1),
            Icon(
              FontAwesomeIcons.google,
              size: screenSize.height * 0.025,
              color: Colors.white,
            ),
            VerticalDivider(
              thickness: 0.5,
              width: 20,
              color: Colors.white,
            ),
            SizedBox(width: screenSize.width * 0.1),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Ingresar con ",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontSize: screenSize.height * 0.02,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                  TextSpan(
                    text: "Google",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: screenSize.height * 0.022,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}