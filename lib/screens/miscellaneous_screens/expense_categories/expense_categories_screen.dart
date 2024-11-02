import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../controller/references.dart';

class ExpenseCategoriesScreen extends StatefulWidget {
  const ExpenseCategoriesScreen({Key? key}) : super(key: key);

  @override
  _ExpenseCategoriesScreenState createState() => _ExpenseCategoriesScreenState();
}

class _ExpenseCategoriesScreenState extends State<ExpenseCategoriesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addExpenseCategory(String categoryName) async {
    try {
      References r = References();
      String? id = await r.getLoggedUserId();
      await _firestore.collection('users/$id/expenseCategories').add({
        'categoryName': categoryName,
      });
    } catch (e) {
      print('Error adding expense category: $e');
    }
  }

  Future<List<QueryDocumentSnapshot>> fetchExpenseCategories() async {
    try {
      References r = References();
      String? id = await r.getLoggedUserId();
      final snapshot = await FirebaseFirestore.instance
          .collection('users/$id/expenseCategories')
          .get();
      return snapshot.docs; // Returning the list of documents
    } catch (e) {
      print('Error fetching expense categories: $e');
      return [];
    }
  }

  void _showAddCategoryDialog() {
    String categoryName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Category'),
          content: TextField(
            onChanged: (value) {
              categoryName = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter expense category name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryName.isNotEmpty) {
                  _addExpenseCategory(categoryName);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: const Text('Expense Categories'),
        ),
        body: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: fetchExpenseCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('There is no Expense categories as of yet.'),
                    Text('Tap the "+" to create a new Expense Category.'),
                  ],
                ),
              );
            }
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var category = categories[index];
                return ListTile(
                  title: Text(category['categoryName'] ?? 'Unnamed Category'),
                  trailing: IconButton(
                    onPressed: () {
                      // TODO: Delete Category has to be implemented here.
                    },
                    icon: Icon(
                      Icons.more_vert,
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddCategoryDialog,
          icon: const Icon(Icons.add),
          label: const Text('Add'),
          tooltip: 'Add',
        ),
      ),
    );
  }
}
