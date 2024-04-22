import 'dart:convert';

import 'package:fgd_6/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => _items;

  int get totalItems => _items.length;

  List<Product> searchItem(int id) {
    return items.where((element) => element.id == id).toList();
  }

  Future<void> connectAPI() async {
    Uri url =
        Uri.parse('https://api.escuelajs.co/api/v1/products?offset=0&limit=10');

    var response = await http.get(url);
    var data = jsonDecode(response.body) as List<dynamic>;

    _items = data
        .map((element) => Product(
              id: element['id'],
              title: element['title'],
              description: element['description'],
              price: element['price'],
              image: element['images'][0], // Add the 'image' argument
            ))
        .toList();

    print('Data berhasil ditambahkan');
    notifyListeners();
  }
}
