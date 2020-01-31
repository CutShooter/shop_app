import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../Models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  String _authToken;
  String _userId;

  set token(String token) {
    if (token == null)
      _authToken = '';
    else
      _authToken = token;
  }

  set userId(String id) {
    if (id == null)
      _userId = '';
    else
      _userId = id;
  }

  List<Product> get items {
    if (_items == null) return [];
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => (id == prod.id));
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-update-e84cd.firebaseio.com/products.json?auth=$_authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-update-e84cd.firebaseio.com/products/$id.json?auth=$_authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'creatorId': _userId,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-update-e84cd.firebaseio.com/products/$id.json?auth=$_authToken';
    var existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Something is wrong...');
    }
    existingProduct = null;
    existingProductIndex = null;
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    var url =
        'https://flutter-update-e84cd.firebaseio.com/products.json?auth=$_authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      url =
          'https://flutter-update-e84cd.firebaseio.com/userProducts/$_userId.json?auth=$_authToken';
      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite:
              favouriteData == null ? true : favouriteData[prodId] ?? true,
        ));
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }
}
