import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/providers/groceries_provider.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nameInput = '';
  int _quantityInput = 1;
  Category _categoryInput = categories[Categories.vegetables]!;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(groceryProvider.notifier).addGrocery(
            GroceryItem(
              id: DateTime.now().toString(),
              name: _nameInput,
              quantity: _quantityInput,
              category: _categoryInput,
            ),
          );
      final url = Uri.https(
          'flutter-28010-default-rtdb.firebaseio.com', 'shopping_list.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _nameInput,
            'quantity': _quantityInput,
            'category': _categoryInput.title,
          },
        ),
      );
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Item name is required!";
                  }
                  if (value.trim().length < 2 || value.trim().length > 50) {
                    return "Item name must be between 2 and 50 caracters.";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _nameInput = newValue!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Item quantity is required!";
                        }
                        if (int.tryParse(value) == null) {
                          return "Item quantity must be a number.";
                        }
                        if (int.tryParse(value)! <= 0) {
                          return "Item quantity must be a positive number.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _quantityInput = int.parse(newValue!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _categoryInput,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: category.value.color,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {},
                      onSaved: (newValue) {
                        _categoryInput = newValue!;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Clear'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
