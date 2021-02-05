import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import '../providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

class ProductDetailScreen extends StatelessWidget {
// final String title;
// ProductDetailScreen(this.title);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<ProductsProvider>(context).findById(productId);
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedProduct.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          Badge(
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  CartScreen.routeName,
                );
              },
              tooltip: 'View Cart',
            ),
            value: cart.itemCount.toString(),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 0),
              child: Text(
                'Details',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Divider(
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      loadedProduct.description,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Cost: ' + '₹' + '${loadedProduct.price}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Divider(
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.9,
              child: OutlineButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                child: Text(
                  'Add To Cart',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                highlightColor: Colors.grey[50],
                highlightElevation: 2,
                //color: Colors.grey[100],
                onPressed: () {
                  cart.addItem(loadedProduct.id, loadedProduct.price,
                      loadedProduct.title);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
