import 'package:flutter/material.dart' show BuildContext,
CustomScrollView, EdgeInsets, Padding, SliverChildBuilderDelegate,
SliverList, SliverToBoxAdapter, StatelessWidget, Text, Theme, Widget;
import '../cardapio.dart';
import '../components/highlight_item.dart';

class Highlights extends StatelessWidget {
  const Highlights({super.key});

  final List items = destaques;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Text(
              "Destaques",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return HighlightItem(
                imageURI: items[index]["image"],
                itemTitle: items[index]["name"],
                itemPrice: items[index]["price"],
                itemDescription: items[index]["description"],
              );
            }, childCount: items.length),
          ),
        ],
      ),
    );
  }
}
