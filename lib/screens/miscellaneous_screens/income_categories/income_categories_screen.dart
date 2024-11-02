import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../controller/references.dart';

class IncomeCategoriesScreen extends StatefulWidget {
  const IncomeCategoriesScreen({Key? key}) : super(key: key);

  @override
  _IncomeCategoriesScreenState createState() => _IncomeCategoriesScreenState();
}

class _IncomeCategoriesScreenState extends State<IncomeCategoriesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addIncomeCategory(String categoryName) async {
    try {
      References r = References();
      String? id = await r.getLoggedUserId();
      await _firestore.collection('users/$id/incomeCategories').add({
        'categoryName': categoryName,
      });
    } catch (e) {
      print('Error adding income category: $e');
    }
  }

  Future<List<QueryDocumentSnapshot>> fetchIncomeCategories() async {
    try {
      References r = References();
      String? id = await r.getLoggedUserId();
      final snapshot = await FirebaseFirestore.instance
          .collection('users/$id/incomeCategories')
          .get();
      return snapshot.docs; // Returning the list of documents
    } catch (e) {
      print('Error fetching income categories: $e');
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
              hintText: 'Enter income category name',
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
                  _addIncomeCategory(categoryName);
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
          title: const Text('Income Categories'),
        ),
        body: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: fetchIncomeCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('There is no Income categories as of yet.'),
                    Text('Tap the "+" to create a new Income Category.'),
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
