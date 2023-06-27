import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';

import 'package:shopping_list/providers/groceries_provider.dart';
import 'package:shopping_list/screens/add_item_screen.dart';

class GroceriesScreen extends ConsumerStatefulWidget {
  const GroceriesScreen({super.key});

  @override
  ConsumerState<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends ConsumerState<GroceriesScreen> {
  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  void _addItem() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddItemScreen(),
      ),
    );
  }

  void _loadItem() async {
    final url = Uri.https(
        'flutter-28010-default-rtdb.firebaseio.com', 'shopping_list.json');
    final response = await http.get(url);
    final Map<String, dynamic> loadedData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in loadedData.entries) {
      final category = categories.entries.firstWhere(
        (catItem) => catItem.value.title == item.value['category'],
      );
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category.value,
        ),
      );
    }
    ref.read(groceryProvider.notifier).loadgrocery(loadedItems);
  }

  @override
  Widget build(BuildContext context) {
    final groceriesItem = ref.watch(groceryProvider);

    Widget mainContent = groceriesItem.isEmpty
        ? const Center(
            child: Text(
              'Ow!  There is no groceries found',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        : ListView.builder(
            itemCount: groceriesItem.length,
            itemBuilder: (ctx, index) => Dismissible(
              direction: DismissDirection.endToStart,
              key: ObjectKey(groceriesItem[index]),
              background: Container(
                decoration: BoxDecoration(
                  color: const Color(0xfffc5185),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
              onDismissed: (direction) {
                ref
                    .read(groceryProvider.notifier)
                    .deleteGrocery(groceriesItem[index]);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('grocery deleted'),
                    action: SnackBarAction(
                      label: 'Cancel',
                      onPressed: () {
                        ref
                            .read(groceryProvider.notifier)
                            .insertGrocery(groceriesItem[index], index);
                      },
                    ),
                  ),
                );
              },
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {},
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: groceriesItem[index].category.color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                title: Text(
                  groceriesItem[index].name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: Text(
                  groceriesItem[index].quantity.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: mainContent,
    );
  }
}
