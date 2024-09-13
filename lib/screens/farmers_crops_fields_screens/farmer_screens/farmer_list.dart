import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/controller/references.dart';
import 'package:intellifarm/screens/farmers_crops_fields_screens/farmer_screens/add_farmer_record.dart';
import 'package:intellifarm/widgets/list_details_card_farmer.dart';

class FarmersList extends StatefulWidget {
  const FarmersList({super.key});

  @override
  State<FarmersList> createState() => _FarmersListState();
}
// TODO: Only Linked farmers can save the receipt in DB
// TODO: setstate htana h jo ke search functionality ki wja se aya h

class _FarmersListState extends State<FarmersList> {
  bool searchFlag = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  searchFlag = !searchFlag;
                });
              //   Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => const SearchPage(),
              //   ),
              // );
              },
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
          title: searchFlag ? Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        /* Clear the search field */
                        setState(() {
                          searchFlag = !searchFlag;
                        });
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            ),
          ) : Text("Farmer List"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder(
            future: getFarmersData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error is: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                var querySnapshot = snapshot.data as QuerySnapshot;
                List<DocumentSnapshot> documents = querySnapshot.docs.toList();
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;
                    var id = documents[index].id;
                    return ListDetailsCardFarmer(
                      farmerId: id,
                      dataMap: {
                        "Name:" : data['name'].toString(),
                        "Phone Number:" : data['phoneNumber'].toString(),
                        "C-NIC Number:" : data['cnic'].toString(),
                        "Unique Code:" : data['loginCode'].toString(),
                        "Crop Planting Id:" : data['cropPlantingId'],
                      },
                      onTap: () {
                        // Your onTap logic
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
          icon: Icon(Icons.add),
          label: Text('Add'),
          tooltip: 'Add', // Tooltip text
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
