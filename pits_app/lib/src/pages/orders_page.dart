import 'package:flutter/material.dart';
import 'package:pits_app/app_config.dart';
import 'package:pits_app/src/models/order_model.dart';
import 'package:pits_app/src/services/order_service.dart';
import 'package:pits_app/src/shared/custom_order.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ordersService = OrderService();
  List<OrderModel> orders = [];

  Future<void> loadOrders() async {
    final result = await ordersService.getOrders();
    setState(() => orders = result);
  }

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Mis Órdenes")),
      backgroundColor: config.primary,
      body: SizedBox(
        height: screenSize.height - kToolbarHeight - MediaQuery.of(context).padding.top,
        width: screenSize.width,
        child: RefreshIndicator(
          onRefresh: loadOrders,
          child: orders.isEmpty
              ? ListView(
                  children: [
                    SizedBox(height: screenSize.height * 0.3),
                    Center(
                      child: Text(
                        'No tienes órdenes aún',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: orders.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => CustomOrder(
                    orderModel: orders[index],
                    onReview: (value) {
                      if (value) loadOrders();
                    },
                  ),
                ),
        ),
      ),
    );
  }
}