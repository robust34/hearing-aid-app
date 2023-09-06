// ignore: file_names
import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/pages/home/main_screen.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String notification = '/notification';
  static const String myPage = '/myPage';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({@required this.navigatorKey, required this.tabItem});

  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(
    BuildContext context,
  ) {
    return {
      TabNavigatorRoutes.home: (context) => MainScreen(),
      TabNavigatorRoutes.search: (context) => Container(),
      TabNavigatorRoutes.notification: (context) => Container(),
      TabNavigatorRoutes.myPage: (context) => Container(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);

    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.home,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name]!(context),
        );
      },
    );
  }
}
