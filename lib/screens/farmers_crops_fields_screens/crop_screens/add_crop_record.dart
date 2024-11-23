import 'package:flutter/material.dart';
import 'package:intellifarm/controller/references.dart';
import 'package:provider/provider.dart';
import '../../../models/crops/crop.dart';
import '../../../providers/crop_provider.dart';
import '../../../util/crop_type_enum.dart';
import '../../../util/units_enum.dart';

class AddCropRecord extends StatelessWidget {
  AddCropRecord({super.key});

  final _formKey = GlobalKey<FormState>();

  // Controllers
  CropType? _selectedCrop;
  Units harvestUnitController = Units.Kilograms;
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Crop"),
          backgroundColor: Color(0xff727530),
          foregroundColor: Colors.white,
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
                DropdownButtonFormField<CropType>(
                  decoration: InputDecoration(
                    labelText: 'Select Crop *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  items: CropType.values
                      .map((crop) => DropdownMenuItem(
                    value: crop,
                    child: Text(crop.name),
                  ))
                      .toList(),
                  onChanged: (value) {
                    // setState(() {
                      _selectedCrop = value;
                    // });
                  },
                  value: _selectedCrop,
                ),
                SizedBox(height: 30),
                DropdownButtonFormField<Units>(
                  value: harvestUnitController,
                  decoration: InputDecoration(
                    labelText: 'Select Harvest Unit *',
                    border: OutlineInputBorder(),
                  ),
                  items: Units.values
                      .map((option) => DropdownMenuItem<Units>(
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
                  onChanged: (Units? newValue) {
                    harvestUnitController = newValue!;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: notesController,
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

      Crop c = Crop(
        name: _selectedCrop.toString(),
        harvestUnit: harvestUnitController,
        notes: notesController.text,
      );

      References r = References();
      String? id = await r.getLoggedUserId();

      try {
        if (id != null) {
          await r.usersRef.doc(id).collection('crops').add(
            c.getCropDataMap(),
          );
          // Notify the CropProvider to fetch the updated list of crops
          Provider.of<CropProvider>(context, listen: false).fetchCropsData();
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
