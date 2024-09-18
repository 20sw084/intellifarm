import 'package:flutter/material.dart';
import 'package:intellifarm/screens/reports_screens/field_status_screens/field_status_report_screen.dart';
import 'package:intellifarm/screens/reports_screens/tasks_screens/tasks_report_screen.dart';
import 'package:intellifarm/screens/reports_screens/transactions_screens/transactions_report_screen.dart';

import '../../widgets/card_widget.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("Reports"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CardWidget(
                    width: 140,
                    height: 180,
                    text: "Field Status",
                    logo: Icons.supervised_user_circle,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FieldStatusReportScreen(),
                          ));
                    },
                  ),
                  CardWidget(
                    width: 140,
                    height: 180,
                    text: "Transactions",
                    logo: Icons.attach_money,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionsReportScreen(),
                          ));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CardWidget(
                    width: 140,
                    height: 180,
                    text: "Tasks",
                    logo: Icons.task,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TasksReportScreen(),
                          ));
                    },
                  ),
                  CardWidget(
                    width: 140,
                    height: 180,
                    text: "Harvests",
                    logo: Icons.cut,
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => CropList(),));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CardWidget(
                    width: 140,
                    height: 180,
                    text: "Treatments",
                    logo: Icons.transfer_within_a_station_sharp,
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => FarmersList(),));
                    },
                  ),
                  CardWidget(
                    width: 140,
                    height: 180,
                    text: "Plantings",
                    logo: Icons.rice_bowl,
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => CropList(),));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
