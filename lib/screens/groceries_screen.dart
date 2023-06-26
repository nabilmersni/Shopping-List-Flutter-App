import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/screens/add_item_screen.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  void addItem() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddItemScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your groceries'),
        actions: [
          IconButton(
            onPressed: addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          onTap: () {},
          leading: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: groceryItems[index].category.color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          title: Text(
            groceryItems[index].name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: Text(
            groceryItems[index].quantity.toString(),
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
