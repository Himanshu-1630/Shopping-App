import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import '../providers/orders.dart' show Order; //** */
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName='/order-screen';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    final length= orderData.orders.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
      ),
      drawer: AppDrawer(),
      body: length>0? ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
        itemCount: orderData.orders.length,
      ) : Center(child: Text('No order has been placed yet 😥', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
    );
  }
}
