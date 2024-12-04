import 'package:flutter/material.dart';
import '../../../external_libs/appbar_dropdown/appbar_dropdown.dart';

class DataSummaryScreen extends StatefulWidget {
  const DataSummaryScreen({super.key});

  @override
  State<DataSummaryScreen> createState() => _DataSummaryScreenState();
}

String isCheckboxChecked = "Last 7 days";

class _DataSummaryScreenState extends State<DataSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff727530),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.picture_as_pdf),
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
                child: Text("Last 12 Months"),
                alignment: Alignment.topLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: Align(
                child: Text("(June 23 2023 - June 23 2024)"),
                alignment: Alignment.topLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 8.0,
              ),
              child: Align(
                child: Text("Income", style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),),
                alignment: Alignment.topLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                top: 8.0,
              ),
              child: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rice, 1 number [Badin Field]"),
                    Text("56,000 PKR"),
                  ],
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                top: 8.0,
              ),
              child: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Junaid Aslam"),
                    Text("25,030 PKR"),
                  ],
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                top: 8.0,
              ),
              child: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total:"),
                    Text("81,030 PKR"),
                  ],
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0,),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 8.0,
              ),
              child: Align(
                child: Text("Expense", style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),),
                alignment: Alignment.topLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                top: 8.0,
              ),
              child: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Cutting by Labour"),
                    Text("21,000 PKR"),
                  ],
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                top: 8.0,
              ),
              child: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total:"),
                    Text("21,000 PKR"),
                  ],
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0,),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                top: 8.0,
              ),
              child: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Net:"),
                    Text("17,000 PKR"),
                  ],
                ),
                alignment: Alignment.topLeft,
              ),
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
