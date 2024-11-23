import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/models/harvest.dart';
import 'package:intellifarm/screens/activities_screens/harvests/add_harvest.dart';
import 'package:intellifarm/screens/activities_screens/harvests/edit_view_harvest.dart';
import 'package:provider/provider.dart';
import '../../../providers/search_provider.dart';
import '../../../util/common_methods.dart';

class HarvestsScreen extends StatefulWidget {
  const HarvestsScreen({super.key});

  @override
  State<HarvestsScreen> createState() => _HarvestsScreenState();
}

String isCheckboxChecked = "Last 7 days";

class _HarvestsScreenState extends State<HarvestsScreen> {
  List<String> keys = [
    "Date:",
    "Field:",
    "Crop:",
    "Quantity:",
    "Batch No:",
    "Quality:",
    "Final:",
    "Rejected:",
    "Unit Cost:",
    "Income:",
    "Notes:"
  ];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff727530),
          foregroundColor: Colors.white,
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
              onPressed: () {},
              icon: Icon(Icons.print),
            ),
            IconButton(
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(50, 50, 0, 0),
                  items: [
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Last 7 days") == 0)
                          ? true
                          : false,
                      value: 1,
                      onTap: () {
                        isCheckboxChecked = "Last 7 days";
                      },
                      child: Text('Last 7 days'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Current Month") == 0)
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
                      child: Text('Previous Month'),
                      value: 3,
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Last 3 Months") == 0)
                          ? true
                          : false,
                      value: 4,
                      onTap: () {
                        isCheckboxChecked = "Last 3 Months";
                      },
                      child: Text('Last 3 Months'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Last 6 Months") == 0)
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
                      checked: (isCheckboxChecked.compareTo("Current Year") == 0)
                          ? true
                          : false,
                      value: 7,
                      onTap: () {
                        isCheckboxChecked = "Current Year";
                      },
                      child: Text('Current Year'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Previous Year") == 0)
                          ? true
                          : false,
                      value: 8,
                      onTap: () {
                        isCheckboxChecked = "Previous Year";
                      },
                      child: Text('Previous Year'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Last 3 Years") == 0)
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
                      checked: (isCheckboxChecked.compareTo("Custom Range") == 0)
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
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => EditFieldRecord(),));
                      break;
                    case 2:
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => AddFieldPlanting(),));
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
                  : const Text("Harvests");
            },
          ),
        ),
        body: FutureBuilder<List<DocumentSnapshot>>(
          future: getAllHarvests(),
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error is: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              List<DocumentSnapshot> harvests = snapshot.data!;
              return Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  // Filter documents based on search query
                  var filteredDocuments = harvests.where((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return data['plantingToHarvest']
                        .toString()
                        .toLowerCase()
                        .contains(searchProvider.searchQuery.toLowerCase());
                  }).toList();
                  return ListView.builder(
                    itemCount: filteredDocuments.length,
                    itemBuilder: (context, index) {
                      var harvestData =
                          filteredDocuments[index].data() as Map<String, dynamic>;
                      Harvest h = Harvest(
                        harvestDate: harvestData["harvestDate"],
                        plantingToHarvest: harvestData["plantingToHarvest"],
                        quantityHarvested: harvestData["quantityHarvested"],
                        finalHarvest: harvestData["finalHarvest"],
                        batchNumber: harvestData["batchNumber"] ?? 0,
                        harvestQuality: harvestData["harvestQuality"] ?? "",
                        quantityRejected: harvestData["quantityRejected"] ?? 0,
                        unitCost: harvestData["unitCost"] ?? 0,
                        incomeFromThisHarvest:
                            harvestData["incomeFromThisHarvest"] ?? 0,
                        notes: harvestData["notes"] ?? "",
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
                                  color: Color(0xff727530),
                                  // foregroundDecoration: ,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.cut,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: Text(
                                                h.plantingToHarvest!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              showMenu(
                                                context: context,
                                                position: RelativeRect.fromLTRB(
                                                    100, 100, 0, 0),
                                                items: [
                                                  PopupMenuItem(
                                                    child: Text('Edit Record'),
                                                    value: 1,
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text(
                                                        'View Planting Record'),
                                                    value: 2,
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text('Duplicate'),
                                                    value: 3,
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text('Delete'),
                                                    value: 4,
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
                                                              EditViewActivityHarvest(
                                                            harvest: h,
                                                          ),
                                                        ));
                                                    break;
                                                  case 2:
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //       builder: (context) =>
                                                    //           EditPlanting(),
                                                    //     ));
                                                    break;
                                                  case 3:
                                                    print('Option 3 selected');
                                                    break;
                                                  case 4:
                                                    print('Option 4 selected');
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
                                      h.harvestDate!,
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
                                      h.plantingToHarvest!.split("|").last.trim(),
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
                                      "${h.plantingToHarvest!.split("|").first.trim()} (${h.plantingToHarvest!.split("|")[1].trim()})",
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
                                      h.quantityHarvested.toString(),
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
                                      h.batchNumber.toString(),
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
                                      h.harvestQuality!,
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
                                      h.finalHarvest!,
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
                                      h.quantityRejected.toString(),
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
                                      h.unitCost.toString(),
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
                                      h.incomeFromThisHarvest.toString(),
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
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddActivityHarvest(),
                ));
          },
          backgroundColor: Color(0xff727530),
          foregroundColor: Colors.white,
          icon: Icon(Icons.add),
          label: Text('Add'),
          tooltip: 'Add', // Tooltip text
        ),
      ),
    );
  }
}
