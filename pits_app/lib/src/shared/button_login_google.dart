// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// import 'package:pits_app/src/models/customer_model.dart';
// import 'package:pits_app/src/services/login_service.dart';
// import 'package:pits_app/src/shared/custom_snackbar.dart';
// import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';

// class ButtonLoginGoogle extends StatelessWidget {
  
//   ButtonLoginGoogle({super.key});
//   final pref = PreferenciasUsuario();
  

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final prefs = PreferenciasUsuario();
//     final loginService = LoginService();

//     return ElevatedButton(
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all(
//           const Color.fromRGBO(219, 68, 55, 1),
//         ),
//         padding: MaterialStateProperty.all(
//           const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
//         ),
//       ),
//       onPressed: () async {
//         try {

//           final GoogleSignIn googleSignIn = GoogleSignIn(
//             clientId: "",
//             serverClientId: "",
//           );


//           final user = await googleSignIn.signIn();

//           // 👇 Si el usuario canceló el login de Google
//           if (user == null) {
//             mostrarSnackbar(
//               'Inicio de sesión cancelado',
//               Colors.orangeAccent,
//               context,
//             );
//             return;
//           }

//           final loginGoogle = await loginService.loginGoogle(user);

//           if (loginGoogle.id != null) {
//             prefs.customerInfo = customerModelToJson(loginGoogle);

//             final parameters = await loginService.getParameters();
//             prefs.whatsapp = parameters.whatsapp;

//             prefs.googleSign = true;

//             if (!context.mounted) return;
//             Navigator.pushNamedAndRemoveUntil(
//               context,
//               'home',
//               (route) => false,
//             );
//           } else {
//             mostrarSnackbar(
//               'Error al iniciar sesión con Google',
//               Colors.redAccent,
//               context,
//             );
//           }
//         } catch (e) {
//           mostrarSnackbar(
//             'Error al iniciar sesión con Google',
//             Colors.redAccent,
//             context,
//           );
//         }
//       },
//       child: IntrinsicHeight(
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(width: screenSize.width * 0.1),
//             Icon(
//               FontAwesomeIcons.google,
//               size: screenSize.height * 0.025,
//               color: Colors.white,
//             ),
//             const VerticalDivider(
//               thickness: 0.5,
//               width: 20,
//               color: Colors.white,
//             ),
//             SizedBox(width: screenSize.width * 0.1),
//             RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: "Ingresar con ",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w300,
//                       color: Colors.white,
//                       fontSize: screenSize.height * 0.02,
//                       fontFamily: 'Helvetica',
//                     ),
//                   ),
//                   TextSpan(
//                     text: "Google",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontSize: screenSize.height * 0.022,
//                       fontFamily: 'Helvetica',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
// }
