import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/orders_screen.dart';
import '../Screens/user_products_screen.dart';

import '../Providers/auth.dart';

class AppDrawer extends StatelessWidget {
  Widget buildDrawerItem(IconData icon, String title, MediaQueryData mediaQuery,
      BuildContext context, Function onTappedFunction) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTappedFunction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          buildDrawerItem(Icons.shop, 'Shop', mediaQuery, context, () {
            Navigator.of(context).pushReplacementNamed('/');
          }),
          Divider(),
          buildDrawerItem(Icons.payment, 'Orders', mediaQuery, context, () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          }),
          buildDrawerItem(Icons.edit, 'Manage Products', mediaQuery, context,
              () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          }),
          buildDrawerItem(Icons.exit_to_app, 'Logout', mediaQuery, context, () {
            Provider.of<Auth>(context, listen: false).logOut();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
          }),
        ],
      ),
    );
  }
}
