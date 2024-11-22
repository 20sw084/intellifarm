import 'package:flutter/material.dart';
import 'package:intellifarm/util/field_status_enum.dart';
import 'package:intellifarm/util/field_type_enum.dart';
import 'package:intellifarm/util/light_profile_enum.dart';
import 'package:provider/provider.dart';

import '../../../controller/references.dart';
import '../../../models/fields/field.dart';
import '../../../providers/field_provider.dart';

class AddFieldRecord extends StatelessWidget {
  AddFieldRecord({super.key});

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController fieldNameController = TextEditingController();
  FieldType fieldTypeController = FieldType.FieldOrOutdoor;
  LightProfile lightProfileController = LightProfile.FullSun;
  FieldStatus fieldStatusController = FieldStatus.Available;
  final TextEditingController sizeOfFieldController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Field"),
        backgroundColor: Color(0xff727530),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              _saveForm(context);
              Provider.of<FieldProvider>(context, listen: false).needsRefresh = true;
              // Navigator.pop(context);
            },
            icon: Icon(Icons.check_box),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 30),
                TextFormField(
                  controller: fieldNameController,
                  decoration: InputDecoration(
                    labelText: 'Name of Field / Survey Number *',
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
                DropdownButtonFormField<FieldType>(
                  value: fieldTypeController,
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
                    fieldTypeController = newValue!;
                  },
                ),
                SizedBox(height: 30),
                DropdownButtonFormField<LightProfile>(
                  value: lightProfileController,
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
                    lightProfileController = newValue!;
                  },
                ),
                SizedBox(height: 30),
                DropdownButtonFormField<FieldStatus>(
                  value: fieldStatusController,
                  decoration: InputDecoration(
                    labelText: 'Select Field Status *',
                    border: OutlineInputBorder(),
                  ),
                  items: FieldStatus.values
                      .map((option) => DropdownMenuItem<FieldStatus>(
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
                  onChanged: (FieldStatus? newValue) {
                    fieldStatusController = newValue!;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: sizeOfFieldController,
                  decoration: InputDecoration(
                    labelText: 'Size of Field (Optional)',
                    border: OutlineInputBorder(),
                  ),
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

      Field c = Field(
        name: fieldNameController.text,
        fieldType: fieldTypeController,
        lightProfile: lightProfileController,
        fieldStatus: fieldStatusController,
        sizeOfField: int.tryParse(sizeOfFieldController.text) ?? 0,
        notes: notesController.text,
      );

      References r = References();
      String? id = await r.getLoggedUserId();

      try {
        if (id != null) {
          await r.usersRef.doc(id).collection('fields').add(
            c.getFieldDataMap(),
          );
          Navigator.pop(context); // Close the dialog
          Navigator.pop(context); // Close the form
        } else {
          print("Error: User ID is null");
          Navigator.pop(context); // Close the dialog
        }
      } catch (e) {
        print(e);
        Navigator.pop(context); // Close the dialog
      }
    }
  }
}
