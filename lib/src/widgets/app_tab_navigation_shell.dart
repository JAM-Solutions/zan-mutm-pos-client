import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zanmutm_pos_client/src/models/user.dart';
import 'package:zanmutm_pos_client/src/providers/app_state_provider.dart';
import 'package:zanmutm_pos_client/src/providers/cart_provider.dart';
import 'package:zanmutm_pos_client/src/providers/tab_provider.dart';
import 'package:zanmutm_pos_client/src/routes/app_routes.dart';
import 'package:zanmutm_pos_client/src/widgets/app_drawer.dart';

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
      Consumer2<TabProvider, CartProvider>(
        builder: (context, tabProvider, cartProvider, child) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(tabProvider.currentTab.title),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.translate_rounded))
              ],
            ),
            drawer: const AppDrawer(),
            body: Selector<AppStateProvider, User>(
              selector: (context, state) => state.user!,
              builder: (context, user, child) {
                return Column(
                  children: [
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
              currentIndex: tabProvider.currentTabIndex,
              type: BottomNavigationBarType.fixed,
              items: [
                ...AppRoutes.tabRoutes.map((e) {
                  Widget icon = e.label.contains('Cart') &&
                          cartProvider.cartItems.isNotEmpty
                      ? Badge(
                          badgeContent:
                              Text(cartProvider.cartItems.length.toString()),
                          padding: const EdgeInsets.all(6),
                          position: BadgePosition.topEnd(top: -20, end: -16),
                          child: e.icon,
                        )
                      : e.icon;
                  return BottomNavigationBarItem(icon: icon, label: e.label);
                })
              ],
              onTap: (int tabIndex) => tabProvider.gotToTab(context, tabIndex),
            ),
          );
        },
      ),
    ]);
  }
}
