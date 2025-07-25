import 'package:flutter/material.dart';

class FoodMenuItem extends StatelessWidget {
  const FoodMenuItem({super.key, required this.imageURI, required this.itemTitle, required this.itemPrice});
  final String imageURI;
  final String itemTitle;
  final String itemPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(itemTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("R\$ $itemPrice"),
                  ]
              ),
            ),
            Image(
              height: 80,
              width: 80,
              image: AssetImage(imageURI),
              fit: BoxFit.cover,
            ),
          ],
        )
      ),
    );
  }
}
