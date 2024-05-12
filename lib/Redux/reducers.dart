import 'package:my_tourist_app/Redux/actions.dart';
import 'package:my_tourist_app/Model/cart_model.dart';

// Define actions
enum CartAction { addItem, removeItem }

// Define reducer
List<CartModel> cartReducer(List<CartModel> cartItems, dynamic action) {
  if (action is AddItemAction) {
    return addItemToCart(cartItems, action);
  } else if (action is RemoveItemAction) {
    return removeItemFromCart(cartItems, action);
  }
  else if (action is FilterItemAction) {
    return filterCartItemsByItinerary(cartItems, action);
  }
  return cartItems;
}

List<CartModel> addItemToCart(List<CartModel> items, AddItemAction action) {
  // Do not add item if it already exists in the cart
  for (int i = 0; i < items.length; i++) {
    if (items[i].name == action.item.name) {
      return items;
    }
  }
  return List.from(items)..add(action.item);
}

// remove item from cart
List<CartModel> removeItemFromCart(
    List<CartModel> items, RemoveItemAction action) {
  return List.from(items)..removeWhere((item) => item.name == action.name);
}

List<CartModel> filterCartItemsByItinerary(List<CartModel> items, FilterItemAction action) {
  List<CartModel> filteredCartItems = [];
  for (int i = 0; i < items.length; i++) {
    if (items[i].itinerary == action.itineraryName) {
      filteredCartItems.add(items[i]);
    }
  }
  return filteredCartItems;
}
