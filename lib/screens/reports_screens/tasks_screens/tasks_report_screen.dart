import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/screens/reports_screens/tasks_screens/tasks_report_pdf.dart';
import '../../../external_libs/appbar_dropdown/appbar_dropdown.dart';
import '../../../models/task.dart';
import '../../../util/common_methods.dart';

class TasksReportScreen extends StatefulWidget {
  const TasksReportScreen({super.key});

  @override
  State<TasksReportScreen> createState() => _TasksReportScreenState();
}

enum LegendShape { circle, rectangle }

String isCheckboxChecked = "Last 7 days";

List<DocumentSnapshot> reportData = [];

class _TasksReportScreenState extends State<TasksReportScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff727530),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () async {
                final TasksReportPdf reportGenerator = TasksReportPdf();
                final pdfBytes = await reportGenerator.generateReport(reportData);
                final path = await reportGenerator.savePdf(pdfBytes, 'tasks_report');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('PDF saved at $path')),
                );
              },
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
          ],
          // title: DropdownButton(
          //   items: [],
          //   onChanged: (Object? value) {  },
          //
          // ),
          // Text("All Fields"),
          flexibleSpace: AppbarDropdown<TestData>(
            items: [for (var i = 0; i < 5; i++) TestData("Field $i")],
            selected: TestData("Field 2"),
            title: ((user) => user.title),
            // ignore: avoid_print
            onClick: ((user) => print(user.title)),
            dropdownAppBarColor: Color(0xff727530),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 8.0,
                top: 8.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Last 3 Months"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("(March 23 2024 - June 23 2024)"),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Color(0xff727530),
                height: 30,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Tasks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff727530),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff727530),
                          ),
                        ),
                        SizedBox(
                          width:
                          MediaQuery.of(context).size.width * 0.20,
                        ),
                        Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff727530),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Field',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff727530),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder<List<DocumentSnapshot>>(
              future: getAllTasks(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error is: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  List<DocumentSnapshot> tasks = snapshot.data!;
                  reportData = tasks;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        var tasksData = tasks[index].data() as Map<String, dynamic>;
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
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff727530),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      t.taskDate,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff727530),
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width * 0.06,
                                    ),
                                    Text(
                                      t.taskName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // color: Color(0xff727530),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  t.fieldName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // color: Color(0xff727530),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text("No plantings available"));
                }
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class TestData {
  final String title;

  TestData(this.title);
}
