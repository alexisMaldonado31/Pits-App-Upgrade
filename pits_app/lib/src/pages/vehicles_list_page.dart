import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/vehicle_model.dart';
import 'package:pits_app/src/pages/vehicle_page.dart';
import 'package:pits_app/src/services/vehicle_service.dart';
import 'package:pits_app/src/shared/custom_button.dart';
import 'package:pits_app/src/shared/custom_title.dart';
import 'package:pits_app/src/shared/vehicle.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class VehiclesListPage extends StatefulWidget {
  const VehiclesListPage({super.key});

  @override
  State<VehiclesListPage> createState() => _VehiclesListPageState();
}

class _VehiclesListPageState extends State<VehiclesListPage> {
  final vehiclesService = VehiclesService();
  List<VehicleModel> vehicles = [];

  Future<void> cargarVehiculos() async {
    final result = await vehiclesService.getMyVehicles();
    setState(() => vehicles = result);
  }

  @override
  void initState() {
    super.initState();
    cargarVehiculos();
  }

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
          CustomTitle(text: "Mis Autos"),
          CustomButton(
            color: config.accent,
            colorText: config.primary,
            text: "Añadir Auto",
            fontSize: screenSize.width * 0.04,
            height: screenSize.height * 0.05,
            onTap: () async {
              final res = await pushScreen(
                context,
                screen: VehiclePage(vehicleModel: VehicleModel()),
                withNavBar: false, // 👈
              );
              if (res == true) cargarVehiculos();
            },
          ),
          SizedBox(height: screenSize.height * 0.025),
          Expanded(
            child: RefreshIndicator(
              onRefresh: cargarVehiculos,
              child: vehicles.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: screenSize.height * 0.2),
                        Center(
                          child: Text(
                            'No tienes autos registrados',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: vehicles.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => Vehicle(
                        vehicles[index],
                        onTap: () async {
                          final res = await pushScreen(
                            context,
                            screen: VehiclePage(vehicleModel: vehicles[index]),
                            withNavBar: false, // 👈
                          );
                          if (res == true) cargarVehiculos();
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}