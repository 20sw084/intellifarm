import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/widgets/confirm_delete_field_dialog.dart';
import '../../../controller/references.dart';
import '../../../models/fields/field.dart';
import '../../../util/common_methods.dart';
import 'add_field_planting.dart';
import 'edit_field_record.dart';


class ViewFieldDetails extends StatelessWidget {
  final Map<String, dynamic> dataMap;
  List<DocumentSnapshot> matchedPlantingsList = [];

  ViewFieldDetails({
    super.key,
    required this.dataMap,
  });

  @override
  Widget build(BuildContext context) {
    Field fieldObject = Field(
      name: dataMap["Name:"],
      fieldType: fieldTypeFromString(dataMap["Field Type:"]),
      lightProfile: lightProfileFromString(dataMap["Light Profile:"]),
      fieldStatus: fieldStatusFromString(dataMap["Field Status:"]),
      sizeOfField: int.tryParse(dataMap["Size of Field:"]),
      notes: dataMap["Notes:"],
    );
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff727530),
            foregroundColor: Colors.white,
            title: Text(dataMap["Name:"]),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: Tab(
                    text: 'Details',
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Tab(
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
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              dataMap["Name:"],
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Light Profile:",
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              dataMap["Light Profile:"],
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Field Type:",
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              dataMap["Field Type:"],
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Status:",
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              dataMap["Field Status:"],
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Field Size:",
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              dataMap["Size of Field:"],
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Plantings:",
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              dataMap["Plantings:"],
                              style: TextStyle(
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
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              dataMap["Notes:"],
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Plantings
              (int.parse(dataMap["Plantings:"]) > 0)
                  ? FutureBuilder<List<DocumentSnapshot>>(
                future: getPlantingsRelatedToField(dataMap["Name:"]),
                builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error is: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    List<DocumentSnapshot> documents = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var firestoreData = documents[index].data() as Map<String, dynamic>;
                        // This should be the date retrieved from Firestore as a string
                        final String plantingDateString = firestoreData['plantingDate'].toString();

                        // Parsing the date string
                        DateTime parseDateString(String dateString) {
                          try {
                            return DateTime.parse(dateString);
                          } catch (e) {
                            print("Error parsing date: $e");
                            return DateTime(2000, 1, 1); // Default to a safe date
                          }
                        }

                        // Calculating age in days
                        int calculateAgeInDays(DateTime plantingDate) {
                          DateTime today = DateTime.now();
                          Duration difference = today.difference(plantingDate);
                          return difference.inDays;
                        }

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
                                    color: Color(0xff727530),
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
                                              Text("${dataMap["Name:"]} ${firestoreData['varietyName']} (Field)"),
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
                                  buildInfoRow("Status", firestoreData['plantingType'].toString()),
                                  buildInfoRow("Date", firestoreData['plantingDate'].toString()),
                                  buildInfoRow("Age", "$pdAge days"), // Display the age in days
                                  buildInfoRow("Field", dataMap["Name:"]),
                                  buildInfoRow("Crop", firestoreData["cropName"]),
                                  buildInfoRow("Distance", firestoreData['distanceBetweenPlants'].toString()),
                                  buildInfoRow("Planted", firestoreData['quantityPlanted'].toString()),
                                  buildInfoRow("Estimated", firestoreData['estimatedYield'].toString()),
                                  buildInfoRow("Harvest Date", firestoreData['firstHarvestDate'].toString()),
                                  buildInfoRow("Notes", firestoreData['notes'].toString()),
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

  Widget buildInfoRow(String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5)),
        Text(value ?? " ", style: const TextStyle(fontSize: 12.5)),
      ],
    );
  }

  Future<List<QueryDocumentSnapshot>> getPlantingsRelatedToField(String fieldName) async {
    References r = References();
    String? id = await r.getLoggedUserId();
    QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();

    List<QueryDocumentSnapshot> matchedPlantingsList = [];

    for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
      // Query the plantings collection where the field matches the given fieldName
      QuerySnapshot plantingsSnapshot = await cropDoc.reference
          .collection("plantings")
          .where('fieldName', isEqualTo: fieldName)
          .get();

      // Add the matched plantings to the external list
      matchedPlantingsList.addAll(plantingsSnapshot.docs);
    }

    return matchedPlantingsList;
  }


}
