
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zanmutm_pos_client/src/routes/app_routes.dart';
import 'package:zanmutm_pos_client/src/routes/app_tab_item.dart';

/// This widget a wrapper for tabs
/// that can be applied to all routed pages
/// It accept child widget which is a router page
class AppTabNavigationShell extends StatefulWidget {
  final Widget child;
  const AppTabNavigationShell({Key? key, required this.child}) : super(key: key);

  @override
  State<AppTabNavigationShell> createState() => _AppTabNavigationShellState();
}

class _AppTabNavigationShellState extends State<AppTabNavigationShell> {

  int _currentTabIndex = 0;

  _goToTab(BuildContext context, int index) {
    setState(() {
      _currentTabIndex = index;
    });
    AppTabItem tab = AppRoutes.tabRoutes.elementAt(index);
    context.go(tab.path);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        items:  [
          ...AppRoutes.tabRoutes.map((e) =>
              BottomNavigationBarItem(icon: e.icon,label: e.label)
          )
        ],
        onTap: (int tabIndex) =>_goToTab(context, tabIndex),
      ),
    );
  }
}