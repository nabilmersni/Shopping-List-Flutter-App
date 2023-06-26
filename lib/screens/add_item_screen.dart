import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value.isNull || value!.isEmpty) {
                    return "Item name is required!";
                  }
                  if (value.trim().length <= 2 || value.trim().length > 50) {
                    return "Item name must be between 2 and 50 caracters.";
                  }
                  return null;
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
                        if (value.isNull || value!.isEmpty) {
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
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
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
                    onPressed: () {},
                    child: const Text('Clear'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
