import 'package:flutter/material.dart';
import 'package:panucci_ristorante/components/main_drawer.dart';
import 'package:panucci_ristorante/screens/checkout.dart';
import 'package:panucci_ristorante/screens/highlights.dart';
import 'package:panucci_ristorante/screens/supermarket/product_scanner_screen.dart';
import 'package:panucci_ristorante/themes/app_colors.dart';

import 'supermarket/barcode _test.dart';
import 'drink_menu.dart';
import 'food_menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const Highlights(),
      const Menu(),
      const DrinkMenu(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ristorante Panucci"),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              Icons.account_circle,
              size: 32,
            ),
          )
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Checkout();
          }));
        },
        child: const Icon(Icons.point_of_sale),
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.star_rounded),
              label: 'Destaques',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_bar),
              label: 'Bebidas',
            ),
          ],
        selectedItemColor: AppColors.bottomNavigationBarIconColor,
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
      // body: pages[_currentPage],
      body: pages.elementAt(_currentPage),
    );
  }
}
