import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/orders.dart' show Orders;

import '../Widgets/order_item.dart';
import '../Widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context).fetchAndSetProducts(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('Sorry an error occured'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderedData, child) {
                  if (orderedData.orders.length <= 0)
                    return Center(
                      child: Text(
                        'No orders here',
                      ),
                    );
                  return ListView.builder(
                    itemCount: orderedData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(orderedData.orders[i]),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
