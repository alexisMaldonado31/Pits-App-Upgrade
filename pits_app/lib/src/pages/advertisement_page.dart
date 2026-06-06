import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/advertisement_model.dart';
import 'package:pits_app/src/services/advertisement_service.dart';
import 'package:pits_app/src/shared/advertisement.dart';
import 'package:pits_app/src/shared/custom_title.dart';

class AdvertisementPage extends StatefulWidget {
  const AdvertisementPage({super.key});

  @override
  State<AdvertisementPage> createState() => _AdvertisementPageState();
}

class _AdvertisementPageState extends State<AdvertisementPage> {
  final advertisementService = AdvertisementService();
  List<AdvertisementModel> advertisements = [];

  Future<void> getAdvertisements() async {
    final result = await advertisementService.getAdvertisements();
    setState(() => advertisements = result);
  }

  @override
  void initState() {
    super.initState();
    getAdvertisements();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/background.png"),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            config.secondary.withOpacity(0.95),
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
          CustomTitle(text: "Promociones"),
          Expanded(
            child: RefreshIndicator(
              onRefresh: getAdvertisements,
              child: advertisements.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: screenSize.height * 0.2),
                        Center(
                          child: Text(
                            'No hay promociones disponibles',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: advertisements.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          Advertisement(advertisements[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}