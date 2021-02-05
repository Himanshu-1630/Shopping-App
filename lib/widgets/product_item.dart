import '../screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  ProductItem({
    this.title,
    this.imageUrl,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          );
        },
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        leading: IconButton(
          icon:
              Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
          color: Theme.of(context).accentColor,
          onPressed: () {
            product.toggleFavoriteStatus();
          },
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          color: Theme.of(context).accentColor,
          onPressed: () {
            cart.addItem(product.id, product.price, product.title);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Added to the cart 😍'),
              action: SnackBarAction(label: 'Undo', onPressed: (){
                cart.removeSingleItem(product.id);
              }),
              duration: Duration(seconds: 2),
            ));
          },
        ),
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.black87,
      ),
    );
  }
}
