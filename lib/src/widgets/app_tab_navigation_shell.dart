import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zanmutm_pos_client/src/models/user.dart';
import 'package:zanmutm_pos_client/src/providers/app_state_provider.dart';
import 'package:zanmutm_pos_client/src/providers/cart_provider.dart';
import 'package:zanmutm_pos_client/src/routes/app_routes.dart';
import 'package:zanmutm_pos_client/src/routes/app_tab_item.dart';
import 'package:zanmutm_pos_client/src/services/auth_service.dart';
import 'package:zanmutm_pos_client/src/widgets/app_icon_button.dart';

/// This widget a wrapper for tabs
/// that can be applied to all routed pages
/// It accept child widget which is a router page
class AppTabNavigationShell extends StatefulWidget {
  final Widget child;

  const AppTabNavigationShell({Key? key, required this.child})
      : super(key: key);

  @override
  State<AppTabNavigationShell> createState() => _AppTabNavigationShellState();
}

class _AppTabNavigationShellState extends State<AppTabNavigationShell> {
  int _currentTabIndex = 0;
  AppTabItem _currentTab = AppRoutes.tabRoutes.elementAt(0);

  _goToTab(BuildContext context, int index) {
    Provider.of<AppStateProvider>(context, listen: false)
        .setTabDirection(_currentTabIndex < index ? 1.0 : -10.0);
    setState(() {
      _currentTabIndex = index;
      _currentTab = AppRoutes.tabRoutes.elementAt(index);
    });
    context.go(_currentTab.path);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(color: Color(0xFFebebeb)),
          ))
        ],
      ),
      Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(_currentTab.title),
              centerTitle: true,
              actions: [
                if (cartProvider.cartItems.isNotEmpty)
                  Badge(
                    badgeContent:
                        Text(cartProvider.cartItems.length.toString()),
                    padding: const EdgeInsets.all(6),
                    position: BadgePosition.topStart(),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart)),
                  )
              ],
            ),
            drawer: Drawer(
              child: Column(
                children: [],
              ),
            ),
            body: Selector<AppStateProvider, User>(
              selector: (context, state) => state.user!,
              builder: (context, user, child) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              user.firstName != null && user.lastName != null
                                  ? '${user.firstName?.substring(0, 1)}${user.lastName?.substring(0, 1)}'
                                  : 'AV',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          AppIconButton(
                              onPressed: () {
                                authService.logout();
                              },
                              icon: Icons.login_sharp)
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                )),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: widget.child)),
                  ],
                );
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentTabIndex,
              items: [
                ...AppRoutes.tabRoutes.map((e) {
                  Widget icon = e.label.contains('Cart') ? e.icon : e.icon;
                  return BottomNavigationBarItem(icon: icon, label: e.label);
                })
              ],
              onTap: (int tabIndex) => _goToTab(context, tabIndex),
            ),
          );
        },
      ),
    ]);
  }
}
