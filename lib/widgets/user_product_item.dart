
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  UserProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          ListTile(
              title: Text(product.title),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(product.imageUrl),
              ),
              trailing: Container(
                width: MediaQuery.of(context).size.width*0.25,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: product.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<ProductsProvider>(context, listen: false).deleteProduct(product.id);
                      },
                    )
                  ],
                ),
              ),
          ),
          Divider(thickness: 1,)
        ],
      ),
    );
  }
}
