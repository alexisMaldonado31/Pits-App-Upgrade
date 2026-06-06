import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; 
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/pages/login_page.dart';
import 'package:pits_app/src/pages/register_page.dart';
import 'package:pits_app/src/pages/welcome_page.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:pits_app/src/pages/home_page.dart';
import 'package:pits_app/src/pages/forgot_password_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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

  FlutterNativeSplash.remove(); // 👈 3. Quita el splash DESPUÉS de initPref()

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
      title: 'Pits App',
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
        'home': (BuildContext context) => HomePage(),
        'welcome': (BuildContext context) => WelcomePage(),
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'forgot_password': (BuildContext context) => ForgotPasswordPage(),
      },
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(97, 96, 93, 1),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Helvetica',
            fontSize: 18,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white.withOpacity(0.3),
          selectionHandleColor: Colors.white,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Color(0xFF092e7d),
        ),
      ),
    );
  }
}
