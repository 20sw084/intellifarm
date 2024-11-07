import 'package:flutter/material.dart';
import 'package:intellifarm/util/field_type_enum.dart';
import 'package:intellifarm/util/light_profile_enum.dart';
import 'package:provider/provider.dart';
import '../../../controller/references.dart';
import '../../../models/crops/cropVariety.dart';
import '../../../providers/crop_provider.dart';

class AddCropVariety extends StatelessWidget {
  String cropName;
  AddCropVariety({super.key, required this.cropName});
  final _formKey = GlobalKey<FormState>();
  TextEditingController varietyName = TextEditingController();
  LightProfile? lightProfile;
  FieldType? fieldType;
  TextEditingController daysToMaturity = TextEditingController();
  TextEditingController harvestWindowDays = TextEditingController();
  TextEditingController notes = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("New Crop Variety"),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
              onPressed: () {
                _saveForm(context);
              },
              icon: Icon(Icons.check_box)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  height: 35,
                  color: Colors.greenAccent,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.kayaking),
                      SizedBox(width: 10),
                      Text(cropName ?? "Crop Name not fetched"),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: varietyName,
                  decoration: InputDecoration(
                    labelText: 'Variety Name  *',
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
                DropdownButtonFormField<LightProfile>(
                  decoration: InputDecoration(
                    labelText: 'Select Light Profile *',
                    border: OutlineInputBorder(),
                  ),
                  items: LightProfile.values
                      .map((option) => DropdownMenuItem<LightProfile>(
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
                  onChanged: (LightProfile? newValue) {
                    lightProfile = newValue;
                    // Do something with the selected value
                  },
                ),
                SizedBox(height: 30),
                DropdownButtonFormField<FieldType>(
                  decoration: InputDecoration(
                    labelText: 'Select Field Type *',
                    border: OutlineInputBorder(),
                  ),
                  items: FieldType.values
                      .map((option) => DropdownMenuItem<FieldType>(
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
                  onChanged: (FieldType? newValue) {
                    fieldType = newValue;
                    // Do something with the selected value
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: daysToMaturity,
                  decoration: InputDecoration(
                    labelText: 'Days to Maturity  *',
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
                  controller: harvestWindowDays,
                  decoration: InputDecoration(
                    labelText: 'Harvest Window (Days)  *',
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
                  controller: notes,
                  decoration: InputDecoration(
                    labelText: 'Notes (for your convenience)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveForm(BuildContext context) async {
    CropVariety c = CropVariety(
      varietyName: varietyName.text,
      lightProfile: lightProfile,
      fieldType: fieldType,
      daysToMaturity: int.parse(daysToMaturity.text),
      harvestWindowDays: int.parse(harvestWindowDays.text),
      notes: notes.text,
    );

    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with saving data
      References r = References();
      String? id = await r.getLoggedUserId();

      try {
        // crop name k basis per code lena h
        String? cropId = await r.getCropIdByName(cropName);
        if (id != null) {
          await r.usersRef.doc(id).collection('crops').doc(cropId).collection("varieties").add(
            c.getCropVarietyDataMap(),
          );
          Provider.of<CropProvider>(context, listen: false).needsRefresh = true;
          print("Success: Variety added successfully.");
          Navigator.pop(context);
        } else {
          print("Error: User ID is null");
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
