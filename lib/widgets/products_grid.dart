import '../providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  
  final bool showFavs;
  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    final screenlabel= showFavs? Text('My Favorites'): Text('Available Products') ;
    return Scaffold(
      appBar: AppBar( 
        title:  screenlabel,
      ),
          body: GridView.builder(
        itemCount: products.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(//mainly used when listview or grid vie is used
          value: products[i],
          child: ProductItem(
              // id: products[i].id,
              // imageUrl: products[i].imageUrl,
              // title: products[i].title,
              ),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
