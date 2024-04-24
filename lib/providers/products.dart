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
      getProduct();
      //print the response body
      print(jsonDecode(response.body));
      //return true if the product is added successfully
      return true;
    } else {
      print(jsonDecode(response.body));
      print('Failed to add product. Error: ${response.statusCode}');
      //return false if the product is not added successfully
      return false;
    }
  }

  //TODO: GET Product Paginated
  Future<void> getProduct() async {
    Uri url =
        Uri.parse('https://api.escuelajs.co/api/v1/products?offset=0&limit=5');

    var response = await http.get(url);
    var data = jsonDecode(response.body) as List<dynamic>;

    _items = data.map((element) {
      // Decode the first image URL string back into a list of URLs
      List<dynamic> imageUrls = jsonDecode(element['images'][0]);

      // Use the first URL from the decoded list
      String imageUrl = imageUrls[0];

      return Product(
        id: element['id'],
        title: element['title'],
        description: element['description'],
        price: element['price'],
        image: imageUrl,
      );
    }).toList();

    print('Data berhasil ditambahkan');
    print('local item : $_items');
    print('data : ${_items[0].image}');
    notifyListeners();
  }

  //TODO: Get Product by ID
  Future<bool> getProductById(int id) async {
    var url = 'https://api.escuelajs.co/api/v1/products/$id';

    if (_items.any((element) => element.id == id)) {
      print('Product already exists');
      _items = [
        _items.firstWhere((element) => element.id == id),
      ];
      notifyListeners();
      return true;
    } else {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as Map<String, dynamic>;

        // Decode the first image URL string back into a list of URLs
        List<dynamic> imageUrls = jsonDecode(data['images'][0]);

        // Use the first URL from the decoded list
        String imageUrl = imageUrls[0];

        _items.add(Product(
          id: data['id'],
          title: data['title'],
          description: data['description'],
          price: data['price'],
          image: imageUrl,
        ));
        _items = [
          _items.firstWhere((element) => element.id == data['id']),
        ];

        print('Product added successfully');
        print('local item after: $_items');
        notifyListeners();
        return true;
      } else {
        print('Failed to get product. Error: ${response.statusCode}');
        return false;
      }
    }
  }

  //TODO: Edit Product
  Future<bool> editProduct(String id, String title, int price) async {
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
      getProduct();
      return true;
    } else {
      print('Failed to edit product. Error: ${response.statusCode}');
      return false;
    }
  }

  //TODO: Delete Product
  Future<bool> deleteProduct(String id) async {
    var url = 'https://api.escuelajs.co/api/v1/products/$id';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Product deleted successfully');
      //update the product list after deleting
      getProduct();
      return true;
    } else {
      print('Failed to delete product. Error: ${response.statusCode}');
      return false;
    }
  }
}
