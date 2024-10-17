import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/screens/farmers_crops_fields_screens/field_screens/view_field_details.dart';
import 'package:intellifarm/util/common_methods.dart';
import 'package:provider/provider.dart';
import '../../../controller/references.dart';
import '../../../widgets/list_details_cart_field.dart';
import 'add_field_record.dart';
import '../../../providers/search_provider.dart'; // Import your search provider

class FieldList extends StatefulWidget {
  const FieldList({super.key});

  @override
  State<FieldList> createState() => _FieldListState();
}

class _FieldListState extends State<FieldList> {
  final TextEditingController searchController = TextEditingController();
  References r = References();
  List<DocumentSnapshot> matchedPlantingsList = [];

  @override
  void initState() {
    super.initState();
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchController.addListener(() {
      searchProvider.updateSearchQuery(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          actions: [
            IconButton(
              onPressed: searchProvider.toggleSearch,
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.remove_red_eye_sharp),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.print),
            ),
          ],
          title: searchProvider.searchFlag
              ? Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchProvider.clearSearch();
                      searchController.clear();
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            ),
          )
              : Text("Field List"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder<QuerySnapshot>(
            future: getFieldsData(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                List<DocumentSnapshot> documents = snapshot.data!.docs
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
                          return CircularProgressIndicator();
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
                              "Plantings List:": matchedPlantingsList,
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
                                      "Plantings List:": matchedPlantingsList,
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
              } else {
                return const Center(child: Text("No data available"));
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddFieldRecord()),
            );
          },
          icon: Icon(Icons.add),
          label: Text('Add'),
          tooltip: 'Add',
        ),
      ),
    );
  }

  Future<QuerySnapshot> getFieldsData() async {
    String? id = await r.getLoggedUserId();
    return r.usersRef.doc(id).collection("fields").get();
  }

  Future<int> getPlantingsCountRelatedToField(String fieldName) async {
    String? id = await r.getLoggedUserId();
    QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();

    int count = 0;

    for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
      QuerySnapshot plantingsSnapshot = await cropDoc.reference
          .collection("plantings")
          .where('fieldName', isEqualTo: fieldName)
          .get();

      count += plantingsSnapshot.size;
      matchedPlantingsList.addAll(plantingsSnapshot.docs);
    }

    return count;
  }
}
