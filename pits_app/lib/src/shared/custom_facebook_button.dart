// import 'package:dp_motors/src/models/customer_model.dart';
// import 'package:dp_motors/src/services/login_service.dart';
// import 'package:dp_motors/src/shared/custom_snackbar.dart';
// import 'package:dp_motors/src/shared_prefs/preferencias_usuario.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class CustomFacebookButton extends StatelessWidget {
//   const CustomFacebookButton({Key key}) : super(key: key);

//   Color getBackgroundColor(Set<MaterialState> states) {
//     const Set<MaterialState> interactiveStates = <MaterialState>{
//       MaterialState.disabled,
//     };
//     if (states.any(interactiveStates.contains)) {
//       return Color.fromRGBO(59, 89, 152, 1);
//     }
//     return Color.fromRGBO(59, 89, 152, 1);
//   }

//   EdgeInsetsGeometry getPadding(Set<MaterialState> states) {
//     return EdgeInsets.symmetric(horizontal: 5, vertical: 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final prefs = PreferenciasUsuario();
//     final loginService = new LoginService();

//     return ElevatedButton(
//       style: ButtonStyle(
//         backgroundColor: MaterialStateColor.resolveWith(getBackgroundColor),
//         padding: MaterialStateProperty.resolveWith(getPadding),
//       ),
//       onPressed: () async {
//         try {
//           // by default the login method has the next permissions ['email','public_profile']
//           await FacebookAuth.instance.login();
//           final userData = await FacebookAuth.instance.getUserData();

//           var loginFacebook = await loginService.loginFacebook(userData);

//           if (loginFacebook != null) {
//             prefs.customerInfo = customerModelToJson(loginFacebook);
//             var parameters = await loginService.getParameters();
//             prefs.whatsapp = parameters.whatsapp;
//             prefs.facebookSign = true;
//             Navigator.pushNamedAndRemoveUntil(
//               context,
//               'home',
//               (route) => false,
//             );
//           } else {
//             mostrarSnackbar('Error al iniciar sesión con Facebook',
//                 Colors.redAccent, context);
//           }
//         } on FacebookAuthException catch (e) {
//           switch (e.errorCode) {
//             case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
//               print("You have a previous login operation in progress");
//               break;
//             case FacebookAuthErrorCode.CANCELLED:
//               print("login cancelled");
//               break;
//             case FacebookAuthErrorCode.FAILED:
//               print("login failed");
//               break;
//           }
//         }
//       },
//       child: IntrinsicHeight(
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(width: screenSize.width * 0.1),
//             SizedBox(
//                 child: Icon(
//               FontAwesomeIcons.facebookF,
//               size: screenSize.height * 0.025,
//             )),
//             VerticalDivider(
//               thickness: 0.5,
//               width: 20,
//               color: Colors.white,
//               indent: 0,
//               endIndent: 0,
//             ),
//             SizedBox(width: screenSize.width * 0.1),
//             RichText(
//                 text: TextSpan(children: [
//               TextSpan(
//                 text: "Ingresar con ",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w300,
//                   color: Colors.white,
//                   fontSize: screenSize.height * 0.02,
//                   fontFamily: 'Helvetica',
//                 ),
//               ),
//               TextSpan(
//                 text: "Facebook",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   fontSize: screenSize.height * 0.022,
//                   fontFamily: 'Helvetica',
//                 ),
//               ),
//             ])),
//             Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
// }
