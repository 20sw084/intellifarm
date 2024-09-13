import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/controller/references.dart';
import '../util/common_methods.dart';

class ListDetailsCardFarmer extends StatelessWidget {
  final String farmerId;
  final Map<String, dynamic> dataMap;
  final dynamic onTap;

  ListDetailsCardFarmer({
    super.key,
    required this.dataMap,
    required this.farmerId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 160,
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name:", style: TextStyle(fontSize: 13)),
                            Text("Phone Number:",
                                style: TextStyle(fontSize: 13)),
                            Text("C-NIC Number:",
                                style: TextStyle(fontSize: 13)),
                            Text("Unique Code:",
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dataMap["Name:"],
                                style: TextStyle(fontSize: 13)),
                            Text(dataMap["Phone Number:"],
                                style: TextStyle(fontSize: 13)),
                            Text(dataMap["C-NIC Number:"],
                                style: TextStyle(fontSize: 13)),
                            Text(dataMap["Unique Code:"],
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(100, 100, 0, 0),
                              items: [
                                PopupMenuItem(
                                    child: Text('Link with CropPlanting!'),
                                    value: 1),
                                PopupMenuItem(
                                    child: Text('Edit Record'), value: 2),
                                PopupMenuItem(
                                    child: Text('Print PDF'), value: 3),
                                PopupMenuItem(child: Text('Delete'), value: 4),
                              ],
                              elevation: 8.0,
                            ).then((value) async {
                              switch (value) {
                                case 1:
                                  // Show dialog with CircularProgressIndicator while fetching data
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      ScrollController scrollController =
                                          ScrollController();

                                      return AlertDialog(
                                        title: Text(
                                            'Select a Crop Planting to Link'),
                                        content: FutureBuilder<
                                            List<DocumentSnapshot>>(
                                          future: getNonLinkedPlantings(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  CircularProgressIndicator(),
                                                  SizedBox(height: 16),
                                                  Text("Finding..."),
                                                ],
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  "Error: ${snapshot.error}");
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return Text(
                                                  "No non-linked crop plantings found.");
                                            } else {
                                              List<DocumentSnapshot>
                                                  nonLinkedPlantings =
                                                  snapshot.data!;
                                              return SizedBox(
                                                width: double.maxFinite,
                                                child: SizedBox(
                                                  height: 150,
                                                  child: Scrollbar(
                                                    thumbVisibility: true,
                                                    controller:
                                                        scrollController,
                                                    child: ListView.builder(
                                                      controller:
                                                          scrollController,
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          nonLinkedPlantings
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        DocumentSnapshot
                                                            planting =
                                                            nonLinkedPlantings[
                                                                index];
                                                        String plantingName =
                                                            "${planting['cropName']} | ${planting['varietyName']} | ${planting['fieldName']} | ${planting['plantingDate']}";

                                                        return ListTile(
                                                          title: Text(
                                                              plantingName),
                                                          onTap: () {
                                                            linkFarmerToCropPlanting(
                                                                farmerId,
                                                                planting.id);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  );
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
                              }
                            });
                          },
                          icon: Icon(Icons.more_vert),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (dataMap["Crop Planting Id:"] != null &&
                      dataMap["Crop Planting Id:"].isNotEmpty)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "This farmer is already linked with cropPlantingID of ${dataMap["cropPlantingId"]}",
                        style: TextStyle(fontSize: 11.5),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> getNonLinkedPlantings() async {
    List<DocumentSnapshot> allPlantings = await getAllPlantings();
    QuerySnapshot farmersSnapshot =
        await FirebaseFirestore.instance.collection('farmers').get();
    List<String?> linkedPlantingIds = farmersSnapshot.docs
        .map((farmer) => farmer['cropPlantingId'] as String?)
        .where((id) => id != null)
        .toList();

    List<DocumentSnapshot> nonLinkedPlantings = allPlantings
        .where((planting) => !linkedPlantingIds.contains(planting.id))
        .toList();

    return nonLinkedPlantings;
  }

  void linkFarmerToCropPlanting(String farmerId, String cropPlantingId) {
    FirebaseFirestore.instance.collection('farmers').doc(farmerId).update({
      'cropPlantingId': cropPlantingId,
    }).then((_) async {
      References r = References();
      String? userId = await r.getLoggedUserId();
      FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("farmers")
          .doc(farmerId)
          .update({
        'cropPlantingId': cropPlantingId,
      }).then((_) {
        print("Farmer linked to crop planting successfully!");
      }).catchError((error) {
        print("Failed to link farmer: $error");
      });
    }).catchError((error) {
      print("Failed to link farmer: $error");
    });
  }
}
