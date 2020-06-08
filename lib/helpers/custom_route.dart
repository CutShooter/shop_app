import 'package:flutter/material.dart';
import 'package:shop_app/Screens/auth-screen.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == AuthScreen.routeName) {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (route.isFirst) {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
