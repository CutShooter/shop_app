import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './helpers/custom_route.dart';

import './Providers/cart.dart';
import './Providers/products.dart';
import './Providers/orders.dart';
import './Providers/auth.dart';

import './Screens/orders_screen.dart';
import './Screens/cart_screen.dart';
import './Screens/products_overview_screen.dart';
import './Screens/product_details.dart';
import './Screens/user_products_screen.dart';
import './Screens/edit_product_screen.dart';
import './Screens/auth-screen.dart';
import './Screens/splash-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) {
            previousProducts.token = auth.token;
            previousProducts.userId = auth.userId;
            return previousProducts;
          },
          create: (_) => Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) {
            previousOrders.authToken = auth.token;
            previousOrders.userId = auth.userId;
            return previousOrders;
          },
          create: (_) => Orders(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransition(),
                  TargetPlatform.iOS: CustomPageTransition(),
                })),
            home: authData.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            }),
      ),
    );
  }
}
