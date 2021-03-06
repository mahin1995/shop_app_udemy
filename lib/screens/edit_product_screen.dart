import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocuseNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  TextEditingController _imageUrlController = new TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product_m(id: '', title: '', price: 0, description: '', imageUrl: '');
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isLoading = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final modulroute = ModalRoute.of(context);
      final productId = modulroute != null ? modulroute.settings.arguments : '';
      if (productId != null) {
        final product = Provider.of<Products>(context, listen: false).findById(productId.toString());
        _editedProduct = product;
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),

          /// 'imageUrl': _editedProduct.imageUrl
          /// 'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((_imageUrlController.text.isEmpty) ||
          (!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocuseNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    print(" edited product id ${_editedProduct.id.runtimeType}");
    if ((_editedProduct.id == null) || (_editedProduct.id == '')) {
  try {
      print("add product");
      await Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    } catch (error) {
      print("add prod $error");

      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("An Error is ocuring"),

              /// content: Text(error.toString()),);
              content: Text("Something bad happen"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            );
          });
    }
 
    }
  
else{
  print(" edited product no id ${_editedProduct.id}");
      await Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
      Navigator.of(context).pop();
  
}
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocuseNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product_m(
                            title: '$value',
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            description: _editedProduct.description,
                            isFavorite: _editedProduct.isFavorite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please provide a value";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                          labelText: 'Price',
                          errorStyle: TextStyle(color: Colors.red),
                          // errorBorder: OutlineInputBorder(),
                          fillColor: Colors.red),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocuseNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product_m(
                            title: _editedProduct.title,
                            price: double.parse('$value'),
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            description: _editedProduct.description,
                            isFavorite: _editedProduct.isFavorite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a pirce";
                        }
                        if (double.tryParse(value) == null) {
                          return 'please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number gretter then zero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product_m(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            description: '$value',
                            isFavorite: _editedProduct.isFavorite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return "Should be 10 character long";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text("Enter url")
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),

                            /// initialValue: _imageUrl,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product_m(
                                  title: _editedProduct.title,
                                  price: _editedProduct.price,
                                  imageUrl: value ?? _editedProduct.imageUrl,
                                  id: _editedProduct.id,
                                  description: _editedProduct.description,
                                  isFavorite: _editedProduct.isFavorite);
                            },
                            validator: (value) {
                              var urlPattern =
                                  r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:??????,.;]*)?";
                              var result = new RegExp(urlPattern, caseSensitive: false).firstMatch('$value');
                              if (result == null) {
                                return "Not vailid url";
                              }
                          
                              if (value!.isEmpty) {
                                return 'please enter an image url';
                              }
                              if (!value.startsWith('http') && !value.startsWith('https')) {
                                return 'Please Enter a valid url';
                              }
                              if (!value.endsWith('.png') && !value.endsWith('.jpg')) {
                                return 'Please Enter a valid Image';
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
