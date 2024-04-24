import 'package:fgd_6/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isInit = true;
  late ProductProvider productProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      productProvider = Provider.of<ProductProvider>(context);
      productProvider.getProduct();
    }
    isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Store API'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  int id = 0;
                  return AlertDialog(
                    title: const Text('Search Product by ID'),
                    content: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        id = int.parse(value);
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          product.getProductById(id).then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product Found'),
                                ),
                              );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product Not Found'),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          });
                        },
                        child: const Text('Search'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.search),
          ),
          //refresh button
          IconButton(
            onPressed: () {
              product.getProduct();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add),
      ),
      body: product.totalItems == 0
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: product.totalItems,
              itemBuilder: (context, index) {
                final item = product.items[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item.image),
                  ),
                  title: Text(item.title),
                  subtitle: Text('\$ ${item.price}'),
                  trailing: IconButton(
                    onPressed: () {
                      product.deleteProduct(item.id.toString()).then(
                            (value) => {
                              if (value)
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Product Deleted'),
                                    ),
                                  ),
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to delete product'),
                                    ),
                                  ),
                                }
                            },
                          );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: item.id);
                  },
                );
              },
            ),
    );
  }
}
