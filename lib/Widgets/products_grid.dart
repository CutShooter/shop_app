import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';
import '../Providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final showFavourites;

  ProductsGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    final loadedProducts = showFavourites
        ? Provider.of<Products>(context).favouriteItems
        : Provider.of<Products>(context).items;
    final mediaQuery = MediaQuery.of(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: mediaQuery.size.aspectRatio * 1.5,
          crossAxisSpacing: mediaQuery.size.height * 0.01,
          mainAxisSpacing: mediaQuery.size.width * 0.01),
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: loadedProducts[index],
          child: ProductItem(),
        );
      },
    );
  }
}
