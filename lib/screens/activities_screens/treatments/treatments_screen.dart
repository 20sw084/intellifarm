import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/models/treatment.dart';
import 'package:intellifarm/screens/activities_screens/treatments/add_activity_treatment.dart';
import 'package:provider/provider.dart';
import '../../../providers/search_provider.dart';
import '../../../util/common_methods.dart';
import 'edit_activity_treatment.dart';

class TreatmentsScreen extends StatelessWidget {
  TreatmentsScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  List<String> keys = [
    "Date:",
    "Status:",
    "Field:",
    "Planting:",
    "Product:",
    "Quantity:",
    "Notes:"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    value: 3,
                    child: Text('Previous Month'),
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
                  PopupMenuItem(
                    value: 2,
                    onTap: () {
                      // isCheckboxChecked = "Custom Range";
                    },
                    child: Text('Treatment Type'),
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
                  case 3:
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
                : const Text("Treatments");
          },
        ),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future:
            getAllTreatments(), // Use the function that returns List<DocumentSnapshot>
        builder: (BuildContext context,
            AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error is: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<DocumentSnapshot> treatments = snapshot.data!;
            return Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                // Filter documents based on search query
                var filteredDocuments = treatments.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return data['treatmentType']
                      .toString()
                      .toLowerCase()
                      .contains(searchProvider.searchQuery.toLowerCase());
                }).toList();
                return ListView.builder(
                  itemCount: filteredDocuments.length,
                  itemBuilder: (context, index) {
                    var treatmentData =
                        filteredDocuments[index].data() as Map<String, dynamic>;
                    Treatment t = Treatment(
                      treatmentDate: treatmentData["treatmentDate"],
                      treatmentStatus: treatmentStatusFromString(
                          treatmentData["treatmentStatus"]),
                      treatmentType: treatmentTypeFromString(
                          treatmentData["treatmentType"]),
                      fieldName: treatmentData["fieldName"],
                      treatmentSpecificToPlanting:
                          treatmentSpecificToPlantingFromString(
                              treatmentData["treatmentSpecificToPlanting"]),
                      plantingName: treatmentData["plantingName"] ?? " ",
                      productUsed: treatmentData["productUsed"] ?? " ",
                      quantityOfProduct:
                          treatmentData["quantityOfProduct"] ?? 0,
                      notes: treatmentData["notes"] ?? "",
                    );
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 246,
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
                                          Icon(Icons
                                              .transfer_within_a_station_sharp),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(t.treatmentType
                                              .toString()
                                              .split(".")
                                              .last),
                                        ],
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.more_vert),
                                          onPressed: () {
                                            showMenu(
                                              context: context,
                                              position: RelativeRect.fromLTRB(
                                                  100, 100, 0, 0),
                                              items: [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Text('Edit Record'),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: Text('Mark as Done'),
                                                ),
                                                PopupMenuItem(
                                                  value: 3,
                                                  child: Text('Duplicate'),
                                                ),
                                                PopupMenuItem(
                                                  value: 4,
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
                                                            EditActivityTreatment(
                                                          treatment: t,
                                                        ),
                                                      ));
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
                                    t.treatmentDate,
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
                                    t.treatmentStatus
                                        .toString()
                                        .split(".")
                                        .last,
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
                                    t.fieldName,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                              t.plantingName!.isEmpty
                                  ? Container()
                                  : Row(
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
                                          t.plantingName ?? " ",
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
                                    t.productUsed ?? " ",
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
                                    t.quantityOfProduct.toString(),
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
                                    t.notes ?? " ",
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
                builder: (context) => AddActivityTreatment(),
              ));
          print('Button pressed!');
        },
        icon: Icon(Icons.add),
        label: Text('Add'),
        tooltip: 'Add', // Tooltip text
      ),
    );
  }
}

// TODO : MARK AS Done is hardcoded rn.

String isCheckboxChecked = "Last 7 days";
