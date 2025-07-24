import 'package:flutter/material.dart';

import '../cardapio.dart';
import '../components/highlight_item.dart';

class Highlights extends StatelessWidget {
  const Highlights({super.key});
   final List items = destaques;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemBuilder: (context, index){
          return HighlightItem(
              imageURI: items[index]["image"],
              itemTitle: items[index]["name"],
              itemPrice: items[index]["price"],
              itemDescription: items[index]["description"]
          );
        },
      ),
    );
  }
}
