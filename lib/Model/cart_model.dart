// import 'package:flutter/material.dart';

class CartModel {
  String itinerary;
  String name;
  String address;
  int day;
  CartModel({this.itinerary = '', this.name = '', this.address = '', this.day = 0});
  CartModel.initialState()
      : itinerary = '',
        name = '',
        address = '',
        day = 0;
  @override
  String toString() {
    return "$itinerary: $name, $address, $day";
  }
  bool isNotEmpty() {
    return itinerary.isNotEmpty && name.isNotEmpty && address.isNotEmpty && day != 0;
  }
}
// class CartModel extends ChangeNotifier {
//   // list of items on sale
//   final Map<String, dynamic> attraction = {};
//   // list of cart items
//   final List _cartItems = [];

//   get cartItems => _cartItems;

//   // add item to cart
//   void addItemToCart(String itineraryName, Map<String, dynamic> attraction, int day) {
//     _cartItems.add({
//       'Itinerary': itineraryName,
//       'Name': attraction['Name'],
//       'Address': attraction['Address'],
//       'Day': day
//     });
//     notifyListeners();
//   }

//   // remove item from cart
//   void removeItemFromCart(String name) {
//     _cartItems.removeWhere((attraction) => attraction['Name'] == name);
//     notifyListeners();
//   }

//   List filterCartItemsByItinerary(String itineraryName){
//     List filteredCartItems = [];
//     for (int i = 0; i < _cartItems.length; i++) {
//       if (_cartItems[i]['Itinerary'] == itineraryName) {
//         filteredCartItems.add(_cartItems[i]);
//       }
//     }
//     return filteredCartItems;
//   }

//   // calculate total price
//   String calculateTotal() {
//     double totalPrice = 0;
//     for (int i = 0; i < cartItems.length; i++) {
//       totalPrice += double.parse(cartItems[i][1]);
//     }
//     return totalPrice.toStringAsFixed(2);
//   }
// }
