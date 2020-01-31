import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Models/http_exception.dart';

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String _authToken;
  String _userId;

  set userId(String id) {
    _userId = id;
  }

  set authToken(String token) {
    _authToken = token;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://flutter-update-e84cd.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (extractedData == null) return;
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
    } catch (error) {
      print(error.toString());
      HttpException('Something went wrong');
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-update-e84cd.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    final timestamp = DateTime.now();
    var response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((ct) => {
                    'id': ct.id,
                    'title': ct.title,
                    'price': ct.price,
                    'quantity': ct.quantity,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timestamp,
            products: cartProducts));
    notifyListeners();
  }
}
