import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: cart.items.containsKey(product.id)
                  ? const Icon(
                      Icons.shopping_cart,
                      color: Colors.green,
                    )
                  : const Icon(Icons.add_shopping_cart),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  cart.items.containsKey(product.id)
                      ? SnackBar(
                          content: Text(
                            '${product.title} is already added to cart!',
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ),
                          duration: const Duration(seconds: 1),
                        )
                      : SnackBar(
                          content: Text('${product.title} is added to cart!'),
                          duration: const Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              cart.removeSingleCartItem(productId: product.id);
                            },
                          ),
                        ),
                );
                cart.addItem(
                  product.id,
                  product.title,
                  product.imageUrl,
                  product.price,
                );
              },
            ),
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: product.isFavorite
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus(auth.token, auth.userId);
              },
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          ),
          child: Hero(
            tag: product.id,
                      child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
