import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopping_list/models/grocery_item.dart';

class GroceriesNotifier extends StateNotifier<List<GroceryItem>> {
  GroceriesNotifier() : super([]);

  void addGrocery(GroceryItem item) {
    state = [...state, item];
  }
}

final groceryProvider =
    StateNotifierProvider<GroceriesNotifier, List<GroceryItem>>(
  (ref) => GroceriesNotifier(),
);
