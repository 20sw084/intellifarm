import 'package:flutter/material.dart';
import 'package:intellifarm/util/field_status_enum.dart';
import 'package:intellifarm/util/field_type_enum.dart';
import 'package:intellifarm/util/light_profile_enum.dart';

import '../../../controller/references.dart';
import '../../../models/fields/field.dart';

class EditFieldRecord extends StatelessWidget {
  final Field field;

  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _fieldSizeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final ValueNotifier<FieldType> _selectedFieldTypeNotifier;
  final ValueNotifier<LightProfile> _selectedLightProfileTypeNotifier;
  final ValueNotifier<FieldStatus> _selectedFieldStatusTypeNotifier;
  String _prevFieldName = "";

  final _formKey = GlobalKey<FormState>();

  EditFieldRecord({
    super.key,
    required this.field,
  })  : _selectedFieldTypeNotifier = ValueNotifier<FieldType>(
    FieldType.values.firstWhere(
          (unit) => unit == field.fieldType,
      orElse: () => FieldType.values.first, // Provide a default value
    ),
  ),
        _selectedLightProfileTypeNotifier = ValueNotifier<LightProfile>(
          LightProfile.values.firstWhere(
                (unit) => unit == field.lightProfile,
            orElse: () => LightProfile.values.first, // Provide a default value
          ),
        ),
        _selectedFieldStatusTypeNotifier = ValueNotifier<FieldStatus>(
          FieldStatus.values.firstWhere(
                (unit) => unit == field.fieldStatus,
            orElse: () => FieldStatus.values.first, // Provide a default value
          ),
        ) {
    _fieldNameController.text = field.name!;
    _fieldSizeController.text = field.sizeOfField.toString();
    _notesController.text = field.notes!;
    _prevFieldName = field.name!;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Field"),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            onPressed: () {
              _saveForm(context);
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
                  controller: _fieldNameController,
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
                ValueListenableBuilder<FieldType>(
                  valueListenable: _selectedFieldTypeNotifier,
                  builder: (context, selectedUnit, child) {
                    return DropdownButtonFormField<FieldType>(
                      decoration: InputDecoration(
                        labelText: 'Select Field Type *',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedUnit,
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
                        _selectedFieldTypeNotifier.value = newValue!;
                      },
                    );
                  },
                ),
                SizedBox(height: 30),
                ValueListenableBuilder<LightProfile>(
                  valueListenable: _selectedLightProfileTypeNotifier,
                  builder: (context, selectedUnit, child) {
                    return DropdownButtonFormField<LightProfile>(
                      decoration: InputDecoration(
                        labelText: 'Select Light Profile *',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedUnit,
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
                        _selectedLightProfileTypeNotifier.value = newValue!;
                      },
                    );
                  },
                ),
                SizedBox(height: 30),
                ValueListenableBuilder<FieldStatus>(
                  valueListenable: _selectedFieldStatusTypeNotifier,
                  builder: (context, selectedUnit, child) {
                    return DropdownButtonFormField<FieldStatus>(
                      decoration: InputDecoration(
                        labelText: 'Select Field Status *',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedUnit,
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
                        _selectedFieldStatusTypeNotifier.value = newValue!;
                      },
                    );
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _fieldSizeController,
                  decoration: InputDecoration(
                    labelText: 'Field Size (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _notesController,
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
    Field f = Field(
      name: _fieldNameController.text,
      fieldType: _selectedFieldTypeNotifier.value,
      lightProfile: _selectedLightProfileTypeNotifier.value,
      fieldStatus: _selectedFieldStatusTypeNotifier.value,
      sizeOfField: int.tryParse(_fieldSizeController.value.text),
      notes: _notesController.text,
    );

    if (_formKey.currentState!.validate()) {
      References r = References();
      String? id = await r.getLoggedUserId();

      try{
        if (id != null) {
          String? fieldId = await r.getCropIdByFieldName(_prevFieldName);
          await r.usersRef.doc(id).collection('fields').doc(fieldId).update(
            f.getFieldDataMap(),
          );
          Navigator.pop(context);
        } else {
          print("Error: User ID is null");
        }
      } catch(e){
        print(e);
      }
    }
  }
}
