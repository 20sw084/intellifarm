import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/controller/references.dart';
import '../../../models/farmer.dart';
import '../../../util/common_methods.dart';
import '../../../util/share_rule_enum.dart';


class AddFarmerRecord extends StatelessWidget {
  AddFarmerRecord({super.key});

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController farmerNameController = TextEditingController();
  final TextEditingController farmerPhoneController = TextEditingController();
  ShareRule shareRuleController = ShareRule.FiftyPercent;
  final TextEditingController cnicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Farmer"),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            onPressed: () async {
              await _saveForm(context);
            },
            icon: Icon(Icons.check_box),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30),
              TextFormField(
                controller: farmerNameController,
                decoration: InputDecoration(
                  labelText: 'Name of Farmer  *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: farmerPhoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  } else if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                    return 'Please enter a valid 11-digit number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              DropdownButtonFormField<ShareRule>(
                value: shareRuleController,
                decoration: InputDecoration(
                  labelText: 'Select Share Rule *',
                  border: OutlineInputBorder(),
                ),
                items: ShareRule.values
                    .map((option) => DropdownMenuItem<ShareRule>(
                  value: option,
                  child: Text(option.toString().split('.')[1]),
                ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select necessary fields';
                  }
                  return null;
                },
                onChanged: (ShareRule? newValue) {
                  shareRuleController = newValue!;
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: cnicController,
                decoration: InputDecoration(
                  labelText: 'C-NIC Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 15),
                Text("Saving...", style: TextStyle(color: Colors.white)),
              ],
            ),
          );
        },
      );

      Farmer f = Farmer(
        name: farmerNameController.text,
        phoneNumber: farmerPhoneController.text,
        loginCode: generateRandom10DigitCode(),
        shareRule: shareRuleController,
        cnic: cnicController.text,
      );

      References r = References();
      String? id = await r.getLoggedUserId();

      try {
        if (id != null) {
          final String farmerId = generateRandomDocId(); // Generate or use a consistent ID for the farmer

          // Add farmer data to the user's subcollection
          await r.usersRef.doc(id).collection('farmers').doc(farmerId).set(
            f.getFarmerDataMap(),
          );

          // Add farmer data to the general farmers collection
          await FirebaseFirestore.instance.collection('farmers').doc(farmerId).set(
            f.getFarmerDataMapWithUserID(id),
          );

          Navigator.pop(context); // Close the loading dialog
          Navigator.pop(context); // Close the form
        } else {
          print("Error: User ID is null");
          Navigator.pop(context); // Close the loading dialog
        }
      } catch (e) {
        print(e);
        Navigator.pop(context); // Close the loading dialog
      }
    }

  }
}

String generateRandom10DigitCode() {
  Random random = Random();
  // Generate a random 10-digit number
  String code = List.generate(10, (index) => random.nextInt(10)).join();
  return code;
}
