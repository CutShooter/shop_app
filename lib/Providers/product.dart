import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavouriteStatus(String authToken, String userId) async {
    final url =
        'https://flutter-update-e84cd.firebaseio.com/userProducts/$userId/$id.json?auth=$authToken';
    var oldFavourite = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      if (response.statusCode >= 400) {
        isFavourite = oldFavourite;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldFavourite;
      notifyListeners();
      throw error;
    }
  }
}
