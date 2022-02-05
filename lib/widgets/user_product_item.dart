import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {@required this.title, @required this.imageUrl, @required this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      trailing: FittedBox(
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                }),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirm'),
                    content: Text('Do you want to delete "$title"?'),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text('NO',
                            style:
                                TextStyle(color: Theme.of(context).errorColor)),
                      ),
                      MaterialButton(
                        onPressed: () {
                          try {
                            Provider.of<Products>(context, listen: false)
                                .deleteProduct(id)
                                .then(
                                  (value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Product deleted!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ),
                                );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Deleting failed!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor),
                                ),
                              ),
                            );
                          }
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text('YES',
                            style:
                                TextStyle(color: Theme.of(context).errorColor)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
