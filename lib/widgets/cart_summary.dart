import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartSummary extends StatelessWidget {
  final String title;
  final double price;
  final int quantity;
  final String id;
  final String productId;

  CartSummary(this.price, this.quantity, this.title, this.id, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
          color: Theme.of(context).accentColor,
          child: Icon(
            Icons.delete,
            color: Theme.of(context).primaryColor,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.all(5)),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure ?'),
            content: Text('Do you want to permanently delete this item ?'),
            actions: <Widget>[
              FlatButton(
                 child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                 child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        child: Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: ListTile(
              contentPadding: EdgeInsets.only(right: 25, left: 15),
              leading: CircleAvatar(
                radius: 25,
                child: Padding(
                  padding: EdgeInsets.all(3),
                  child: FittedBox(
                      child: Text(
                    '₹ ' + '$price',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              title: Text(title),
              subtitle: Text('Quantity: ' + '$quantity'),
              trailing: Text(
                '₹ ' + (quantity * price).toStringAsFixed(2),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
