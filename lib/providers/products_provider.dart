import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description:
    //       'Cook whatever you want. Nonsticky cookpan, easy to use and easy to wash.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Bluetooth Speaker',
    //   description:
    //       'Makes your house a home theatre. Music lovers just go for it.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://www.jbl.com/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog_Harman/default/dw05dbceeb/Extreme2_Hero_Black-1605x1605px.jpg?sw=626&sh=626&sm=fit&sfrm=png',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Wings Powerpods',
    //   description:
    //       'Made of high quality plastic that gives it a classic look. Sweat resistant and wireless bluetooth supported. Dont waste your time just go for it.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://cdn.shopify.com/s/files/1/1463/4916/products/wings-powerpods-latest-2019-touch-sensor-control-true-wireless-bluetooth-earbuds-earphones-headphones-with-digital-display-charging-case-and-power-bank-function-ce-wings_480x480.jpg?v=1569961723',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Iphone SE',
    //   description:
    //       'Small and powerful, best for daily use. It has a high speed processor which is second to none',
    //   price: 49.99,
    //   imageUrl:
    //       'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-se-family-select-2020?wid=882&amp;hei=1058&amp;fmt=jpeg&amp;qlt=80&amp;op_usm=0.5,0.5&amp;.v=1586794486444',
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'Titan Watch',
    //   description:
    //       'High quality watch with one year warrenty. Put it on and become smarty.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://img.tatacliq.com/images/i2/437Wx649H/MP000000002630624_437Wx649H_20180331033446.jpeg',
    // ),
    // Product(
    //   id: 'p9',
    //   title: 'A Cap',
    //   description: 'Made of durable material. Makes you cool and stylish.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://underarmour.scene7.com/is/image/Underarmour/1305036-001_SLF_SL?scl=1&fmt=jpg&qlt=80&wid=1400&hei=1599&size=1260,1439&cache=on,off&bgc=f0f0f0&resMode=sharp2',
    // ),
    // Product(
    //   id: 'p10',
    //   title: 'Bed Sheet',
    //   description:
    //       'Keeps your bed clean, made of high quality cotton. Just go for it !!',
    //   price: 79.99,
    //   imageUrl:
    //       'https://4.imimg.com/data4/GO/KX/ANDROID-14237325/product-500x500.jpeg',
    // ),
    // Product(
    //   id: 'p11',
    //   title: 'Pedegree Pro 15kg',
    //   description:
    //       'High protein diet for your lovely dog, buy it and make him happy and healthy 😍',
    //   price: 149.99,
    //   imageUrl: 'https://www.amazon.in/images/I/71H0t7sA7XL._SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p12',
    //   title: 'Leather Jacket',
    //   description:
    //       'Made of high quality leather, put it on and become stylish 😎',
    //   price: 249.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/81PRsfQGSRL._UL1500_.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://myapp16-b5f93.firebaseio.com/products_provider.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            price: prodData['price'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _items= loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://myapp16-b5f93.firebaseio.com/products_provider.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
          description: product.description,
          id: json.decode(response.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title);
      _items.insert(0, newProduct);
      //print(json.decode(response.body)['name']);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == newProduct.id);
    if (prodIndex >= 0) {
      final url = 'https://myapp16-b5f93.firebaseio.com/products_provider/${newProduct.id}.json';
      await http.patch(url, body: json.encode({
        'title': newProduct.title,
        'description' : newProduct.description,
        'imageUrl' : newProduct.imageUrl,
        'price' : newProduct.price,

      }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
