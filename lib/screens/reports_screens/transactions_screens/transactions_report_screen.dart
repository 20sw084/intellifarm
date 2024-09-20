import 'package:flutter/material.dart';
import 'package:intellifarm/screens/reports_screens/transactions_screens/data_summary_screen.dart';
import '../../../external_libs/appbar_dropdown/appbar_dropdown.dart';
import '../../../external_libs/pie_chart/src/chart_values_options.dart';
import '../../../external_libs/pie_chart/src/legend_options.dart';
import '../../../external_libs/pie_chart/src/pie_chart.dart';
import 'dart:math' as math;

import '../../../util/common_methods.dart';

class TransactionsReportScreen extends StatefulWidget {
  const TransactionsReportScreen({super.key});

  @override
  State<TransactionsReportScreen> createState() =>
      _TransactionsReportScreenState();
}

enum LegendShape { circle, rectangle }

String isCheckboxChecked = "Last 7 days";

class _TransactionsReportScreenState extends State<TransactionsReportScreen> {
  // Async method to get income and expense data
  Future<Map<String, double>> getDataMap() async {
    double income = await getTotalIncomeCost(); // Fetch the total income cost
    double expense = await getTotalExpenseCost(); // Fetch the total expense cost
    // double total = income + expense;
    //
    // // Avoid division by zero
    // if (total == 0) {
    //   return {
    //     "Income": 0,
    //     "Expense": 0,
    //   };
    // }
    //
    // // Calculate percentages
    // double incomePercentage = (income / total) * 100;
    // double expensePercentage = (expense / total) * 100;
    return {
      "Income": income,
      "Expense": expense,
    };
  }


  final legendLabels = <String, String>{
    "Income": "Income legend",
    "Expense": "Expense legend",
  };

  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];

  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ]
  ];
  ChartType? _chartType = ChartType.disc;
  bool _showCenterText = true;
  bool _showCenterWidget = true;
  double? _ringStrokeWidth = 32;
  double? _chartLegendSpacing = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = true;
  bool _showLegendLabel = false;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  bool _showGradientColors = false;

  LegendShape? _legendShape = LegendShape.circle;
  LegendPosition? _legendPosition = LegendPosition.right;

  int key = 0;

  @override
  Widget build(BuildContext context) {
    // final chart = PieChart(
    //   key: ValueKey(key),
    //   dataMap: dataMap,
    //   animationDuration: const Duration(milliseconds: 800),
    //   chartLegendSpacing: _chartLegendSpacing!,
    //   chartRadius: math.min(MediaQuery.of(context).size.width / 3.2, 300),
    //   colorList: colorList,
    //   initialAngleInDegree: 0,
    //   chartType: _chartType!,
    //   centerText: _showCenterText ? "HYBRID" : null,
    //   centerWidget: _showCenterWidget
    //       ? Container(color: Colors.red, child: const Text("Center"))
    //       : null,
    //   legendLabels: _showLegendLabel ? legendLabels : {},
    //   legendOptions: LegendOptions(
    //     showLegendsInRow: _showLegendsInRow,
    //     legendPosition: _legendPosition!,
    //     showLegends: _showLegends,
    //     legendShape: _legendShape == LegendShape.circle
    //         ? BoxShape.circle
    //         : BoxShape.rectangle,
    //     legendTextStyle: const TextStyle(
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    //   chartValuesOptions: ChartValuesOptions(
    //     showChartValueBackground: _showChartValueBackground,
    //     showChartValues: _showChartValues,
    //     showChartValuesInPercentage: _showChartValuesInPercentage,
    //     showChartValuesOutside: _showChartValuesOutside,
    //   ),
    //   ringStrokeWidth: _ringStrokeWidth!,
    //   emptyColor: Colors.grey,
    //   gradientList: _showGradientColors ? gradientList : null,
    //   emptyColorGradient: const [
    //     Color(0xff6c5ce7),
    //     Colors.blue,
    //   ],
    //   baseChartColor: Colors.transparent,
    // );
    final settings = SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(12),
        child: Column(
          children: [
            SwitchListTile(
              value: _showGradientColors,
              title: const Text("Show Gradient Colors"),
              onChanged: (val) {
                setState(() {
                  _showGradientColors = val;
                });
              },
            ),
            ListTile(
              title: Text(
                'Pie Chart Options'.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: const Text("chartType"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<ChartType>(
                  value: _chartType,
                  items: const [
                    DropdownMenuItem(
                      value: ChartType.disc,
                      child: Text("disc"),
                    ),
                    DropdownMenuItem(
                      value: ChartType.ring,
                      child: Text("ring"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _chartType = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text("ringStrokeWidth"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<double>(
                  value: _ringStrokeWidth,
                  disabledHint: const Text("select chartType.ring"),
                  items: const [
                    DropdownMenuItem(
                      value: 16,
                      child: Text("16"),
                    ),
                    DropdownMenuItem(
                      value: 32,
                      child: Text("32"),
                    ),
                    DropdownMenuItem(
                      value: 48,
                      child: Text("48"),
                    ),
                  ],
                  onChanged: (_chartType == ChartType.ring)
                      ? (val) {
                          setState(() {
                            _ringStrokeWidth = val;
                          });
                        }
                      : null,
                ),
              ),
            ),
            SwitchListTile(
              value: _showCenterText,
              title: const Text("showCenterText (Deprecated)"),
              onChanged: (val) {
                setState(() {
                  _showCenterText = val;
                });
              },
            ),
            SwitchListTile(
              value: _showCenterWidget,
              title: const Text("showCenterWidget"),
              onChanged: (val) {
                setState(() {
                  _showCenterWidget = val;
                });
              },
            ),
            ListTile(
              title: const Text("chartLegendSpacing"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<double>(
                  value: _chartLegendSpacing,
                  disabledHint: const Text("select chartType.ring"),
                  items: const [
                    DropdownMenuItem(
                      value: 16,
                      child: Text("16"),
                    ),
                    DropdownMenuItem(
                      value: 32,
                      child: Text("32"),
                    ),
                    DropdownMenuItem(
                      value: 48,
                      child: Text("48"),
                    ),
                    DropdownMenuItem(
                      value: 64,
                      child: Text("64"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _chartLegendSpacing = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Legend Options'.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SwitchListTile(
              value: _showLegends,
              title: const Text("showLegends"),
              onChanged: (val) {
                setState(() {
                  _showLegends = val;
                });
              },
            ),
            SwitchListTile(
              value: _showLegendsInRow,
              title: const Text("showLegendsInRow"),
              onChanged: (val) {
                setState(() {
                  _showLegendsInRow = val;
                });
              },
            ),
            SwitchListTile(
              value: _showLegendLabel,
              title: const Text("showLegendLabels"),
              onChanged: (val) {
                setState(() {
                  _showLegendLabel = val;
                });
              },
            ),
            ListTile(
              title: const Text("legendShape"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<LegendShape>(
                  value: _legendShape,
                  items: const [
                    DropdownMenuItem(
                      value: LegendShape.circle,
                      child: Text("BoxShape.circle"),
                    ),
                    DropdownMenuItem(
                      value: LegendShape.rectangle,
                      child: Text("BoxShape.rectangle"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _legendShape = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text("legendPosition"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<LegendPosition>(
                  value: _legendPosition,
                  items: const [
                    DropdownMenuItem(
                      value: LegendPosition.left,
                      child: Text("left"),
                    ),
                    DropdownMenuItem(
                      value: LegendPosition.right,
                      child: Text("right"),
                    ),
                    DropdownMenuItem(
                      value: LegendPosition.top,
                      child: Text("top"),
                    ),
                    DropdownMenuItem(
                      value: LegendPosition.bottom,
                      child: Text("bottom"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _legendPosition = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Chart values Options'.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SwitchListTile(
              value: _showChartValueBackground,
              title: const Text("showChartValueBackground"),
              onChanged: (val) {
                setState(() {
                  _showChartValueBackground = val;
                });
              },
            ),
            SwitchListTile(
              value: _showChartValues,
              title: const Text("showChartValues"),
              onChanged: (val) {
                setState(() {
                  _showChartValues = val;
                });
              },
            ),
            SwitchListTile(
              value: _showChartValuesInPercentage,
              title: const Text("showChartValuesInPercentage"),
              onChanged: (val) {
                setState(() {
                  _showChartValuesInPercentage = val;
                });
              },
            ),
            SwitchListTile(
              value: _showChartValuesOutside,
              title: const Text("showChartValuesOutside"),
              onChanged: (val) {
                setState(() {
                  _showChartValuesOutside = val;
                });
              },
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        actions: [
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
          dropdownAppBarColor: Colors.greenAccent,
        ),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(8.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.4,
                color: Colors.greenAccent,
                child: TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(Icons.abc),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Line Chart'),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.4,
                color: Colors.greenAccent,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataSummaryScreen(),
                        ));
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.abc),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Data Summary'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 8.0,
              top: 8.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("Last 12 Months"),
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
              child: Text("(June 23 2023 - June 23 2024)"),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder<Map<String, double>>(
              future: getDataMap(), // Fetch data asynchronously (Income and Expense)
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Loading indicator
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}')); // Handle errors
                } else if (snapshot.hasData) {
                  // Once the data is available, display the PieChart and other widgets
                  final dataMap = snapshot.data!;
                  final income = dataMap['Income']!;
                  final expense = dataMap['Expense']!;
                  final net = income - expense; // Calculate net cost dynamically

                  double total = income + expense;

                  // Calculate percentages
                  double incomePercentage = (income / total) * 100;
                  double expensePercentage = (expense / total) * 100;

                  final map = {
                    "Income": incomePercentage,
                    "Expense": expensePercentage,
                  };

                  return Column(
                    children: [
                      // Pie Chart
                      PieChart(
                        dataMap: map,
                        chartType: ChartType.ring,
                        baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                        colorList: colorList,
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: true,
                        ),
                        totalValue: incomePercentage + expensePercentage, // Set total as the sum of income and expense
                      ),
                      // Income Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Income:"),
                              Text("${income.toStringAsFixed(2)} PKR"), // Display the fetched income
                            ],
                          ),
                        ),
                      ),
                      // Expense Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Expense:"),
                              Text("${expense.toStringAsFixed(2)} PKR"), // Display the fetched expense
                            ],
                          ),
                        ),
                      ),
                      // Net Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Net:"),
                              Text("${net.toStringAsFixed(2)} PKR"), // Display the calculated net
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Text("No data available")); // No data scenario
                }
              },
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

class TestData {
  final String title;

  TestData(this.title);
}
