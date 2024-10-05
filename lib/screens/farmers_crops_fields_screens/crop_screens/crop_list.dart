import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/controller/references.dart';
import 'package:intellifarm/screens/farmers_crops_fields_screens/crop_screens/view_crop_details.dart';
import '../../../widgets/list_details_card_crop.dart';
import 'add_crop_record.dart';

class CropList extends StatefulWidget {
  const CropList({super.key});

  @override
  State<CropList> createState() => _CropListState();
}

class _CropListState extends State<CropList> {
  bool searchFlag = false;
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();
  References r = References();
  List<int>? plantings;
  List<int>? varieties;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
                  if (!searchFlag) {
                    searchQuery = '';
                    searchController.clear();
                  }
                });
              },
              icon: Icon(searchFlag ? Icons.close : Icons.search),
            ),
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.print),
            ),
          ],
          title: searchFlag
              ? Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        searchQuery = '';
                      });
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            ),
          )
              : const Text("Crop List"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder(
            future: getCropsPlantingsAndVarietiesData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error is: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                var querySnapshot = snapshot.data[0];
                List<DocumentSnapshot> documents = querySnapshot.docs
                    .where((doc) => (doc.data() as Map<String, dynamic>)['name']
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                    .toList();
                List<int> plantingsCountList = snapshot.data[1];
                List<int> varietiesCountList = snapshot.data[2];
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;
                    return ListDetailsCardCrop(
                      dataMap: {
                        "Name:" : data['name'].toString().split(".").last,
                        "Harvest Unit:" : data['harvestUnit'].toString().split(".").last,
                        "Varieties:" : varietiesCountList[index].toString(),
                        "Plantings:" : plantingsCountList[index].toString(),
                        "Notes:" : data['notes'].toString(),
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewCropDetails(
                              dataMap: {
                                "Name:": data['name'].toString(),
                                "Harvest Unit:": data['harvestUnit'].toString(),
                                "Varieties:": varietiesCountList[index].toString(),
                                "Plantings:": plantingsCountList[index].toString(),
                                "Notes:": data['notes'].toString(),
                              },
                            ),
                          ),
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
                builder: (context) => AddCropRecord(),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add'),
          tooltip: 'Add',
        ),
      ),
    );
  }

  Future<List<dynamic>> getCropsPlantingsAndVarietiesData() async {
    String? id = await r.getLoggedUserId();
    QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();

    List<int> plantingsCountList = [];
    List<int> varietiesCountList = [];

    for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
      QuerySnapshot plantingsSnapshot = await cropDoc.reference.collection("plantings").get();
      QuerySnapshot varietiesSnapshot = await cropDoc.reference.collection("varieties").get();
      plantingsCountList.add(plantingsSnapshot.size);
      varietiesCountList.add(varietiesSnapshot.size);
    }

    plantings = plantingsCountList;
    varieties = varietiesCountList;

    return [cropsSnapshot, plantingsCountList, varietiesCountList];
  }
}
