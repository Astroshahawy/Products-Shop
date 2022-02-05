import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user_products_screen';

  Future _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Consumer<Products>(
                builder: (context, data, _) => ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (_, i) => Column(
                    children: [
                      UserProductItem(
                        id: productData.items[i].id,
                        title: productData.items[i].title,
                        imageUrl: productData.items[i].imageUrl,
                      ),
                      const Divider(),
                    ],
                  ),
                  itemCount: productData.items.length,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
