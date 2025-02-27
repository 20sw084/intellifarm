import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/util/common_methods.dart';
import 'package:intellifarm/util/treatment_status_enum.dart';
import 'package:intl/intl.dart';
import '../../../controller/references.dart';
import '../../../models/treatment.dart';
import '../../../util/treatment_specific_to_planting_enum.dart';
import '../../../util/treatment_type_enum.dart';
import '../../farmers_crops_fields_screens/field_screens/add_field_record.dart'; // Import for date formatting

class EditActivityTreatment extends StatelessWidget {
  Treatment treatment;
  EditActivityTreatment({super.key, required this.treatment});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _treatmentDateController = TextEditingController();
  final TextEditingController _plantingNameController =  TextEditingController();
  final TextEditingController _fieldNameController =  TextEditingController();
  final TextEditingController _productUsedController =  TextEditingController();
  final TextEditingController _quantityOfProductController =  TextEditingController();
  final TextEditingController _notesController =  TextEditingController();
  String? cropName;
  String? cropVariety;
  String? _selectedFieldName; // Initialize this to null or a default value if necessary

  DateTime? _selectedDate;
  ValueNotifier<TreatmentSpecificToPlanting?> _selectedTreatmentSpecificToPlanting = ValueNotifier<TreatmentSpecificToPlanting?>(null);
  ValueNotifier<TreatmentStatus?> _selectedTreatmentStatus = ValueNotifier<TreatmentStatus?>(null);
  ValueNotifier<TreatmentType?> _selectedTreatmentType = ValueNotifier<TreatmentType?>(null);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _treatmentDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    _treatmentDateController.text = treatment.treatmentDate;
    _plantingNameController.text = treatment.plantingName!;
    _fieldNameController.text = treatment.fieldName;
    _productUsedController.text = treatment.productUsed!;
    _quantityOfProductController.text = treatment.quantityOfProduct.toString();
    _notesController.text = treatment.notes!;
    _selectedTreatmentSpecificToPlanting.value = treatment.treatmentSpecificToPlanting;
    _selectedTreatmentStatus.value = treatment.treatmentStatus;
    _selectedTreatmentType.value = treatment.treatmentType;
    _selectedFieldName = treatment.fieldName;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Treatment"),
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 30),
                TextFormField(
                  controller: _treatmentDateController,
                  onTap: () => _selectDate(context),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Treatment Date *',
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
                DropdownButtonFormField<TreatmentStatus>(
                  value: _selectedTreatmentStatus.value,
                  decoration: InputDecoration(
                    labelText: 'Select Status of Treatment *',
                    border: OutlineInputBorder(),
                  ),
                  items: TreatmentStatus.values
                      .map((option) => DropdownMenuItem<TreatmentStatus>(
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
                  onChanged: (TreatmentStatus? newValue) {
                    _selectedTreatmentStatus.value = newValue;
                  },
                ),
                SizedBox(height: 30),
                DropdownButtonFormField<TreatmentType>(
                  value: _selectedTreatmentType.value,
                  decoration: InputDecoration(
                    labelText: 'Select Treatment Type *',
                    border: OutlineInputBorder(),
                  ),
                  items: TreatmentType.values
                      .map((option) => DropdownMenuItem<TreatmentType>(
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
                  onChanged: (TreatmentType? newValue) {
                    _selectedTreatmentType.value = newValue;
                  },
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: getFieldDataViaStream(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) return Container();

                            // Define a list of dropdown items
                            List<DropdownMenuItem<String>> items = snapshot.data?.docs.map((value) {
                              return DropdownMenuItem<String>(
                                value: value.get('name'),
                                child: Text('${value.get('name')}'),
                              );
                            }).toList() ?? [];

                            return DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Select Field *',
                                border: OutlineInputBorder(),
                              ),
                              isExpanded: true, // Make sure the dropdown expands
                              value: _selectedFieldName, // Use a plain variable for value
                              items: items,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select necessary fields';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                // Update the selected value
                                _selectedFieldName = value;
                                _fieldNameController.text = value ?? '';
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    // Padding around the FloatingActionButton
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddFieldRecord(),
                            ),
                          );
                        },
                        backgroundColor: Colors.greenAccent,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),
                DropdownButtonFormField<TreatmentSpecificToPlanting>(
                  value: _selectedTreatmentSpecificToPlanting.value,
                  decoration: InputDecoration(
                    labelText: 'Treatment Specific to Planting *',
                    border: OutlineInputBorder(),
                  ),
                  items: TreatmentSpecificToPlanting.values
                      .map((option) => DropdownMenuItem<TreatmentSpecificToPlanting>(
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
                  onChanged: (TreatmentSpecificToPlanting? newValue) {
                    _selectedTreatmentSpecificToPlanting.value = newValue; // Update the notifier value
                  },
                ),
                SizedBox(height: 30),
                // Using ValueListenableBuilder to listen for changes in _selectedTreatment
              ValueListenableBuilder<TreatmentSpecificToPlanting?>(
                valueListenable: _selectedTreatmentSpecificToPlanting,
                builder: (context, value, child) {
                  if (value == TreatmentSpecificToPlanting.Yes) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: getAllPlantingsStream(), // Replace this with your actual Firestore stream
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return Container(); // Or show a loading indicator

                        // Create a list of dropdown items
                        List<DropdownMenuItem<String>> items = snapshot.data?.docs.map((DocumentSnapshot doc) {
                          // TODO: EDIT krte waqt field retrive nh horhi dropdown men auto. due to inconsistent amount of data / fields.
                          String combinedValue = "${doc.get('cropName')} | ${doc.get('varietyName')} | ${doc.get('plantingDate')}";
                          return DropdownMenuItem<String>(
                            value: combinedValue,
                            child: Text(combinedValue),
                          );
                        }).toList() ?? [];

                        // Make sure the controller's value matches one of the items
                        String? selectedValue = items.isNotEmpty && items.any((item) => item.value == _plantingNameController.text)
                            ? _plantingNameController.text
                            : null;

                        return DropdownButtonFormField<String>(
                          value: selectedValue,
                          decoration: const InputDecoration(
                            labelText: 'Select Planting to Harvest *',
                            border: OutlineInputBorder(),
                          ),
                          isExpanded: true, // Allow dropdown to expand
                          items: items,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select necessary fields';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _plantingNameController.text = value ?? '';
                            if (value != null) {
                              List<String> splitValue = value.split("|");
                              cropName = splitValue[0].trim();
                              cropVariety = splitValue[1].trim();
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return SizedBox.shrink(); // No field shown
                  }
                },
              ),
              SizedBox(height: 30),
                TextFormField(
                  controller: _productUsedController,
                  decoration: InputDecoration(
                    labelText: 'Product used / to be used',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _quantityOfProductController,
                  decoration: InputDecoration(
                    labelText: 'Quantity of Product used / to be used',
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
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with saving data
      References r = References();
      String? id = await r.getLoggedUserId();

      if (id == null) {
        print("Error: User ID is null");
        return; // Exit the function early if the user ID is null
      }

      try {
        Treatment t = Treatment(
          treatmentDate: _treatmentDateController.text,
          treatmentStatus: _selectedTreatmentStatus.value,
          treatmentType: _selectedTreatmentType.value,
          fieldName: _fieldNameController.text,
          treatmentSpecificToPlanting: treatment.treatmentSpecificToPlanting,
          plantingName: _selectedTreatmentSpecificToPlanting.value == TreatmentSpecificToPlanting.Yes && _plantingNameController.text.contains("|")
              ? "${_plantingNameController.text.split("|").first.trim()} | ${_plantingNameController.text.split("|")[1].trim()}"
              : "",
          productUsed: _productUsedController.text,
          quantityOfProduct: int.tryParse(_quantityOfProductController.text),
          notes: _notesController.text,
        );

        // Split plantingName only if TreatmentSpecificToPlanting is 'Yes'
        if (treatment.treatmentSpecificToPlanting == TreatmentSpecificToPlanting.Yes) {
          if (t.plantingName == null || t.plantingName!.isEmpty) {
            print("Error: Planting name is null or empty");
            return;
          }

          List<String> plantingParts = t.plantingName!.split("|").map((part) => part.trim()).toList();
          if (plantingParts.length != 2) {
            print("Error: Planting name does not have the correct format");
            return;
          }

          cropName = plantingParts[0];
          cropVariety = plantingParts[1];

          if (cropName == null || _selectedFieldName == null || cropVariety == null) {
            print("Error: Some required values are null");
            return; // Exit the function early if any required value is null
          }

          String? cropId = await r.getCropIdByName(cropName!);
          if (cropId == null) {
            print("Error: cropId is null");
            return; // Exit the function early if cropId is null
          }

          String? plantingId = await r.getPlantingIdByFieldAndCropVariety(cropId, _selectedFieldName!, cropVariety!);
          if (plantingId == null) {
            print("Error: plantingId is null");
            return; // Exit the function early if plantingId is null
          }

          String? treatmentId = await r.getTreatmentIdOfYes(treatment.fieldName, cropId, plantingId);
          if (treatmentId == null) {
            print("Error: treatmentId is null");
            return; // Exit the function early if plantingId is null
          }

          await r.usersRef.doc(id).collection('crops').doc(cropId).collection("plantings").doc(plantingId).collection("treatments").doc(treatmentId).update(
            t.getTreatmentDataMap(),
          );
          print("Success: Treatment updated successfully in Crop Plantings.");
        }

        else if (treatment.treatmentSpecificToPlanting == TreatmentSpecificToPlanting.No) {
          if (t.fieldName.isEmpty) {
            print("Error: fieldName is empty");
            return; // Exit the function early if fieldName is empty
          }

          String? fieldId = await r.getFieldIdByName(t.fieldName);
          if (fieldId == null) {
            print("Error: fieldId is null");
            return; // Exit the function early if fieldId is null
          }

          String? treatmentId = await r.getTreatmentIdOfNo(treatment.fieldName, fieldId);
          if (treatmentId == null) {
            print("Error: treatmentId is null");
            return; // Exit the function early if plantingId is null
          }

          await r.usersRef.doc(id).collection('fields').doc(fieldId).collection("treatments").doc(treatmentId).update(
            t.getTreatmentDataMap(),
          );
          print("Success: Treatment updated successfully in Fields.");
        } else {
          print("Error: Unexpected treatmentSpecificToPlanting value");
        }

        Navigator.pop(context);
      } catch (e) {
        print("Error: $e");
      }
    }
  }
}
