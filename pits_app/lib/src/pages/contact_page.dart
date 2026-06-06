import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/parameters_model.dart';
import 'package:pits_app/src/services/login_service.dart';
import 'package:pits_app/src/shared/custom_loading.dart';
import 'package:pits_app/src/shared/custom_social_media_button.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final prefs = PreferenciasUsuario();
  final loginService = LoginService();
  bool loading = false;
  ParametersModel? parameters;

  @override
  void initState() {
    super.initState();
    loadParameters();
  }

  Future<void> loadParameters() async {
    setState(() => loading = true);
    parameters = await loginService.getParameters();
    setState(() => loading = false);
  }

  Future<void> openUrl(String? app, String? web) async {
    if (app == null) return;
    final appUri = Uri.parse(app);
    final webUri = Uri.parse(web ?? app);
    try {
      if (!await launchUrl(appUri, mode: LaunchMode.externalApplication)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Ayuda en Línea")),
      backgroundColor: config.primary,
      body: SizedBox(
        height: screenSize.height - kToolbarHeight - MediaQuery.of(context).padding.top,
        width: screenSize.width,
        child: Center(
          child: loading || parameters == null
              ? CustomLoading()
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSocialMediaButton(
                        icon: FontAwesomeIcons.instagram,
                        color: Color(0XFFE1306C),
                        nameSocialMedia: 'Instagram',
                        onTap: () => openUrl(
                          parameters!.instagram,
                          parameters!.instagramUrl,
                        ),
                      ),
                      CustomSocialMediaButton(
                        icon: FontAwesomeIcons.facebookF,
                        color: Color.fromRGBO(59, 89, 152, 1),
                        nameSocialMedia: 'Facebook',
                        onTap: () => openUrl(
                          parameters!.facebook,
                          parameters!.facebookUrl,
                        ),
                      ),
                      CustomSocialMediaButton(
                        icon: FontAwesomeIcons.whatsapp,
                        color: Color(0XFF25D366),
                        nameSocialMedia: 'Whatsapp',
                        onTap: () => openUrl(parameters!.whatsapp, null),
                      ),
                      CustomSocialMediaButton(
                        icon: FontAwesomeIcons.headphones,
                        color: config.accent,
                        nameSocialMedia: 'Registrar Mi Negocio',
                        onTap: () => openUrl(prefs.whatsapp, null),
                      ),
                      CustomSocialMediaButton(
                        icon: FontAwesomeIcons.envelope,
                        color: config.accent,
                        nameSocialMedia: 'E-mail',
                        onTap: () => openUrl(
                            'mailto:${parameters!.contactEmail}', null),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}