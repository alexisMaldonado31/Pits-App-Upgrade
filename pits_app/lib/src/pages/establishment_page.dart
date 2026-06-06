import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/bloc/db_provider.dart';
import 'package:pits_app/src/bloc/item_carrito_bloc.dart';
import 'package:pits_app/src/models/establishments_model.dart';
import 'package:pits_app/src/models/productos_model.dart';
import 'package:pits_app/src/models/vehicle_model.dart';
import 'package:pits_app/src/pages/reviews_page.dart';
import 'package:pits_app/src/services/products_service.dart';
import 'package:pits_app/src/services/vehicle_service.dart';
import 'package:pits_app/src/shared/bottom_sheet_carrito.dart';
import 'package:pits_app/src/shared/carrito.dart';
import 'package:pits_app/src/shared/custom_richtext.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:pits_app/src/shared/custom_title.dart';
import 'package:pits_app/src/shared/products.dart';
import 'package:url_launcher/url_launcher.dart';

class EstablishmentPage extends StatefulWidget {
  final EstablishmentsModel establishment;

  const EstablishmentPage({super.key, required this.establishment});

  @override
  State<EstablishmentPage> createState() => _EstablishmentPageState();
}

class _EstablishmentPageState extends State<EstablishmentPage> {
  final productsService = ProductsService();
  final vehicleService = VehiclesService();
  final itemsCarritoBloc = ItemsCarritoBloc();

  bool loading = false;
  List<ProductsModel> products = [];
  List<VehicleModel> vehicles = [];

  Future<void> loadProducts() async {
    setState(() => loading = true);
    products = await productsService
        .getProductsByEstablishment(widget.establishment.id!);
    setState(() => loading = false);
  }

  Future<void> loadVehicles() async {
    vehicles = await vehicleService.getMyVehicles();
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadVehicles();
  }

  Future<void> _openUrl(String? url, String? fallback) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (fallback != null) {
        await launchUrl(Uri.parse(fallback),
            mode: LaunchMode.externalApplication);
      }
    }
  }

  Widget _bottomSheetCarrito() {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () async {
        final res = await showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(20),
          ),
          isScrollControlled: true,
          builder: (_) => SizedBox(
            height: screenSize.height * 0.65,
            child: BottomSheetCarrito(
                config.primary, widget.establishment.id!),
          ),
        );

        if (res != null) {
          await itemsCarritoBloc.borrarAllItemsCarrito();
          Navigator.pop(context);
        }
      },
      child: Carrito(colorCarrito: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;
    final est = widget.establishment;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                est.name ?? '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.height * 0.026,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (est.subscriptionName == 'GOLD') ...[
              SizedBox(width: 8),
              Icon(FontAwesomeIcons.medal, color: Colors.amberAccent),
            ],
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            final total = await DBProvider.db.getCountItemsCarrito();
            if (total > 0) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
                  title: Text("¿Desea abandonar el carrito de compras?"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await itemsCarritoBloc.borrarAllItemsCarrito();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('Abandonar Carrito',
                          style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar',
                          style: TextStyle(color: config.accent)),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [_bottomSheetCarrito()],
      ),
      backgroundColor: config.primary,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadProducts,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: est.logo ?? '',
                      placeholder: (_, __) => LinearProgressIndicator(),
                      height: screenSize.height * 0.2,
                      width: screenSize.width,
                      errorWidget: (_, __, ___) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05,
                        vertical: screenSize.height * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (est.subscriptionName == 'GOLD')
                            CustomText(
                              text:
                                  "Este establecimiento es GOLD certificado por Pits",
                              colorText: Colors.amberAccent,
                              textAlign: TextAlign.center,
                              fontSize: screenSize.width * 0.04,
                            ),
                          SizedBox(height: 5),
                          // Redes sociales
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (est.facebook != null)
                                _socialIcon(FontAwesomeIcons.facebookF,
                                    'https://www.facebook.com/${est.facebook}'),
                              if (est.instagram != null)
                                _socialIcon(FontAwesomeIcons.instagram,
                                    'https://www.instagram.com/${est.instagram}'),
                              if (est.tiktok != null)
                                _socialIcon(FontAwesomeIcons.tiktok,
                                    'https://www.tiktok.com/${est.tiktok}'),
                              if (est.youtube != null)
                                _socialIcon(FontAwesomeIcons.youtube,
                                    'https://www.youtube.com/${est.youtube}'),
                            ],
                          ),
                          CustomTitle(text: 'Información'),
                          CustomRichText(
                            title: 'Descripción',
                            content: est.description ?? '',
                            colorContent: Colors.white,
                            colorTitle: config.accent,
                            fontSize: screenSize.width * 0.045,
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          CustomRichText(
                            title: 'Dirección',
                            content: est.address ?? '',
                            colorContent: Colors.white,
                            colorTitle: config.accent,
                            fontSize: screenSize.width * 0.045,
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          CustomRichText(
                            title: 'Teléfono',
                            content: est.mobile ?? '',
                            colorContent: Colors.white,
                            colorTitle: config.accent,
                            fontSize: screenSize.width * 0.045,
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          CustomRichText(
                            title: 'Email',
                            content: est.email ?? '',
                            colorContent: Colors.white,
                            colorTitle: config.accent,
                            fontSize: screenSize.width * 0.045,
                          ),
                          if (est.webPage != null) ...[
                            SizedBox(height: screenSize.height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      _openUrl(est.webPage, null),
                                  child: Text(
                                    est.textWebPage ?? 'Ver sitio web',
                                    style: TextStyle(
                                      color: config.accent,
                                      fontSize: screenSize.height * 0.025,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                FaIcon(FontAwesomeIcons.arrowUpRightFromSquare,
                                    color: config.accent,
                                    size: screenSize.height * 0.023),
                              ],
                            ),
                          ],
                          SizedBox(height: screenSize.height * 0.03),
                          CustomTitle(text: 'Servicios'),
                          ...est.categories
                                  ?.map((e) =>
                                      _servicio(e.name ?? '', screenSize))
                                  .toList() ??
                              [],
                          SizedBox(height: screenSize.height * 0.03),
                          CustomTitle(text: 'Reviews'),
                          Center(
                            child: RatingBar.builder(
                              initialRating: (est.stars ?? 0).toDouble(),
                              minRating: 1,
                              itemCount: 5,
                              allowHalfRating: true,
                              itemSize: screenSize.width * 0.05,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) =>
                                  Icon(Icons.star, color: Colors.amber),
                              onRatingUpdate: (_) {},
                              ignoreGestures: true,
                              unratedColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.03),
                          CustomTitle(text: 'Productos'),
                          if (loading)
                            Center(child: CircularProgressIndicator())
                          else if (products.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.05),
                              child: Center(
                                child: Text(
                                  'No existen Productos o Servicios',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize.width * 0.05,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else
                            Wrap(
                              runSpacing: 5,
                              spacing: 20,
                              children: products
                                  .map((e) => Products(
                                        product: e,
                                        vehicles: vehicles,
                                      ))
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Barra inferior
          SafeArea(
            bottom: true,
            top: false,
            child: Container(
              color: config.accent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse('tel://${est.mobile}'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    icon: Icon(Icons.phone),
                    color: Colors.black,
                    iconSize: screenSize.height * 0.05,
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ReviewPage(establishment: est),
                      ),
                    ),
                    icon: Icon(Icons.star),
                    color: Colors.black,
                    iconSize: screenSize.height * 0.05,
                  ),
                  IconButton(
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=${est.latitude},${est.longitude}'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    icon: Icon(Icons.pin_drop),
                    color: Colors.black,
                    iconSize: screenSize.height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _servicio(String name, Size screenSize) {
    return Row(
      children: [
        Icon(Icons.circle, size: screenSize.width * 0.02, color: Colors.white),
        SizedBox(width: screenSize.width * 0.02),
        CustomText(
          text: name,
          colorText: Colors.white,
          textAlign: TextAlign.center,
          fontSize: screenSize.width * 0.045,
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return IconButton(
      onPressed: () => _openUrl(url, url),
      icon: Icon(icon, color: Colors.white),
    );
  }
}