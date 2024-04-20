import 'dart:ui';
import 'package:flutter/material.dart';

class ReorderableListTile extends StatefulWidget {
  final List<dynamic> cartItems;
  const ReorderableListTile({super.key, required this.cartItems});

  @override
  State<ReorderableListTile> createState() => _ReorderableListTileState();
}

class _ReorderableListTileState extends State<ReorderableListTile> {
  // final List<int> _items = List<int>.generate(5, (int index) => index);
  // get _items => widget.cartItems;
  late List<dynamic> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.cartItems;
  }

  @override
  Widget build(BuildContext context) {
    final Color oddItemColor = Colors.lime.shade100;
    final Color evenItemColor = Colors.deepPurple.shade100;
    final List<Card> cards = <Card>[
      for (int index = 0; index < _items.length; index += 1)
        Card(
          key: ValueKey(index),
          color: index.isOdd ? oddItemColor : evenItemColor,
          child: SizedBox(
            height: 80,
            child: Center(
              child: Text('Card ${_items[index]['Name']}'),
            ),
          ),
        ),
    ];

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(1, 6, animValue)!;
          final double scale = lerpDouble(1, 1.02, animValue)!;
          return Transform.scale(
            scale: scale,
            // Create a Card based on the color and the content of the dragged one
            // and set its elevation to the animated value.
            child: Card(
              elevation: elevation,
              color: cards[index].color,
              child: cards[index].child,
            ),
          );
        },
        child: child,
      );
    }

    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      proxyDecorator: proxyDecorator,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final int item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
      },
      children: cards,
    );
  }
}
