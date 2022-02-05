import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum MenuOptions {
  showFavorite,
  showAll,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) {
              final v = cart.cartCounter;
              return v > 0
                  ? Badge(
                      value: v.toString(),
                      child: child,
                    )
                  : child;
            },
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (MenuOptions selectedValue) {
              setState(() {
                if (selectedValue == MenuOptions.showFavorite) {
                  _showFavorites = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: MenuOptions.showFavorite,
                child: Text('Show favorites'),
              ),
              const PopupMenuItem(
                value: MenuOptions.showAll,
                child: Text('Show all'),
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Products>(context, listen: false).fetchProducts(),
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ProductsGrid(isFavorite: _showFavorites);
          }
        },
      ),
    );
  }
}
