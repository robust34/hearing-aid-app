// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/home/main_screen.dart';
import 'package:doceo_new/pages/home/room_drawer.dart';
import 'package:doceo_new/pages/myPage/my_page_screen.dart';
import 'package:doceo_new/pages/notification/notification_screen.dart';
import 'package:doceo_new/pages/search/search_screen.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';

enum TabItem { home, search, notification, myPage }

class HomePage extends StatefulWidget {
  static TabItem index = TabItem.home;
  const HomePage({super.key});

  static final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.notification: GlobalKey<NavigatorState>(),
    TabItem.myPage: GlobalKey<NavigatorState>(),
  };

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    // _currentTab = TabItem.values[HomePage.index];
    super.initState();
  }

  // var _currentTab = TabItem.values[HomePage.index.index];

  void _selectTab(TabItem tabItem) {
    setState(() {
      HomePage.index = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    ToastContext().init(context);
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: Drawer(width: width * 0.86, child: const RoomDrawer()),
          body: _buildSelectedScreen(HomePage.index.index),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                      'assets/images/bottom-tab-home-unfocused.svg'),
                  activeIcon: SvgPicture.asset(
                      'assets/images/bottom-tab-home-focused.svg'),
                  label: 'home'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                      'assets/images/bottom-tab-search-unfocused.svg'),
                  activeIcon: SvgPicture.asset(
                      'assets/images/bottom-tab-search-focused.svg'),
                  label: 'search'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                      'assets/images/bottom-tab-notification-unfocused.svg'),
                  activeIcon: SvgPicture.asset(
                      'assets/images/bottom-tab-notification-focused.svg'),
                  label: 'notification'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                      'assets/images/bottom-tab-my-page-unfocused.svg'),
                  activeIcon: SvgPicture.asset(
                      'assets/images/bottom-tab-my-page-focused.svg'),
                  label: 'myPage'),
            ],
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: HomePage.index.index,
            selectedItemColor: Colors.blue,
            onTap: (index) => _selectTab(TabItem.values[index]),
            type: BottomNavigationBarType.fixed,
          ),
        ),
        onWillPop: () => Future.value(false));
  }

  Widget _buildSelectedScreen(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return MainScreen();
      case 1:
        return const SearchScreen();
      case 2:
        return const NotificationScreen();
      case 3:
        return const MyPageScreen();
      default:
        return MainScreen();
    }
  }

  Future<void> goLogOut() async {
    try {
      await Amplify.Auth.signOut();
      AuthenticateProviderPage.of(context, listen: false).isAuthenticated =
          false;
    } on AuthException catch (e) {
      print(e.message);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "サインアウト エラーです。もう一度お試しください。");
    }
  }
}
