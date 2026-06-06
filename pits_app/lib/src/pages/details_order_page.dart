import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/order_model.dart';
import 'package:pits_app/src/shared/custom_richtext.dart';
import 'package:pits_app/src/shared/custom_text.dart';

class DetailsOrderPage extends StatelessWidget {
  final List<Product> products;
  const DetailsOrderPage({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Detalles Órden")),
      backgroundColor: config.primary,
      body: Container(
        height: screenSize.height - kToolbarHeight - MediaQuery.of(context).padding.top,
        width: screenSize.width,
        padding: EdgeInsets.all(screenSize.width * 0.05),
        child: ListView.builder(
          itemCount: products.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: product.name ?? '',
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.bold,
                              colorText: Colors.white,
                            ),
                            CustomRichText(
                              title: 'Cantidad',
                              content: product.quantity?.toString() ?? '0',
                              colorContent: Colors.white,
                              fontSize: screenSize.width * 0.035,
                              colorTitle: Colors.white,
                            ),
                            if (product.productServiceType == "SERVICIO" &&
                                product.scheduleDate != null)
                              CustomRichText(
                                title: 'Fecha',
                                content: product.scheduleDate!
                                    .toIso8601String()
                                    .substring(0, 10),
                                colorContent: Colors.white,
                                fontSize: screenSize.width * 0.035,
                                colorTitle: Colors.white,
                              ),
                            if (product.productServiceType == "SERVICIO" &&
                                product.scheduleHour != null)
                              CustomRichText(
                                title: 'Horario',
                                content: product.scheduleHour!,
                                colorContent: Colors.white,
                                fontSize: screenSize.width * 0.035,
                                colorTitle: Colors.white,
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          text: product.rowPrice ?? '',
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.bold,
                          colorText: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}