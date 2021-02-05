import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final double price;
  final String title;
  final int quantity;

  CartItem({
    @required this.title,
    @required this.id,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int totalQuantity = 0;
  int get itemCount {
    totalQuantity = 0;
    _items.forEach((key, item) {
      totalQuantity += item.quantity;
    });
    return totalQuantity;
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  double totalAmount = 0.0;
  double get amount {
    totalAmount = 0.0;
    _items.forEach((key, item) {
      totalAmount += item.price * item.quantity;
    });
    return totalAmount;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              title: existingCartItem.title,
              id: existingCartItem.id,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            title: title,
            id: DateTime.now().toString(),
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          title: existingItem.title,
          id: existingItem.id,
          price: existingItem.price,
          quantity: existingItem.quantity - 1,
        ),
      );
      }
      else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }
