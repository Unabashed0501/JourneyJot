import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  // list of items on sale
  final List _shopItems = const [
    // [ itemName, itemPrice, imagePath, color ]
    ["Avocado", "4.00", "lib/images/avocado.png", Colors.green],
    ["Banana", "2.50", "lib/images/banana.png", Colors.yellow],
    ["Chicken", "12.80", "lib/images/chicken.png", Colors.brown],
    ["Water", "1.00", "lib/images/water.png", Colors.blue],
  ];
  final Map<String, dynamic> itinerary = {};
  // list of cart items
  final List _cartItems = [];

  get cartItems => _cartItems;

  get shopItems => _shopItems;

  // add item to cart
  void addItemToCart(Map<String, dynamic> itinerary, int day) {
    // _cartItems.add(_shopItems[index]);
    _cartItems.add({
      'Name': itinerary['Name'],
      'Address': itinerary['Address'],
      'Day': day
    });
    notifyListeners();
  }

  // remove item from cart
  void removeItemFromCart(String name) {
    _cartItems.removeWhere((itinerary) => itinerary['Name'] == name);
    notifyListeners();
  }

  // calculate total price
  String calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalPrice += double.parse(cartItems[i][1]);
    }
    return totalPrice.toStringAsFixed(2);
  }
}
