import 'package:flutter/material.dart';
import 'package:intellifarm/screens/reports_screens/reports_screen.dart';
import 'package:intellifarm/screens/transactions_screens/transactions_screen.dart';
import 'package:intellifarm/util/common_methods.dart';
import '../widgets/card_widget.dart';
import 'activities_screens/activities_screen.dart';
import 'farmers_crops_fields_screens/farmer_crops_fields.dart';

class LandlordDashboard extends StatelessWidget {
  const LandlordDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                // Use the context of the Builder
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            ),
          ),
          title: Text("Landlord Dashboard"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed action here
            print('Button pressed!');
          },
          icon: Icon(Icons.refresh),
          label: Text('Sync Data'),
          tooltip: 'Sync Data', // Tooltip text
        ),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 5.0,
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xff00c39c),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                        "https://avatars.githubusercontent.com/u/83652548?v=4"),
                  ),
                ),
                const SizedBox(height: 20),
                // Edit Profile Button
                ListTile(
                  leading: Icon(Icons.edit, color: Colors.greenAccent),
                  title: Text('Edit Profile'),
                  onTap: () {
                    // Handle edit profile action
                    print('Edit Profile clicked');
                  },
                ),
                // Spacer to push Logout to the end
                Spacer(),
                // Logout Button
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.greenAccent),
                  title: Text('Logout'),
                  onTap: () {
                    logout(context);
                    // Handle logout action
                    print('Logout clicked');
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                        text: "Farmer, Crops, & Fields",
                        logo: Icons.supervised_user_circle,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FarmerCropsAndFields(),
                              ));
                        },
                      ),
                      CardWidget(
                        width: 140,
                        height: 180,
                        text: "Activities",
                        logo: Icons.volunteer_activism,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivitiesScreen(),
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
                        text: "Transactions",
                        logo: Icons.attach_money,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionsScreen(),
                              ));
                        },
                      ),
                      CardWidget(
                        width: 140,
                        height: 180,
                        text: "Reports",
                        logo: Icons.insert_chart_outlined,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportsScreen(),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CardWidget(
                    width: 140,
                    height: 180,
                    text: "Miscellaneous",
                    logo: Icons.miscellaneous_services,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
