import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intellifarm/screens/farmer_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth_service.dart';
import '../../util/common_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerLoginPage extends StatelessWidget {
  FarmerLoginPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _uniqueNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Farmer Login Page'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Text("Enter the unique 10-digits number provided by your owner!"),
              const SizedBox(
                height: 13,
              ),
              TextFormField(
                controller: _uniqueNumber,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xff00c39c), width: 2),
                  ),
                  prefixIcon: const Icon(
                    Icons.phone_android_sharp,
                    size: 30,
                    color: Color(0xff00c39c),
                  ),
                  hintText: 'UNIQUE NUMBER',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unique Number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              const Spacer(),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: const Color(0xff00c39c),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00c39c),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () async {
                    await _submitForm(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'LOGIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      log('Unique Number: ${_uniqueNumber.text}');
      await signIn(context);
    }
  }

  Future<void> signIn(BuildContext context) async {
    AuthService authService = AuthService();
    final QuerySnapshot? farmerSnapshot = await authService.signInAsFarmer(_uniqueNumber.text);

    if (farmerSnapshot != null && farmerSnapshot.docs.isNotEmpty) {
      log("Sign In as Farmer Successful");
      saveFarmerId(_uniqueNumber.text);
      saveSecondaryUserId(_uniqueNumber.text);
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('name', "farmer");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FarmerDashboard(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign In Failed. Please check your credentials.'),
        ),
      );
    }
  }
}
