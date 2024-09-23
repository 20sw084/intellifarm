import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/util/common_methods.dart';
import 'dart:math' as math;
import '../../../controller/references.dart';
import '../../../external_libs/appbar_dropdown/appbar_dropdown.dart';
import '../../../external_libs/pie_chart/src/chart_values_options.dart';
import '../../../external_libs/pie_chart/src/legend_options.dart';
import '../../../external_libs/pie_chart/src/pie_chart.dart';
import '../../../models/crops/cropPlanting.dart';
import 'field_status_report_pdf.dart';

class FieldStatusReportScreen extends StatefulWidget {
  const FieldStatusReportScreen({super.key});

  @override
  State<FieldStatusReportScreen> createState() =>
      _FieldStatusReportScreenState();
}

enum LegendShape { circle, rectangle }

class _FieldStatusReportScreenState extends State<FieldStatusReportScreen> {

  var dataMap = <String, double>{
    "Available": 4,
    "FullyCultivated": 3,
    "PartiallyCultivated": 3,
  };

  List<DocumentSnapshot> reportData = [];

  Future<Map<String, double>> populateDataMap() async {
    return await getFieldStatusCount();  // This function returns the field status counts
  }

  final legendLabels = <String, String>{
    "Available": "Available",
    "FullyCultivated": "FullyCultivated",
    "PartiallyCultivated": "PartiallyCultivated",
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
    final chart = PieChart(
      key: ValueKey(key),
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: _chartLegendSpacing!,
      chartRadius: math.min(MediaQuery.of(context).size.width / 3.2, 300),
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: _chartType!,
      centerText: _showCenterText ? "HYBRID" : null,
      centerWidget: _showCenterWidget
          ? Container(color: Colors.red, child: const Text("Center"))
          : null,
      legendLabels: _showLegendLabel ? legendLabels : {},
      legendOptions: LegendOptions(
        showLegendsInRow: _showLegendsInRow,
        legendPosition: _legendPosition!,
        showLegends: _showLegends,
        legendShape: _legendShape == LegendShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        legendTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: _showChartValueBackground,
        showChartValues: _showChartValues,
        showChartValuesInPercentage: _showChartValuesInPercentage,
        showChartValuesOutside: _showChartValuesOutside,
      ),
      ringStrokeWidth: _ringStrokeWidth!,
      emptyColor: Colors.grey,
      gradientList: _showGradientColors ? gradientList : null,
      emptyColorGradient: const [
        Color(0xff6c5ce7),
        Colors.blue,
      ],
      baseChartColor: Colors.transparent,
    );
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          actions: [
            IconButton(
              onPressed: () async {
                final FieldStatusReportPdf reportGenerator = FieldStatusReportPdf();
                final pdfBytes = await reportGenerator.generateReport(reportData);
                final path = await reportGenerator.savePdf(pdfBytes, 'crop_planting_report');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('PDF saved at $path')),
                );
              },
              icon: Icon(Icons.print),
            ),
          ],
          // title: DropdownButton(
          //   items: [],
          //   onChanged: (Object? value) {  },
          //
          // ),
          // Text("All Fields"),
          flexibleSpace: AppbarDropdown<TestData>(
            items: [for (var i = 0; i < 5; i++) TestData("Crop $i")],
            selected: TestData("Crop 2"),
            title: ((user) => user.title),
            // ignore: avoid_print
            onClick: ((user) => print(user.title)),
            dropdownAppBarColor: Colors.greenAccent,
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
                child: Text(
                  "Field by Status",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(),
            ),
            SizedBox(
              height: 15,
            ),
            FutureBuilder<Map<String, double>>(
              future: populateDataMap(), // The function that returns the field status counts
              builder: (BuildContext context, AsyncSnapshot<Map<String, double>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error is: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final dataMap = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PieChart(
                      dataMap: dataMap, // Use the dataMap from the Future
                      chartType: ChartType.ring,
                      baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                      colorList: colorList,
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValuesInPercentage: true,
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text("No Pie Chart available"));
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.greenAccent,
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
                          'Field',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.20,
                        ),
                        Text(
                          'Crop',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                    IntrinsicWidth(
                      child: Column(
                        children: const [
                          Text(
                            'Planting',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                            ),
                          ),
                          Divider(
                            color: Colors.greenAccent,
                            thickness: 2.0,
                          ),
                          Text(
                            'Harvest',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder<List<DocumentSnapshot>>(
              future: getAllPlantings(),
              builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error is: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  List<DocumentSnapshot> plantings = snapshot.data!;
                  reportData = plantings;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: plantings.length,
                      itemBuilder: (context, index) {
                        var plantingData = plantings[index].data() as Map<String, dynamic>;
                        // String cropName = plantingData["cropName"];
                        // String plantingId = plantings[index].id;
                        // final String plantingDateString =
                        //     plantingData['plantingDate'].toString() ?? "2000-01-01";
                        // DateTime plantingDate = parseDateString(plantingDateString);
                        // int pdAge = calculateAgeInDays(plantingDate);
                        CropPlanting cr = CropPlanting(
                          plantingDate: plantingData["plantingDate"],
                          plantingType: plantingTypeFromString(plantingData["plantingType"]),
                          cropName: plantingData["cropName"],
                          varietyName: plantingData["varietyName"],
                          fieldName: plantingData["fieldName"],
                          quantityPlanted: plantingData["quantityPlanted"],
                          notes: plantingData["notes"],
                          distanceBetweenPlants: plantingData["distanceBetweenPlants"],
                          estimatedYield: plantingData["estimatedYield"],
                          firstHarvestDate: plantingData["firstHarvestDate"],
                          seedCompany: plantingData["seedCompany"],
                          seedLotNumber: plantingData["seedLotNumber"],
                          seedOrigin: plantingData["seedOrigin"],
                          seedType: plantingData["seedType"],
                        );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.greenAccent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          cr.fieldName!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.greenAccent,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                                      Expanded(
                                        child: Text(
                                          "${cr.cropName}, ${cr.varietyName}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: const [
                                      Text(
                                        'Mar 17, 2024',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.greenAccent,
                                        thickness: 2.0,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Nov 22, 2024 -',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orangeAccent,
                                            ),
                                          ),
                                          Text(
                                            'Jan 01, 2025',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orangeAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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

  Future<Map<String, double>> getFieldStatusCount() async {
    References r = References();
    String? userId = await r.getLoggedUserId();

    if (userId == null) {
      throw Exception("User not logged in");
    }

    // Fetch all the field documents from Firestore
    QuerySnapshot fieldSnapshot = await r.usersRef.doc(userId).collection("fields").get();

    // Initialize counters for the field statuses
    int availableCount = 0;
    int cultivatedCount = 0;
    int partiallyCultivatedCount = 0;

    // Iterate over each document and check its 'fieldStatus'
    for (var fieldDoc in fieldSnapshot.docs) {
      String fieldStatus = fieldDoc.get('fieldStatus');

      // Increment counters based on fieldStatus
      if (fieldStatus == "Available") {
        availableCount++;
      } else if (fieldStatus == "FullyCultivated") {
        cultivatedCount++;
      } else if (fieldStatus == "PartiallyCultivated") {
        partiallyCultivatedCount++;
      }
    }

    // Return the data as a map
    return {
      "Available": availableCount.toDouble(),
      "FullyCultivated": cultivatedCount.toDouble(),
      "PartiallyCultivated": partiallyCultivatedCount.toDouble(),
    };
  }

}

class TestData {
  final String title;

  TestData(this.title);
}
