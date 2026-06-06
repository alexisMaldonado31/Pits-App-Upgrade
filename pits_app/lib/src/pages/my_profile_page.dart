import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/pages/contact_page.dart';
import 'package:pits_app/src/pages/profile_page.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:pits_app/src/shared/custom_title.dart';
import 'package:pits_app/src/pages/orders_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/background.png"),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            config.secondary.withOpacity(1),
            BlendMode.modulate,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.025,
      ),
      child: Column(
        children: [
          CustomTitle(text: "Mi Perfil"),
          _boton(
            context, screenSize, config,
            titulo: "Datos Personales",
            icono: FontAwesomeIcons.idCard,
            onTap: () => pushScreen(
              context,
              screen: ProfilePage(),
              withNavBar: false, // 👈 oculta el nav bar
            ),
          ),
          _boton(
            context, screenSize, config,
            titulo: "Mis Órdenes",
            icono: FontAwesomeIcons.fileInvoiceDollar,
            onTap: () => pushScreen(
              context,
              screen: OrdersPage(),
              withNavBar: false,
            ),
          ),
          _boton(
            context, screenSize, config,
            titulo: "Ayuda en Línea",
            icono: FontAwesomeIcons.phone,
            onTap: () => pushScreen(
              context,
              screen: ContactPage(),
              withNavBar: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _boton(
    BuildContext context,
    Size screenSize,
    AppConfig config, {
    required String titulo,
    required IconData icono,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: screenSize.height * 0.2,
        decoration: BoxDecoration(
          color: config.accent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(screenSize.height * 0.015),
        ),
        margin: EdgeInsets.only(bottom: screenSize.width * 0.05),
        padding: EdgeInsets.all(screenSize.width * 0.03),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: titulo,
                colorText: Colors.white,
                fontSize: screenSize.width * 0.06,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              FaIcon(icono, color: Colors.white, size: screenSize.width * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}