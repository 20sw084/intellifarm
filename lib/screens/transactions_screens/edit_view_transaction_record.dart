import 'package:flutter/material.dart';
import 'package:intellifarm/util/field_status_enum.dart';
import 'package:intellifarm/util/field_type_enum.dart';
import 'package:intellifarm/util/light_profile_enum.dart';

class EditViewTransactionRecord extends StatelessWidget {
  EditViewTransactionRecord({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit/View Income"),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
              onPressed: () {
                _saveForm(context);
              },
              icon: Icon(Icons.check_box)),
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
                  decoration: InputDecoration(
                    labelText: 'Name of Field  *',
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
                    // Do something with the selected value
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
                    // Do something with the selected value
                  },
                ),
                SizedBox(height: 30),
                DropdownButtonFormField<FieldStatus>(
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
                    // Do something with the selected value
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Field Size (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
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
  void _saveForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with saving data
      Navigator.pop(context);
    }
  }
}
