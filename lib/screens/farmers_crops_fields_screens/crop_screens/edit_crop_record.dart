import 'package:flutter/material.dart';
import 'package:intellifarm/util/crop_type_enum.dart';
import '../../../controller/references.dart';
import '../../../models/crops/crop.dart';
import '../../../util/units_enum.dart';

class EditCropRecord extends StatelessWidget {
  final Map<String, dynamic> dataMap;

  EditCropRecord({
    super.key,
    required this.dataMap,
  });

  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  late final ValueNotifier<Units> _selectedUnitNotifier;
  late final ValueNotifier<CropType> _selectedCropNotifier;

  @override
  Widget build(BuildContext context) {
    // _cropNameController.text = dataMap["Name:"];
    _notesController.text = dataMap["Notes:"];
    _selectedUnitNotifier = ValueNotifier<Units>(
      Units.values.firstWhere(
            (unit) => unit.toString().split('.')[1] == dataMap["Harvest Unit:"].toString().split('.')[1],
        orElse: () => Units.values.first, // Provide a default value
      ),
    );

    _selectedCropNotifier = ValueNotifier<CropType>(
      CropType.values.firstWhere(
            (unit) => unit.toString().split('.')[1] == dataMap["Name:"].toString().split('.')[1],
        orElse: () => CropType.values.first, // Provide a default value
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Crop"),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30),
              // TextFormField(
              //   controller: _selectedCropNotifier,
              //   decoration: InputDecoration(
              //     labelText: 'Name of Crop *',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return 'This field is required';
              //     }
              //     return null;
              //   },
              // ),
              ValueListenableBuilder<CropType>(
                valueListenable: _selectedCropNotifier,
                builder: (context, selectedCrop, child) {
                  return DropdownButtonFormField<CropType>(
                    value: selectedCrop,
                    decoration: InputDecoration(
                      labelText: 'Select Crop *',
                      border: OutlineInputBorder(),
                    ),
                    items: CropType.values
                        .map((option) => DropdownMenuItem<CropType>(
                      value: option,
                      child: Text(option.toString().split('.')[1]),
                    ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select necessary crops';
                      }
                      return null;
                    },
                    onChanged: (CropType? newValue) {
                      _selectedCropNotifier.value = newValue!;
                    },
                  );
                },
              ),
              SizedBox(height: 30),
              ValueListenableBuilder<Units>(
                valueListenable: _selectedUnitNotifier,
                builder: (context, selectedUnit, child) {
                  return DropdownButtonFormField<Units>(
                    value: selectedUnit,
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
                      _selectedUnitNotifier.value = newValue!;
                    },
                  );
                },
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
    );
  }

  Future<void> _saveForm(BuildContext context) async {
    Crop c = Crop(
      name: _selectedCropNotifier.toString(),
      harvestUnit: _selectedUnitNotifier.value,
      notes: _notesController.text,
    );

    if (_formKey.currentState!.validate()) {
      References r = References();
      String? id = await r.getLoggedUserId();

      try{
        if (id != null) {
          String? cropId = await r.getCropIdByName(dataMap["Name:"]);
          await r.usersRef.doc(id).collection('crops').doc(cropId).update(
            c.getCropDataMap(),
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
