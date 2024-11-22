import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intellifarm/screens/farmers_crops_fields_screens/field_screens/view_field_details.dart';
import '../../../controller/references.dart';
import '../../../widgets/list_details_card_field.dart';
import 'add_field_record.dart';
import '../../../providers/search_provider.dart';
import '../../../providers/field_provider.dart';

class FieldList extends StatelessWidget {
  FieldList({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff727530),
          foregroundColor: Colors.white,
          actions: [
            Consumer<SearchProvider>(
              builder: (context, searchProvider, _) => IconButton(
                onPressed: () {
                  searchProvider.toggleSearch();
                },
                icon: Icon(
                    searchProvider.searchFlag ? Icons.close : Icons.search),
              ),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.remove_red_eye_sharp, color: Colors.white,),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.print, color: Colors.white),
            ),
          ],
          title: Consumer<SearchProvider>(
            builder: (context, searchProvider, _) {
              return searchProvider.searchFlag
                  ? Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      searchProvider.updateSearchQuery(value);
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchProvider.clearSearch();
                          _searchController.clear();
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
                  : const Text("Field List");
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Consumer<FieldProvider>(
            builder: (context, fieldProvider, _) {
              if (fieldProvider.needsRefresh) {
                fieldProvider.fetchFieldsData();
              }
              if (fieldProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (fieldProvider.errorMessage.isNotEmpty) {
                return Center(child: Text("Error: ${fieldProvider.errorMessage}"));
              } else {
                var documents = fieldProvider.fields
                    .where((doc) => (doc.data() as Map<String, dynamic>)['name']
                    .toString()
                    .toLowerCase()
                    .contains(searchProvider.searchQuery.toLowerCase()))
                    .toList();
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;
                    return FutureBuilder<int>(
                      future: getPlantingsCountRelatedToField(data['name'].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          int plantingsCount = snapshot.data ?? 0;
                          return ListDetailsCardField(
                            dataMap: {
                              "Name:": data['name'].toString(),
                              "Field Type:": data['fieldType'],
                              "Light Profile:": data['lightProfile'],
                              "Field Status:": data['fieldStatus'],
                              "Size of Field:": data['sizeOfField'].toString(),
                              "Notes:": data['notes'].toString(),
                              "Plantings:": plantingsCount.toString(),
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewFieldDetails(
                                    dataMap: {
                                      "Name:": data['name'].toString(),
                                      "Field Type:": data['fieldType'].toString(),
                                      "Light Profile:": data['lightProfile'].toString(),
                                      "Field Status:": data['fieldStatus'].toString(),
                                      "Size of Field:": data['sizeOfField'].toString(),
                                      "Notes:": data['notes'].toString(),
                                      "Plantings:": plantingsCount.toString(),
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddFieldRecord()),
            ).then((_) {
              Provider.of<FieldProvider>(context, listen: false).needsRefresh = true;
            });
          },
          backgroundColor: Color(0xff727530),
          foregroundColor: Colors.white,
          icon: Icon(Icons.add),
          label: Text('Add'),
          tooltip: 'Add',
        ),
      ),
    );
  }

  Future<int> getPlantingsCountRelatedToField(String fieldName) async {
    References r = References();
    String? id = await r.getLoggedUserId();
    QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();

    int count = 0;

    for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
      QuerySnapshot plantingsSnapshot = await cropDoc.reference
          .collection("plantings")
          .where('fieldName', isEqualTo: fieldName)
          .get();

      count += plantingsSnapshot.size;
    }

    return count;
  }
}