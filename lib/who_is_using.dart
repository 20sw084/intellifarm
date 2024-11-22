import 'package:flutter/material.dart';
import 'package:intellifarm/screens/auth_screens/farmer_login_page.dart';
import 'package:intellifarm/screens/auth_screens/landlord_login_page.dart';
import 'package:intellifarm/widgets/card_widget.dart';

class WhoIsUsing extends StatelessWidget {
  const WhoIsUsing({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff727530),
          foregroundColor: Colors.white,
          title: Center(child: Text("Who is Using?")),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CardWidget(
                      width: 170,
                      height: 180,
                      text: "Farmer",
                      logo: Icons.supervised_user_circle,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FarmerLoginPage(),
                            ));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CardWidget(
                      width: 170,
                      height: 180,
                      text: "Landlord",
                      logo: Icons.supervised_user_circle,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LandlordLoginPage(),
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
