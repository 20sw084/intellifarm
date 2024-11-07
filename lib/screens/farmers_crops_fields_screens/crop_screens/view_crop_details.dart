import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/references.dart';
import '../../../providers/crop_provider.dart';
import '../../../util/common_methods.dart';
import '../../../widgets/confirm_delete_crop_dialog.dart';
import '../../activities_screens/plantings/add_planting.dart';
import 'add_crop_variety.dart';
import 'edit_crop_record.dart';

class ViewCropDetails extends StatelessWidget {
  final Map<String, dynamic> dataMap;
  Map<String, dynamic>? firestoreData;

  ViewCropDetails({
    super.key,
    required this.dataMap,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Text(dataMap["Name:"].toString().split(".").last),
            // title: Text(values!.first),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: const Tab(
                    text: 'Details',
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: const Tab(
                    text: 'Varieties',
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: const Tab(
                    text: 'Plantings',
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Details
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Name:",
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              dataMap["Name:"].toString().split(".").last,
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Harvest Unit",
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              dataMap["Harvest Unit:"].toString().split(".").last,
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Varieties",
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              dataMap["Varieties:"],
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Plantings",
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              dataMap["Plantings:"],
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Notes:",
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                dataMap["Notes:"],
                                style: const TextStyle(
                                  fontSize: 12.5,
                                ),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Varieties
              (int.parse(dataMap["Varieties:"]) > 0)
                  ?
              FutureBuilder(
                future: getCropVarietyDataViaFuture(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error is: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    var querySnapshot = snapshot.data;
                    List<DocumentSnapshot> documents = querySnapshot.docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var firestoreData = documents[index].data() as Map<String, dynamic>;
                        String varietyName = firestoreData['varietyName'] ?? '';

                        return FutureBuilder<int>(
                          future: getPlantingsCountBasedOnVariety(varietyName),
                          builder: (context, plantingSnapshot) {
                            int plantingsCount = plantingSnapshot.data ?? 0;
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 220,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Colors.greenAccent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.kayaking),
                                                  const SizedBox(width: 15),
                                                  SizedBox(width: MediaQuery.of(context).size.width * 0.6,child: Text(varietyName, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                                ],
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.more_vert),
                                                onPressed: () {
                                                  showMenu(
                                                    context: context,
                                                    position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                                                    items: const [
                                                      PopupMenuItem(
                                                        value: 1,
                                                        child: Text('Edit Record'),
                                                      ),
                                                      PopupMenuItem(
                                                        value: 2,
                                                        child: Text('Add Planting'),
                                                      ),
                                                      PopupMenuItem(
                                                        value: 3,
                                                        child: Text('Delete'),
                                                      ),
                                                    ],
                                                    elevation: 8.0,
                                                  ).then((value) {
                                                    switch (value) {
                                                      case 1:
                                                        print('Option 1 selected');
                                                        break;
                                                      case 2:
                                                        print('Option 2 selected');
                                                        break;
                                                      case 3:
                                                        print('Option 3 selected');
                                                        break;
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      buildInfoRow("LightProfile:", firestoreData['lightProfile'].toString().split(".").last),
                                      buildInfoRow("Field Type:", firestoreData['fieldType'].toString().split(".").last),
                                      buildInfoRow("Days to Maturity:", firestoreData['daysToMaturity'].toString()),
                                      buildInfoRow("Harvest Window:", firestoreData['harvestWindowDays'].toString()),
                                      buildInfoRow("Plantings:", plantingsCount.toString()), // Display the plantings count here
                                      buildInfoRow("Notes:", firestoreData['notes'].toString()),
                                    ],
                                  ),
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
              )
                  : Container(),
              // Plantings
              (int.parse(dataMap["Plantings:"]) > 0)
                  ? FutureBuilder(
                future: getCropPlantingDataViaFuture(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error is: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    var querySnapshot = snapshot.data;
                    List<DocumentSnapshot> documents = querySnapshot.docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        firestoreData = documents[index].data() as Map<String, dynamic>;
                        // This should be the date retrieved from Firestore as a string
                        final String plantingDateString = firestoreData?['plantingDate'].toString() ?? "2000-01-01";

                        DateTime plantingDate = parseDateString(plantingDateString);
                        int pdAge = calculateAgeInDays(plantingDate);

                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 330,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.greenAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.forest),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.6,child: Text("${dataMap["Name:"].toString().split(".").last} :: ${firestoreData?['varietyName']} (${firestoreData?['fieldName']})", maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                            ],
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.more_vert),
                                            onPressed: () {
                                              showMenu(
                                                context: context,
                                                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                                                items: const [
                                                  PopupMenuItem(
                                                    value: 1,
                                                    child: Text('Edit Record'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 2,
                                                    child: Text('View Report'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 3,
                                                    child: Text('Add Harvest'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 4,
                                                    child: Text('Add Treatment'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 5,
                                                    child: Text('Add Task'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 6,
                                                    child: Text('Duplicate'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 7,
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                                elevation: 8.0,
                                              ).then((value) {
                                                switch (value) {
                                                  case 1:
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => EditCropRecord(),));
                                                    break;
                                                  case 2:
                                                    print('Option 2 selected');
                                                    break;
                                                  case 3:
                                                    print('Option 3 selected');
                                                    break;
                                                  case 4:
                                                    print('Option 4 selected');
                                                    break;
                                                  case 5:
                                                    print('Option 5 selected');
                                                    break;
                                                  case 6:
                                                    print('Option 6 selected');
                                                    break;
                                                  case 7:
                                                    print('Option 7 selected');
                                                    break;
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  buildInfoRow("Status", firestoreData?['plantingType'].toString() ?? " "),
                                  buildInfoRow("Date", firestoreData?['plantingDate'].toString() ?? " "),
                                  buildInfoRow("Age", "$pdAge days"),  // Display the age in days
                                  buildInfoRow("Field", firestoreData?['fieldName'].toString() ?? " "),
                                  buildInfoRow("Crop", dataMap["Name:"].toString().split(".").last),
                                  buildInfoRow("Distance", firestoreData?['distanceBetweenPlants'].toString() ?? " "),
                                  buildInfoRow("Planted", firestoreData?['quantityPlanted'].toString() ?? " "),
                                  buildInfoRow("Estimated", firestoreData?['estimatedYield'].toString() ?? " "),
                                  buildInfoRow("Harvest Date", firestoreData?['harvestDate'].toString() ?? " "),
                                  buildInfoRow("Notes", firestoreData?['notes'].toString() ?? " "),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No data available"));
                  }
                },
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future getCropPlantingDataViaFuture() async{
    References r = References();
    String? id = await r.getLoggedUserId();

    try {
      String? cropId = await r.getCropIdByName(dataMap["Name:"],);
      if (id != null) {
        return await r.usersRef.doc(id).collection("crops").doc(cropId).collection("plantings").get();
      } else {
        print("Error: User ID is null");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<int> getPlantingsCountBasedOnVariety(String varietyName) async {
    References r = References();
    String? id = await r.getLoggedUserId();

    try {
      String? cropId = await r.getCropIdByName(dataMap["Name:"]);
      if (id != null && cropId != null) {
        QuerySnapshot plantingSnapshot = await r.usersRef
            .doc(id)
            .collection("crops")
            .doc(cropId)
            .collection("plantings")
            .where("varietyName", isEqualTo: varietyName)
            .get();

        if (plantingSnapshot.docs.isNotEmpty) {
          return plantingSnapshot.docs.length;
        } else {
          print("Error: No such variety found");
          return 0;
        }
      } else {
        if (kDebugMode) {
          print("Error: User ID or Crop ID is null");
        }
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future getCropVarietyDataViaFuture() async{
    References r = References();
    String? id = await r.getLoggedUserId();

    try {
      String? cropId = await r.getCropIdByName(dataMap["Name:"]);
      if (id != null) {
        return await r.usersRef.doc(id).collection("crops").doc(cropId).collection("varieties").get();
      } else {
        if (kDebugMode) {
          print("Error: User ID is null");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Widget buildInfoRow(String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5)),
        Text(value ?? " ", style: const TextStyle(fontSize: 12.5)),
      ],
    );
  }
}