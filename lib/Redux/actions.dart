import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:redux/redux.dart';

class AddItemAction {
  final CartModel item;

  AddItemAction(this.item);
}

class RemoveItemAction {
  final String name;

  const RemoveItemAction(this.name);
}

class FilterItemAction {
  final String itineraryName;

  const FilterItemAction(this.itineraryName);
}

class ViewModel {
  final List<CartModel> cartItems;
  final Function(CartModel) onItemAdded;
  final Function(String) onItemRemoved;
  final Function(String) onItemFiltered;

  ViewModel({
    this.cartItems = const [],
    this.onItemAdded = _noopFunction,
    this.onItemRemoved = _noopFunction,
    this.onItemFiltered = _noopFunction,
  });

    // No-op function that does nothing
  static void _noopFunction(_) {}

  factory ViewModel.create(Store<List<CartModel>> store) {
    onItemAdded(CartModel item) {
      print("in add item action");
      store.dispatch(AddItemAction(item));
    }

    onItemRemoved(String name) {
      print("in remove item action");
      store.dispatch(RemoveItemAction(name));
    }

    onItemFiltered(String itineraryName) {
      store.dispatch(FilterItemAction(itineraryName));
    }

    return ViewModel(
      onItemAdded: onItemAdded,
      onItemRemoved: onItemRemoved,
      onItemFiltered: onItemFiltered,
      cartItems: store.state,
    );
  }
}
