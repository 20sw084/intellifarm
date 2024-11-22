import 'package:flutter/material.dart';
import 'package:intellifarm/screens/activities_screens/harvests/harvests_screen.dart';
import 'package:intellifarm/screens/activities_screens/plantings/plantings_screen.dart';
import 'package:intellifarm/screens/activities_screens/tasks/tasks_screen.dart';
import 'package:intellifarm/screens/activities_screens/treatments/treatments_screen.dart';
import '../../widgets/card_widget.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff727530),
          foregroundColor: Colors.white,
          title: Text("Activities"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CardWidget(
                      width: 140,
                      height: 180,
                      text: "Plantings",
                      logo: Icons.volunteer_activism,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlantingsScreen(),
                            ));
                      },
                    ),
                    CardWidget(
                      width: 140,
                      height: 180,
                      text: "Harvest",
                      logo: Icons.cut,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HarvestsScreen(),
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
                      text: "Treatments",
                      logo: Icons.transfer_within_a_station_sharp,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TreatmentsScreen(),
                            ));
                      },
                    ),
                    CardWidget(
                      width: 140,
                      height: 180,
                      text: "Tasks",
                      logo: Icons.task,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TasksScreen(),
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
