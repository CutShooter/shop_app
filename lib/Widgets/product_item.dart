import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/cart.dart';
import '../Providers/product.dart';
import '../Providers/auth.dart';

import '../Screens/product_details.dart';

class ProductItem extends StatefulWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(
  //     {@required this.imageUrl, @required this.title, @required this.id});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final mediaQuery = MediaQuery.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assests/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, _) => _isLoading
                ? Container(
                    height: mediaQuery.size.height * 0.03,
                    width: mediaQuery.size.width * 0.06,
                    child: CircularProgressIndicator())
                : IconButton(
                    icon: product.isFavourite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        await product.toggleFavouriteStatus(
                            authData.token, authData.userId);
                      } catch (_) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Sorry, not able to add to favourites...',
                            textAlign: TextAlign.center,
                          ),
                        ));
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    color: Theme.of(context).accentColor,
                  ),
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () async {
                await cart.addItem(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Added item to cart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ));
              },
              color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
