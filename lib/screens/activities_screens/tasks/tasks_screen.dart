import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../models/task.dart';
import '../../../util/common_methods.dart';
import 'add_activity_task.dart';
import 'edit_activity_task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

String isCheckboxChecked = "Last 7 days";

class _TasksScreenState extends State<TasksScreen> {
  bool searchFlag = false;

  List<String> keys = ["Date:", "Status:", "Field:", "Planting:", "Notes:"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Text('Previous Month'),
                    value: 10,
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
        title: searchFlag
            ? Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
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
              )
            : Text("Tasks"),
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
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var tasksData = tasks[index].data() as Map<String, dynamic>;
                Task t = Task(
                  taskDate: tasksData["taskDate"],
                  taskStatus: taskStatusFromString(tasksData["taskStatus"]),
                  taskName: tasksData["taskName"],
                  fieldName: tasksData["fieldName"],
                  taskSpecificToPlanting: taskSpecificToPlantingFromString(tasksData["taskSpecificToPlanting"]),
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
                          color: Colors.greenAccent,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.task),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(t.taskName),
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
                                            child: Text('Edit Record'),
                                            value: 1,
                                          ),
                                          PopupMenuItem(
                                            child: Text('Mark as Done'),
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
                                                      EditActivityTask(task: t,),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
        icon: Icon(Icons.add),
        label: Text('Add'),
        tooltip: 'Add', // Tooltip text
      ),
    );
  }
}
