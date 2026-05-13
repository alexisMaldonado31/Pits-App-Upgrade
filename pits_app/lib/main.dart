import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/pages/login_page.dart';
import 'package:pits_app/src/pages/register_page.dart';
import 'package:pits_app/src/pages/welcome_page.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPref();
  prefs.url = 'https://pitsmotors.com/a2067bba65bb2b45448c1f096f6988fd/api';

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  var configuredApp = AppConfig(
    flavorName: "dev",
    primary: Color.fromRGBO(41, 39, 32, 1),
    accent: Color.fromRGBO(248, 200, 36, 1),
    secondary: Color.fromRGBO(97, 96, 93, 1),
    child: MyApp(),
  );

  runApp(configuredApp);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'DP Motors',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('es', "ES"),
      ],
      // initialRoute: prefs.customerInfo == '' ? 'welcome' : 'home',
      initialRoute: 'welcome',
      routes: {
        // 'home': (BuildContext context) => HomePage(),
        'welcome': (BuildContext context) => WelcomePage(),
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
      },
    );
  }
}
