import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as order_provider;

class OrderItem extends StatefulWidget {
  final order_provider.OrderItem order;

  const OrderItem({@required this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ExpansionTile(
            title: Text('Order amount: \$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy - hh:mm').format(widget.order.dateTime),
            ),
            // trailing: IconButton(
            //     icon: const Icon(Icons.expand_more), onPressed: () {}),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              ListBody(
                children: widget.order.products
                    .map(
                      (prod) => ListTile(
                        title: Text(prod.title),
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.network(
                            prod.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        subtitle: Text(
                            '\$${(prod.price * prod.quantity).toStringAsFixed(2)}'),
                        trailing: Text('${prod.quantity}x'),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
