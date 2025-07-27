import 'package:flutter/material.dart';

import '../cardapio.dart';
import '../components/food_item.dart';
import '../components/food_menu_item.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  final List items = comidas;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Text(
              "Menu",
              style:TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFamily: "Caveat",
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return FoodItem(
                imageURI: items[index]["image"],
                itemTitle: items[index]["name"],
                itemPrice: items[index]["price"],
                // itemDescription: items[index]["description"],
              );
            }, childCount: items.length),
          ),
        ],
      ),
    );
  }
}
