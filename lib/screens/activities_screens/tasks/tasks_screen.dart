import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/task.dart';
import '../../../providers/search_provider.dart';
import '../../../util/common_methods.dart';
import 'add_activity_task.dart';
import 'edit_activity_task.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({super.key});

  List<String> keys = ["Date:", "Status:", "Field:", "Planting:", "Notes:"];

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
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(50, 50, 0, 0),
                  items: [
                    PopupMenuItem(
                      value: 1,
                      onTap: () {
                        isCheckboxChecked = "Upcoming";
                      },
                      child: Text('Upcoming'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Due today") == 0)
                          ? true
                          : false,
                      value: 2,
                      onTap: () {
                        isCheckboxChecked = "Due today";
                      },
                      child: Text('Due today'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Due in 2 days") == 0)
                          ? true
                          : false,
                      value: 3,
                      onTap: () {
                        isCheckboxChecked = "Due in 2 days";
                      },
                      child: Text('Due in 2 days'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Due in 7 days") == 0)
                          ? true
                          : false,
                      value: 4,
                      onTap: () {
                        isCheckboxChecked = "Due in 7 days";
                      },
                      child: Text('Due in 7 days'),
                    ),
                    CheckedPopupMenuItem(
                      checked:
                          (isCheckboxChecked.compareTo("Due in 14 days") == 0)
                              ? true
                              : false,
                      value: 5,
                      onTap: () {
                        isCheckboxChecked = "Due in 14 days";
                      },
                      child: Text('Due in 14 days'),
                    ),
                    CheckedPopupMenuItem(
                      checked:
                          (isCheckboxChecked.compareTo("Due in 21 days") == 0)
                              ? true
                              : false,
                      value: 6,
                      onTap: () {
                        isCheckboxChecked = "Due in 21 days";
                      },
                      child: Text('Due in 21 days'),
                    ),
                    PopupMenuItem(
                      value: 7,
                      onTap: () {
                        isCheckboxChecked = "Past";
                      },
                      child: Text('Past'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Last 7 days") == 0)
                          ? true
                          : false,
                      value: 8,
                      onTap: () {
                        isCheckboxChecked = "Last 7 days";
                      },
                      child: Text('Last 7 days'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Current Month") == 0)
                          ? true
                          : false,
                      value: 9,
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
                      value: 10,
                      child: Text('Previous Month'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Last 3 Months") == 0)
                          ? true
                          : false,
                      value: 11,
                      onTap: () {
                        isCheckboxChecked = "Last 3 Months";
                      },
                      child: Text('Last 3 Months'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Last 6 Months") == 0)
                          ? true
                          : false,
                      value: 12,
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
                      value: 13,
                      onTap: () {
                        isCheckboxChecked = "Last 12 Months";
                      },
                      child: Text('Last 12 Months'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Current Year") == 0)
                          ? true
                          : false,
                      value: 14,
                      onTap: () {
                        isCheckboxChecked = "Current Year";
                      },
                      child: Text('Current Year'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Previous Year") == 0)
                          ? true
                          : false,
                      value: 15,
                      onTap: () {
                        isCheckboxChecked = "Previous Year";
                      },
                      child: Text('Previous Year'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Last 3 Years") == 0)
                          ? true
                          : false,
                      value: 16,
                      onTap: () {
                        isCheckboxChecked = "Last 3 Years";
                      },
                      child: Text('Last 3 Years'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("All Time") == 0)
                          ? true
                          : false,
                      value: 17,
                      onTap: () {
                        isCheckboxChecked = "All Time";
                      },
                      child: Text('All Time'),
                    ),
                    CheckedPopupMenuItem(
                      checked: (isCheckboxChecked.compareTo("Custom Range") == 0)
                          ? true
                          : false,
                      value: 18,
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
                  : const Text("Tasks");
            },
          ),
        ),
        body: FutureBuilder<List<DocumentSnapshot>>(
          future: getAllTasks(),
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error is: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              List<DocumentSnapshot> tasks = snapshot.data!;
              return Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  // Filter documents based on search query
                  var filteredDocuments = tasks.where((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return data['taskName']
                        .toString()
                        .toLowerCase()
                        .contains(searchProvider.searchQuery.toLowerCase());
                  }).toList();
                  return ListView.builder(
                    itemCount: filteredDocuments.length,
                    itemBuilder: (context, index) {
                      var tasksData =
                          filteredDocuments[index].data() as Map<String, dynamic>;
                      Task t = Task(
                        taskDate: tasksData["taskDate"],
                        taskStatus: taskStatusFromString(tasksData["taskStatus"]),
                        taskName: tasksData["taskName"],
                        fieldName: tasksData["fieldName"],
                        taskSpecificToPlanting: taskSpecificToPlantingFromString(
                            tasksData["taskSpecificToPlanting"]),
                        plantingName: tasksData["plantingName"] ?? " ",
                        notes: tasksData["notes"] ?? "",
                      );
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 195,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.task, color: Colors.white,),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(t.taskName, style: TextStyle(color: Colors.white),),
                                          ],
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.more_vert, color: Colors.white,),
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
                                                              EditActivityTask(
                                                            task: t,
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
                                      t.taskDate,
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
                                      t.taskStatus.toString().split(".").last,
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
                                      t.plantingName.toString(),
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
                                      t.notes.toString(),
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
                  builder: (context) => AddActivityTask(),
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

String isCheckboxChecked = "Last 7 days";
