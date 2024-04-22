import 'dart:convert';

import 'package:fgd_6/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  //TODO: List of Products
  List<Product> _items = [];

  //TODO: Get Items
  List<Product> get items => _items;

  //TODO: Get Total Items
  int get totalItems => _items.length;

  //TODO: Search Product
  List<Product> searchItem(int id) {
    return items.where((element) => element.id == id).toList();
  }

  //TODO: Add Product
  Future<bool> addProduct(String title, int price, String description,
      int categoryId, String image) async {
    var url = 'https://api.escuelajs.co/api/v1/products';

    final productData = {
      'title': title,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'images': [image],
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );

    if (response.statusCode == 201) {
      print('Product added successfully');
      //update the product list after adding
      connectAPI();
      //print the response body
      print(jsonDecode(response.body));
      //return true if the product is added successfully
      return true;
    } else {
      print('Failed to add product. Error: ${response.statusCode}');
      //return false if the product is not added successfully
      return false;
    }
  }

  //TODO: GET Product
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
              image: element['images'][0],
            ))
        .toList();

    print('Data berhasil ditambahkan');
    notifyListeners();
  }

  //TODO: Edit Product
  Future<void> editProduct(String id, String title, int price) async {
    var url = 'https://api.escuelajs.co/api/v1/products/$id';

    final productData = {
      'title': title,
      'price': price,
    };

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );

    if (response.statusCode == 200) {
      print('Product edited successfully');
      //update the product list after editing
      connectAPI();
    } else {
      print('Failed to edit product. Error: ${response.statusCode}');
    }
  }

  //TODO: Delete Product
  Future<void> deleteProduct(String id) async {
    var url = 'https://api.escuelajs.co/api/v1/products/$id';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Product deleted successfully');
      //update the product list after deleting
      connectAPI();
    } else {
      print('Failed to delete product. Error: ${response.statusCode}');
    }
  }
}
