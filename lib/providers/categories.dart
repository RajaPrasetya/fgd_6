import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../models/category.dart';

class CategoriesProvider with ChangeNotifier {
  List<Category> _items = [];

  //getter
  List<Category> get items => _items;

  //get total items
  int get totalItems => _items.length;

  Future<void> getCategories() async {
    Uri url = Uri.parse('http://10.0.2.2:8000/api/v1/categories');
    var response = await http.get(url);
    var data = jsonDecode(response.body) as List<dynamic>;

    _items = data.map((element) {
      return Category(
        id: element['category_id'],
        name: element['title'],
        image: element['image'],
      );
    }).toList();

    notifyListeners();
    print('Data berhasil ditambahkan');
    print('local item : $_items');
    print('data : ${_items[0].image}');
  }
}
