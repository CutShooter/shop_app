import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/app_drawer.dart';
import '../Widgets/badge.dart';
import '../Widgets/products_grid.dart';
import '../Providers/cart.dart';
import './cart_screen.dart';
import '../Providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavourites = false;
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favourites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ],
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  switch (selectedValue) {
                    case FilterOptions.Favorites:
                      _showFavourites = true;
                      break;
                    case FilterOptions.All:
                      _showFavourites = false;
                      break;
                  }
                });
              }),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavourites),
    );
  }
}
