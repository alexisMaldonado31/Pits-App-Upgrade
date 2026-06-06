import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/shared/logo.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

// Pantallas temporales — las iremos reemplazando una a una
import 'package:pits_app/src/pages/advertisement_page.dart';
import 'package:pits_app/src/pages/news_page.dart';
import 'package:pits_app/src/pages/my_profile_page.dart';
import 'package:pits_app/src/pages/vehicles_list_page.dart';
import 'package:pits_app/src/pages/search_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final prefs = PreferenciasUsuario();
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      AdvertisementPage(),           // Promociones
      _pantallaProximamente("Mi Perfil"),
      _pantallaProximamente("Buscador"),
      _pantallaProximamente("Mis Autos"),
      _pantallaProximamente("Pits Live"),
    ];
  }

  // Placeholder temporal para pantallas no desarrolladas aún
  Widget _pantallaProximamente(String nombre) {
    return Center(
      child: Text(
        nombre,
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  List<PersistentTabConfig> _navBarItems(Color activeColor) {
    return [
      PersistentTabConfig(
        screen: AdvertisementPage(),
        item: ItemConfig(
          icon: Icon(FontAwesomeIcons.gifts, size: 24),
          title: "Promociones",
          activeForegroundColor: activeColor,
          inactiveForegroundColor: Colors.grey,
          textStyle: TextStyle(fontFamily: 'Gothic'),
        ),
      ),
      PersistentTabConfig(
        screen: MyProfilePage(),
        item: ItemConfig(
          icon: Icon(FontAwesomeIcons.userLarge, size: 24),
          title: "Mi Perfil",
          activeForegroundColor: activeColor,
          inactiveForegroundColor: Colors.grey,
          textStyle: TextStyle(fontFamily: 'Gothic'),
        ),
      ),
      PersistentTabConfig(
        screen: SearchPage(),
        item: ItemConfig(
          icon: Icon(FontAwesomeIcons.magnifyingGlass, size: 24),
          title: "Buscador",
          activeForegroundColor: activeColor,
          inactiveForegroundColor: Colors.grey,
          textStyle: TextStyle(fontFamily: 'Gothic'),
        ),
      ),
      PersistentTabConfig(
        screen: VehiclesListPage(),
        item: ItemConfig(
          icon: Icon(FontAwesomeIcons.car, size: 24),
          title: "Mis Autos",
          activeForegroundColor: activeColor,
          inactiveForegroundColor: Colors.grey,
          textStyle: TextStyle(fontFamily: 'Gothic'),
        ),
      ),
      PersistentTabConfig(
        screen: NewsPage(),
        item: ItemConfig(
          icon: Icon(FontAwesomeIcons.newspaper, size: 24),
          title: "Pits Live 🔴",
          activeForegroundColor: activeColor,
          inactiveForegroundColor: Colors.grey,
          textStyle: TextStyle(fontFamily: 'Gothic'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Logo(
          width: screenSize.width * 0.4,
          height: screenSize.height * 0.15,
          tag: "appBarHome",
        ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.rightFromBracket),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => _modalCerrarSesion(screenSize, config.accent),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: _whatsappButton(),
      ),
      body: PersistentTabView(
        controller: _controller,
        navBarHeight: 60,
        backgroundColor: config.primary,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        popAllScreensOnTapOfSelectedTab: true,
        tabs: _navBarItems(config.accent),
        navBarBuilder: (navBarConfig) => Style6BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            color: config.primary,
          ),
        ),
      ),
    );
  }

  Widget _whatsappButton() {
    return FloatingActionButton(
      heroTag: 'homeButton',
      backgroundColor: Color(0xFF25D366),
      shape: CircleBorder(), // 👈 fuerza forma circular
      onPressed: () async {
        final uri = Uri.parse('https://wa.me/${prefs.whatsapp}');
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
    );
  }

  Widget _modalCerrarSesion(Size size, Color accent) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        '¿Quiere cerrar la sesión?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Helvetica',
          fontWeight: FontWeight.bold,
          fontSize: size.height * 0.026,
        ),
      ),
      content: Text(
        'Si deseas salir haz clic en Cerrar Sesión o en Cancelar para continuar.',
        style: TextStyle(
          fontFamily: 'Helvetica',
          fontWeight: FontWeight.w500,
          fontSize: size.height * 0.022,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.grey, fontSize: size.height * 0.02),
          ),
        ),
        TextButton(
          onPressed: () {
            prefs.customerInfo = '';
            Navigator.pushReplacementNamed(context, 'welcome');
          },
          child: Text(
            "Cerrar Sesión",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.022,
            ),
          ),
        ),
      ],
    );
  }
}