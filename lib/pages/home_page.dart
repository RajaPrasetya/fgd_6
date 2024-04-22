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
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit', arguments: {
                        'id': item.id,
                        'title': item.title,
                        'price': item.price,
                      });
                    },
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
