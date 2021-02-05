import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    description: '',
    title: '',
    id: null,
    price: 0.0,
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': 0.0,
    'imageUrl': '',
    'id': null,
  };
  var _isLoading = false;

  var _isint = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isint) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        final product =
            Provider.of<ProductsProvider>(context).findById(productId);
        _editedProduct = product;
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price,
          //'imageUrl' : _editedProduct.imageUrl,
          'id': _editedProduct.id,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isint = false;

    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id == null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured !'),
            content: Text('Something went wrong !!'),
            actions: <Widget>[
              FlatButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('OK',),)
            ], 
          ),

        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
      //print('hi');
      //Navigator.of(context).pop();
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct).then((_) {
            setState(() {
        _isLoading = false;
        Navigator.of(context).pop();
      });
          });
    }
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((_imageUrlController.text.isEmpty) ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('png') &&
              !_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('jpeg')) ||
          _imageUrlController.text.contains(' ')) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose(); //clearing focus node to avoid memory leak
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                          errorStyle: TextStyle(fontSize: 13),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(
                              _priceFocusNode); //not interested in 'value'
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: value,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            id: _editedProduct.id,
                            description: _editedProduct.description,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '*Required parameter';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'].toString(),
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value),
                            id: _editedProduct.id,
                            description: _editedProduct.description,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '*Required parameter';
                          }
                          if (double.tryParse(value) == null) {
                            return '*Enter a valid price.';
                          }
                          if (double.parse(value) <= 0) {
                            return '*Price must be greater than zero.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            id: _editedProduct.id,
                            description: value,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '*Required parameter';
                          }
                          if (value.length < 20) {
                            return '*Description must be at least 20 characters long.';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.1,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Enter Image Url..',
                                      textAlign: TextAlign.center,
                                    ))
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image Url',
                                helperText:
                                    '*Support URL that ends with \'.jpg\', \'.png\', \'.jpeg\' only.',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (value) {
                                _editedProduct = Product(
                                  title: _editedProduct.title,
                                  imageUrl: value,
                                  price: _editedProduct.price,
                                  id: _editedProduct.id,
                                  description: _editedProduct.description,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '*Required parameter';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return '*Invalid Url.';
                                }
                                if (!value.endsWith('png') &&
                                    !value.endsWith('jpg') &&
                                    !value.endsWith('jpeg')) {
                                  return '*Invalid image Url.';
                                }
                                if (value.contains(' ')) {
                                  return '*Invalid Url.';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              _saveForm();
                            },
                            child: Text('Save'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
