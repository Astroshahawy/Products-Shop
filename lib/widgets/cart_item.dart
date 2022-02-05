import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String cartId;
  final String title;
  final String imgUrl;
  final double price;
  final int quantity;

  const CartItem({
    @required this.id,
    @required this.cartId,
    @required this.title,
    @required this.imgUrl,
    @required this.price,
    @required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).errorColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.delete, color: Colors.white),
            Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Confirm'),
          content: Text('Do you want to remove "$title" from the cart?'),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: Text('NO',
                  style: TextStyle(color: Theme.of(context).errorColor)),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: Text('YES',
                  style: TextStyle(color: Theme.of(context).errorColor)),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        cart.removeItem(productId: cartId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: ListTile(
          title: Text(title),
          subtitle: Text('Price: ${price.toStringAsFixed(2)}\$'),
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Hero(
              tag: cartId,
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    cart.increaseItemCount(productId: cartId);
                  }),
              Text(quantity.toString()),
              IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    cart.decreaseItemCount(productId: cartId);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
