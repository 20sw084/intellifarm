import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intellifarm/controller/references.dart';
import 'package:intellifarm/screens/farmers_crops_fields_screens/farmer_screens/add_farmer_record.dart';
import 'package:intellifarm/widgets/list_details_card_farmer.dart';
import '../../../providers/search_provider.dart';

class FarmersList extends StatelessWidget {
  const FarmersList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            actions: [
              Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  return IconButton(
                    onPressed: () {
                      searchProvider.toggleSearch();
                    },
                    icon: Icon(searchProvider.searchFlag ? Icons.close : Icons.search),
                  );
                },
              ),
              const IconButton(
                onPressed: null,
                icon: Icon(Icons.remove_red_eye_sharp),
              ),
              const IconButton(
                onPressed: null,
                icon: Icon(Icons.print),
              ),
            ],
            title: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
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
                      onChanged: (value) {
                        searchProvider.updateSearchQuery(value);
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchProvider.clearSearch();
                          },
                        ),
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                )
                    : const Text("Farmer List");
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FutureBuilder(
              future: getFarmersData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  var querySnapshot = snapshot.data as QuerySnapshot;
                  List<DocumentSnapshot> documents = querySnapshot.docs.toList();

                  return Consumer<SearchProvider>(
                    builder: (context, searchProvider, child) {
                      // Filter documents based on search query
                      var filteredDocuments = documents.where((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        return data['name']
                            .toString()
                            .toLowerCase()
                            .contains(searchProvider.searchQuery.toLowerCase());
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredDocuments.length,
                        itemBuilder: (context, index) {
                          var data = filteredDocuments[index].data() as Map<String, dynamic>;
                          var id = filteredDocuments[index].id;
                          return ListDetailsCardFarmer(
                            farmerId: id,
                            dataMap: {
                              "Name:": data['name'].toString(),
                              "Phone Number:": data['phoneNumber'].toString(),
                              "C-NIC Number:": data['cnic'].toString(),
                              "Unique Code:": data['loginCode'].toString(),
                              "Share Rule:": data['shareRule'].toString().split(".").last,
                              "Crop Planting Id:": data['cropPlantingId'],
                            },
                            onTap: () {
                              // Your onTap logic
                            },
                          );
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
                MaterialPageRoute(
                  builder: (context) => AddFarmerRecord(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add'),
            tooltip: 'Add',
          ),
        ),
      ),
    );
  }

  Future<dynamic> getFarmersData() async {
    References r = References();
    String? id = await r.getLoggedUserId();
    QuerySnapshot farmersSnapshot = await r.usersRef.doc(id).collection("farmers").get();
    return farmersSnapshot;
  }
}
