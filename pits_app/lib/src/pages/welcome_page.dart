import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/logo.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var config = AppConfig.of(context);
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.06),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background.png'),
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(
              config.secondary.withValues(alpha: 0.95),
              BlendMode.modulate,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Logo(
              height: screenSize.height * 0.2,
              width: screenSize.width * 0.8,
              tag: "logoWelcome",
            ),
            Spacer(flex: 10),
            _mensajeBienvenida(context, screenSize),
            Spacer(flex: 1),
            _botonesAcceso(context, screenSize),
          ],
        ),
      ),
    );
  }

  Widget _mensajeBienvenida(BuildContext context, Size screenSize) {
    final colorMensaje = Colors.white;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Text(
              'Bienvenido',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorMensaje,
                fontSize: screenSize.height * 0.05,
                fontWeight: FontWeight.w700,
                fontFamily: 'Helvetica',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
            width: double.infinity,
            child: Text(
              'Descubre talleres certificados y lleva el historial de mantenimiento de tu auto',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorMensaje,
                fontSize: screenSize.width * 0.045,
                fontFamily: 'Helvetica',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonesAcceso(BuildContext context, Size screenSize) {
    var botones = [
      Expanded(child: _registrate(context, screenSize)),
      SizedBox(width: screenSize.width * 0.02),
      Expanded(child: _ingresa(context, screenSize)),
    ];

    return SizedBox(
      height: screenSize.height * 0.07,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
        child: Row(mainAxisSize: MainAxisSize.max, children: botones),
      ),
    );
  }

  Widget _registrate(BuildContext context, Size screenSize) {
    var config = AppConfig.of(context);
    return CustomButton(
      color: config.accent.withOpacity(0.6),
      onTap: () {
        Navigator.pushNamed(context, 'register');
      },
      text: 'Regístrate',
      height: screenSize.height * 0.07,
      fontSize: screenSize.width * 0.045,
    );
  }

  Widget _ingresa(BuildContext context, Size screenSize) {
    var config = AppConfig.of(context);
    return CustomButton(
      color: config.primary.withValues(alpha: 0.6),
      onTap: () {
        Navigator.pushNamed(context, 'login');
      },
      text: 'Ingresa',
      height: screenSize.height * 0.07,
      fontSize: screenSize.width * 0.045,
    );
  }
}
