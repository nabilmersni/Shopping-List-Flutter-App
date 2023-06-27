import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopping_list/models/grocery_item.dart';

class GroceriesNotifier extends StateNotifier<List<GroceryItem>> {
  GroceriesNotifier() : super([]);

  void addGrocery(GroceryItem item) {
    state = [...state, item];
  }

  void deleteGrocery(GroceryItem itemToDel) {
    state = state.where((item) => itemToDel != item).toList();
  }

  void insertGrocery(GroceryItem itemToInsert, int index) {
    var copy = state.map((e) => e).toList();
    copy.insert(index, itemToInsert);
    state = copy;
  }
}

final groceryProvider =
    StateNotifierProvider<GroceriesNotifier, List<GroceryItem>>(
  (ref) => GroceriesNotifier(),
);
