import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import '../providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';

  Future<void> _refreshProducts(BuildContext context) async{
          await Provider.of<ProductsProvider>(context).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[IconButton(icon: Icon(Icons.add), onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: null);
        })],
      ),
      drawer: AppDrawer(),
      body:RefreshIndicator(
        onRefresh: ()=> _refreshProducts(context) ,
              child: ListView.builder(
            itemBuilder: (ctx, i) => UserProductItem(products.items[i]),
            itemCount: products.items.length,
          ),
      ),
    );
  }
}
