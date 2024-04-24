import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String title = '';
  int price = 0;
  String description = '';
  int categoryId = 0;
  String images = '';

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Title', (value) {
                setState(() {
                  title = value;
                });
              }, keyboardType: TextInputType.text),
              SizedBox(height: 16.0),
              _buildTextField('Price', (value) {
                setState(() {
                  price = int.parse(value);
                });
              }, keyboardType: TextInputType.number),
              SizedBox(height: 16.0),
              _buildTextField('Description', (value) {
                setState(() {
                  description = value;
                });
              }, keyboardType: TextInputType.text),
              SizedBox(height: 16.0),
              _buildTextField('Category ID', (value) {
                setState(() {
                  categoryId = int.parse(value);
                });
              }, keyboardType: TextInputType.number),
              SizedBox(height: 16.0),
              _buildTextField('Images', (value) {
                setState(() {
                  images = value;
                });
              }, keyboardType: TextInputType.text),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  productProvider
                      .addProduct(
                    title,
                    price,
                    description,
                    categoryId,
                    images,
                  )
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product added successfully'),
                        ),
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to add product'),
                        ),
                      );
                    }
                  });
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, Function(String) onChanged,
      {required TextInputType keyboardType}) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}
