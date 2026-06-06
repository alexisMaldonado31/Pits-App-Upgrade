import 'dart:convert';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/categories_model.dart';
import 'package:pits_app/src/models/customer_model.dart';
import 'package:pits_app/src/models/establishments_model.dart';
import 'package:pits_app/src/services/categories_service.dart';
import 'package:pits_app/src/shared/custom_info_map.dart';
import 'package:pits_app/src/shared/custom_text.dart';
import 'package:pits_app/src/shared/custom_text_button.dart';
import 'package:pits_app/src/shared/custom_title.dart';
import 'package:pits_app/src/shared/establishment.dart';
import 'package:pits_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:pits_app/src/utils/distancia_lat_long.dart' as distanceLatLng;
import 'package:pits_app/src/pages/profile_page.dart';

class EstablishmentsByCategoriePage extends StatefulWidget {
  final CategoriesModel? categorie;
  final String? search;

  const EstablishmentsByCategoriePage({
    super.key,
    this.categorie,
    this.search,
  });

  @override
  State<EstablishmentsByCategoriePage> createState() =>
      _EstablishmentsByCategoriePageState();
}

class _EstablishmentsByCategoriePageState
    extends State<EstablishmentsByCategoriePage> {
  final categoriesServices = CategoriesService();
  final prefs = PreferenciasUsuario();

  bool iconStatus = false;
  bool cargando = false;

  List<EstablishmentsModel> establishments = [];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition? _initialPosition;
  Position? position;

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  void _onMapCreated(GoogleMapController controller) {
    _customInfoWindowController.googleMapController = controller;
  }

  Future<void> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _initialPosition = CameraPosition(
        target: LatLng(position!.latitude, position!.longitude),
        zoom: 12,
      );
    });
  }

  Future<void> cargarEstablecimientos() async {
    final customerInfo =
        CustomerModel.fromJson(json.decode(prefs.customerInfo));
    setState(() => cargando = true);

    await _getCurrentPosition();

    if (position == null) {
      setState(() => cargando = false);
      return;
    }

    List<EstablishmentsModel> auxEstablishments;

    if (widget.categorie == null) {
      auxEstablishments = await categoriesServices
          .getEstablishmentsBySearch(widget.search ?? '');
    } else {
      auxEstablishments = await categoriesServices
          .getEstablishmentsByCategory(widget.categorie!.id!);
    }

    final kmRadio =
        double.tryParse(customerInfo.kilometersRadio ?? '30') ?? 30;
    establishments = auxEstablishments.where((e) {
      final dist = double.tryParse(distanceLatLng.distanciaKm(
                double.parse(e.latitude ?? '0'),
                double.parse(e.longitude ?? '0'),
                position!.latitude,
                position!.longitude,
              )) ??
          999;
      return dist <= kmRadio;
    }).toList();

    double getDistance(EstablishmentsModel e) =>
        double.tryParse(distanceLatLng.distanciaKm(
              double.parse(e.latitude ?? '0'),
              double.parse(e.longitude ?? '0'),
              position!.latitude,
              position!.longitude,
            )) ??
        999;

    final gold =
        establishments.where((e) => e.subscriptionName == 'GOLD').toList()
          ..sort((a, b) => getDistance(a).compareTo(getDistance(b)));
    final nonGold =
        establishments.where((e) => e.subscriptionName != 'GOLD').toList()
          ..sort((a, b) => getDistance(a).compareTo(getDistance(b)));

    establishments = [...gold, ...nonGold];

    markers.clear();
    for (var item in establishments) {
      final latlng = LatLng(
        double.parse(item.latitude ?? '0'),
        double.parse(item.longitude ?? '0'),
      );
      final markerId = MarkerId(item.id.toString());
      markers[markerId] = Marker(
        markerId: markerId,
        position: latlng,
        onTap: () {
          _customInfoWindowController.addInfoWindow?.call(
            CustomInfoWindowMap(
              item,
              latLng: LatLng(position!.latitude, position!.longitude),
            ),
            latlng,
          );
        },
      );
    }

    setState(() => cargando = false);
  }

  @override
  void initState() {
    super.initState();
    cargarEstablecimientos();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categorie == null
              ? (widget.search ?? '').toUpperCase()
              : widget.categorie!.name ?? '',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenSize.height * 0.026,
            fontWeight: FontWeight.bold,
            fontFamily: 'Helvetica',
          ),
        ),
      ),
      backgroundColor: config.primary,
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: config.secondary,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: config.secondary,
                      elevation: 0,
                    ),
                    onPressed: () {
                      _customInfoWindowController.hideInfoWindow?.call();
                      setState(() => iconStatus = !iconStatus);
                    },
                    icon: Icon(
                      iconStatus ? Icons.list : Icons.map_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Clic aquí para ver ${iconStatus ? 'Lista' : 'Mapa'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      iconStatus
                          ? _mapaServicios(screenSize)
                          : _listaServicios(screenSize, config),
                      CustomInfoWindow(
                        controller: _customInfoWindowController,
                        height: screenSize.height * 0.3, // 👈 antes era 0.3
                        width: screenSize.width * 0.4,   // 👈 antes era 0.4
                        offset: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _listaServicios(Size screenSize, AppConfig config) {
    return Container(
      width: screenSize.width,
      padding: EdgeInsets.all(screenSize.width * 0.05),
      child: Column(
        children: [
          CustomTitle(text: 'Lista de Establecimientos'),
          Expanded(
            child: establishments.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: cargarEstablecimientos,
                    child: ListView.builder(
                      itemCount: establishments.length,
                      itemBuilder: (context, index) => Establishment(
                        establishment: establishments[index],
                        latLng:
                            LatLng(position!.latitude, position!.longitude),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text:
                            'No se han encontrado establecimientos en tu zona de cobertura.',
                        colorText: Colors.white,
                        fontSize: screenSize.width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      CustomText(
                        text:
                            'Puedes cambiar esta configuración desde Mi Perfil.',
                        colorText: Colors.white,
                        fontSize: screenSize.width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomTextButton(
                        text: "Ir a Mi Perfil",
                        textColor: config.accent,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProfilePage()),
                          );
                          await cargarEstablecimientos();
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _mapaServicios(Size screenSize) {
    if (_initialPosition == null) {
      return Center(
        child: CustomText(
          text: 'No se pudo obtener la ubicación',
          colorText: Colors.white,
          fontSize: 16,
        ),
      );
    }

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialPosition!,
      onMapCreated: _onMapCreated,
      compassEnabled: true,
      myLocationEnabled: true,
      markers: Set<Marker>.of(markers.values),
      onTap: (_) => _customInfoWindowController.hideInfoWindow?.call(),
      onCameraMove: (_) => _customInfoWindowController.onCameraMove?.call(),
      mapToolbarEnabled: false,
    );
  }
}