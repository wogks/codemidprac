import 'package:code_mid/common/const/colors.dart';
import 'package:code_mid/common/layout/default_layout.dart';
import 'package:code_mid/common/view/profile_screen.dart';
import 'package:code_mid/order/view/order_screen.dart';
import 'package:code_mid/product/view/product_screen.dart';
import 'package:code_mid/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  static const String routeName = 'home';
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListenr);
  }

  @override
  void dispose() {
    controller.removeListener(tabListenr);
    super.dispose();
  }

  void tabListenr() {
    setState(() {
      indexs = controller.index;
    });
  }

  int indexs = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: 'wogks',
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: PRIMARY_COLOR,
          unselectedItemColor: BODY_TEXT_COLOR,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.shifting,
          onTap: (int index) {
            controller.animateTo(index);
          },
          currentIndex: indexs,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '홈',
            ),
          ],
        ),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: const [
            RestaurantScreen(),
            ProductScreen(),
            OrderScreen(),
            ProfileScreen(),
          ],
        ));
  }
}
