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
  final Map<String, dynamic> attraction = {};
  // list of cart items
  final List _cartItems = [];

  get cartItems => _cartItems;

  get shopItems => _shopItems;

  // add item to cart
  void addItemToCart(String itineraryName, Map<String, dynamic> attraction, int day) {
    // _cartItems.add(_shopItems[index]);
    _cartItems.add({
      'Itinerary': itineraryName,
      'Name': attraction['Name'],
      'Address': attraction['Address'],
      'Day': day
    });
    notifyListeners();
  }

  // remove item from cart
  void removeItemFromCart(String name) {
    _cartItems.removeWhere((attraction) => attraction['Name'] == name);
    notifyListeners();
  }

  List filterCartItemsByItinerary(String itineraryName){
    List filteredCartItems = [];
    for (int i = 0; i < _cartItems.length; i++) {
      if (_cartItems[i]['Itinerary'] == itineraryName) {
        filteredCartItems.add(_cartItems[i]);
      }
    }
    return filteredCartItems;
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
