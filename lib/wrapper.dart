import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intellifarm/controller/getUserData.dart';
import 'package:intellifarm/controller/references.dart';
import 'package:intellifarm/screens/auth_screens/landlord_login_page.dart';
import 'package:intellifarm/screens/farmer_dashboard.dart';
import 'package:intellifarm/screens/landlord_dashboard.dart';
import 'package:intellifarm/who_is_using.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String name = '';
  @override
  void initState() {
    getName();
    super.initState();
  }

  void getName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    name = sp.getString('name') ?? 'empty';
    log(name.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (name == "landlord") {
      return const LandlordDashboard();
    }
    else if (name == "farmer") {
      return const FarmerDashboard();
    }
    else {
      return const WhoIsUsing();
    }
  }
}
