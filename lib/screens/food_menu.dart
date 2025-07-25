import 'package:flutter/material.dart';

import '../cardapio.dart';
import '../components/food_menu_item.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  final List items = comidas;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              "Menu",
              style:TextStyle(
                fontFamily: "Caveat",
                fontSize: 32,
                color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return FoodMenuItem(
              imageURI: items[index]["image"],
              itemTitle: items[index]["name"],
              itemPrice: items[index]["price"],
              // itemDescription: items[index]["description"],
            );
          }, childCount: items.length),
        ),
      ],
    );
  }
}
