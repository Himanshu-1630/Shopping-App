import 'package:My_shopping_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_summary.dart';
import '../providers/orders.dart';
import '../screens/orders_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:18),
            child: Text('Your Orders', style: TextStyle(fontSize: 12),),
          ),
          IconButton(
            icon: Icon(Icons.payment),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
            tooltip: 'View Orders',
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                ' Total Items',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Chip(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  label: FittedBox(
                                      child: Text(
                                    '${cart.totalQuantity}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  )),
                                )),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Chip(
                                backgroundColor: Theme.of(context).primaryColor,
                                label: FittedBox(
                                  child: Text(
                                    '₹ ' + cart.amount.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(), color: Theme.of(context).primaryColor),
              child: Text(
                'Cart Items',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Divider(
            color: Colors.black,
            thickness: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1,
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 2),
            height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartSummary(
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
              ),
              itemCount: cart.items.length,
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 1,
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.9,
            child: OutlineButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: Text(
                'Place Order',
                style: TextStyle(fontSize: 18),
              ),
              highlightColor: Colors.grey[50],
              highlightElevation: 2,
              //color: Colors.grey[100],
              onPressed: () {
                Provider.of<Order>(context, listen: false).addOrder(
                  cart.items.values.toList(),
                  cart.amount,
                );
                cart.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
