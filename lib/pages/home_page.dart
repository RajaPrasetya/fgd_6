import 'package:fgd_6/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<ProductProvider>(context).connectAPI();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Store API'),
        centerTitle: true,
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
