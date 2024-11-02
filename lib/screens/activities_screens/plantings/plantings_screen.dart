import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/models/crops/cropPlanting.dart';
import 'package:intellifarm/screens/activities_screens/harvests/add_harvest.dart';
import 'package:intellifarm/screens/activities_screens/plantings/edit_planting.dart';
import 'package:intellifarm/screens/activities_screens/plantings/view_receipts.dart';
import 'package:intellifarm/screens/activities_screens/plantings/view_status.dart';
import 'package:provider/provider.dart';
import '../../../providers/search_provider.dart';
import '../../../util/common_methods.dart';
import '../tasks/add_activity_task.dart';
import '../treatments/add_activity_treatment.dart';
import 'add_planting.dart';

class PlantingsScreen extends StatelessWidget {
  PlantingsScreen({super.key});

  List<String> keys = [
    "Status:",
    "Date:",
    "Age:",
    "Field:",
    "Crop:",
    "Distance:",
    "Planted:",
    "Estimated:",
    "Harvest Date:",
    "Notes:"
  ];

  String cropName = "";

  late CropPlanting cr;

  final TextEditingController _searchController = TextEditingController();

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
                    icon: Icon(
                        searchProvider.searchFlag ? Icons.close : Icons.search),
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(50, 50, 0, 0),
                    items: [
                      CheckedPopupMenuItem(
                        checked:
                            (isCheckboxChecked.compareTo("Last 7 days") == 0)
                                ? true
                                : false,
                        value: 1,
                        onTap: () {
                          isCheckboxChecked = "Last 7 days";
                        },
                        child: Text('Last 7 days'),
                      ),
                      CheckedPopupMenuItem(
                        checked:
                            (isCheckboxChecked.compareTo("Current Month") == 0)
                                ? true
                                : false,
                        value: 2,
                        onTap: () {
                          isCheckboxChecked = "Current Month";
                        },
                        child: Text('Current Month'),
                      ),
                      CheckedPopupMenuItem(
                        checked:
                            (isCheckboxChecked.compareTo("Previous Month") == 0)
                                ? true
                                : false,
                        onTap: () {
                          isCheckboxChecked = "Previous Month";
                        },
                        value: 3,
                        child: Text('Previous Month'),
                      ),
                      CheckedPopupMenuItem(
                        checked:
                            (isCheckboxChecked.compareTo("Last 3 Months") == 0)
                                ? true
                                : false,
                        value: 4,
                        onTap: () {
                          isCheckboxChecked = "Last 3 Months";
                        },
                        child: Text('Last 3 Months'),
                      ),
                      CheckedPopupMenuItem(
                        checked:
                            (isCheckboxChecked.compareTo("Last 6 Months") == 0)
                                ? true
                                : false,
                        value: 5,
                        onTap: () {
                          isCheckboxChecked = "Last 6 Months";
                        },
                        child: Text('Last 6 Months'),
                      ),
                      CheckedPopupMenuItem(
                        checked:
                            (isCheckboxChecked.compareTo("Last 12 Months") == 0)
                                ? true
                                : false,
                        value: 6,
                        onTap: () {
                          isCheckboxChecked = "Last 12 Months";
                        },
                        child: Text('Last 12 Months'),
                      ),
                      CheckedPopupMenuItem(
                        checked:
                            (isCheckboxChecked.compareTo("Current Year") == 0)
                                ? true
                                : false,
                        value: 7,
                        onTap: () {
                          isCheckboxChecked = "Current Year";
                        },
                        child: Text('Current Year'),
                      ),
                      CheckedPopupMenuItem(
                        checked:
                            (isCheckboxChecked.compareTo("Previous Year") == 0)
                                ? true
                                : false,
                        value: 8,
                        onTap: () {
                          isCheckboxChecked = "Previous Year";
                        },
                        child: Text('Previous Year'),
                      ),
                      CheckedPopupMenuItem(
                        checked:
                            (isCheckboxChecked.compareTo("Last 3 Years") == 0)
                                ? true
                                : false,
                        value: 9,
                        onTap: () {
                          isCheckboxChecked = "Last 3 Years";
                        },
                        child: Text('Last 3 Years'),
                      ),
                      CheckedPopupMenuItem(
                        checked: (isCheckboxChecked.compareTo("All Time") == 0)
                            ? true
                            : false,
                        value: 10,
                        onTap: () {
                          isCheckboxChecked = "All Time";
                        },
                        child: Text('All Time'),
                      ),
                      CheckedPopupMenuItem(
                        checked:
                            (isCheckboxChecked.compareTo("Custom Range") == 0)
                                ? true
                                : false,
                        value: 11,
                        onTap: () {
                          isCheckboxChecked = "Custom Range";
                        },
                        child: Text('Custom Range'),
                      ),
                    ],
                    // Handle the selected menu item
                    elevation: 8.0,
                  ).then((value) {
                    // Handle the selected value
                    switch (value) {
                      case 1:
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => EditPlanting(),));
                        break;
                      case 2:
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => AddPlanting(cropName: cropName,),));
                        break;
                      case 3:
                        // TODO: Print PDF Implementation
                        break;
                      case 4:
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return ConfirmDeleteFieldDialog(
                        //       onConfirm: () {
                        //         // TODO: Perform delete operation here
                        //         print('Item deleted!');
                        //       },
                        //     );
                        //   },
                        // );
                        break;
                    }
                  });
                },
                icon: Icon(Icons.filter_list_outlined),
              ),
              IconButton(
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(50, 50, 0, 0),
                    items: [
                      PopupMenuItem(
                        value: 1,
                        onTap: () {
                          // isCheckboxChecked = "Last 7 days";
                        },
                        child: Text('Print PDF'),
                      ),
                      PopupMenuItem(
                        value: 2,
                        onTap: () {
                          // isCheckboxChecked = "Custom Range";
                        },
                        child: Text('Status'),
                      ),
                    ],
                    // Handle the selected menu item
                    elevation: 8.0,
                  ).then((value) {
                    // Handle the selected value
                    switch (value) {
                      case 1:
                        // TODO: Print PDF Implementation
                        break;
                      case 2:
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return ConfirmDeleteFieldDialog(
                        //       onConfirm: () {
                        //         // TODO: Perform delete operation here
                        //         print('Item deleted!');
                        //       },
                        //     );
                        //   },
                        // );
                        break;
                    }
                  });
                },
                icon: Icon(
                  Icons.more_vert,
                ),
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
                    : const Text("Plantings");
              },
            ),
          ),
          body: FutureBuilder<List<DocumentSnapshot>>(
            future:
                getAllPlantings(), // Use the function that returns List<DocumentSnapshot>
            builder: (BuildContext context,
                AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error is: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                List<DocumentSnapshot> plantings = snapshot.data!;
                return Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) {
                    // Filter documents based on search query
                    var filteredDocuments = plantings.where((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return data['cropName']
                          .toString()
                          .toLowerCase()
                          .contains(searchProvider.searchQuery.toLowerCase());
                    }).toList();
                    return ListView.builder(
                      itemCount: filteredDocuments.length,
                      itemBuilder: (context, index) {
                        var plantingData =
                        filteredDocuments[index].data() as Map<String, dynamic>;
                        cropName = plantingData["cropName"];
                        String plantingId = plantings[index].id;
                        final String plantingDateString =
                            plantingData['plantingDate'].toString();
                        DateTime plantingDate =
                            parseDateString(plantingDateString);
                        int pdAge = calculateAgeInDays(plantingDate);
                        cr = CropPlanting(
                          plantingDate: plantingData["plantingDate"],
                          plantingType: plantingTypeFromString(
                              plantingData["plantingType"]),
                          cropName: plantingData["cropName"],
                          varietyName: plantingData["varietyName"],
                          fieldName: plantingData["fieldName"],
                          quantityPlanted: plantingData["quantityPlanted"],
                          notes: plantingData["notes"],
                          distanceBetweenPlants:
                              plantingData["distanceBetweenPlants"],
                          estimatedYield: plantingData["estimatedYield"],
                          firstHarvestDate: plantingData["firstHarvestDate"],
                          seedCompany: plantingData["seedCompany"],
                          seedLotNumber: plantingData["seedLotNumber"],
                          seedOrigin: plantingData["seedOrigin"],
                          seedType: plantingData["seedType"],
                        );
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 325,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.forest),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  "${plantingData["cropName"]} ${plantingData['varietyName']} (${plantingData['fieldName']})",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.more_vert),
                                              onPressed: () {
                                                showMenu(
                                                  context: context,
                                                  position:
                                                      RelativeRect.fromLTRB(
                                                          100, 100, 0, 0),
                                                  items: [
                                                    PopupMenuItem(
                                                      value: 1,
                                                      child:
                                                          Text('Edit Record'),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 2,
                                                      child:
                                                          Text('View Report'),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 3,
                                                      child:
                                                          Text('Add Harvest'),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 4,
                                                      child:
                                                          Text('Add Treatment'),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 5,
                                                      child: Text('Add Task'),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 6,
                                                      child:
                                                          Text('View Receipts'),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 7,
                                                      child:
                                                          Text('View Status'),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 8,
                                                      child: Text('Duplicate'),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 9,
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                  elevation: 8.0,
                                                ).then((value) {
                                                  switch (value) {
                                                    case 1:
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditPlanting(
                                                                    cropPlanting:
                                                                        cr),
                                                          ));
                                                      break;
                                                    case 2:
                                                      print(
                                                          'Option 2: View Report: selected');
                                                      break;
                                                    case 3:
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddActivityHarvest(),
                                                          ));
                                                      break;
                                                    case 4:
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddActivityTreatment(),
                                                          ));
                                                      break;
                                                    case 5:
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddActivityTask(),
                                                          ));
                                                      break;
                                                    case 6:
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewReceipts(
                                                                    plantingId:
                                                                        plantingId),
                                                          ));
                                                      break;
                                                    case 7:
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewStatus(
                                                                    plantingId:
                                                                        plantingId),
                                                          ));
                                                      break;
                                                    case 8:
                                                      print(
                                                          'Option 8: Duplicate selected');
                                                      break;
                                                    case 9:
                                                      print(
                                                          'Option 9: Delete: selected');
                                                      break;
                                                  }
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        keys.elementAt(0),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      Text(
                                        plantingData["plantingType"],
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        keys.elementAt(1),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      Text(
                                        plantingData["plantingDate"],
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        keys.elementAt(2),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      Text(
                                        "$pdAge days",
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        keys.elementAt(3),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      Text(
                                        plantingData["fieldName"],
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        keys.elementAt(4),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      Text(
                                        "${plantingData["cropName"]} (${plantingData["varietyName"]}) ",
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        keys.elementAt(5),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      Text(
                                        plantingData["distanceBetweenPlants"],
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        keys.elementAt(6),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      Text(
                                        plantingData["quantityPlanted"]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        keys.elementAt(7),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      Text(
                                        plantingData["estimatedYield"]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        keys.elementAt(8),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      Text(
                                        plantingData["firstHarvestDate"],
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        keys.elementAt(9),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      Text(
                                        plantingData["notes"],
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
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(child: Text("No plantings available"));
              }
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Add your onPressed action here
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPlanting(
                      cropName: cropName,
                    ),
                  ));
              print('Button pressed!');
            },
            icon: Icon(Icons.add),
            label: Text('Add'),
            tooltip: 'Add', // Tooltip text
          ),
        ),
      ),
    );
  }
}

String isCheckboxChecked = "Last 7 days";
