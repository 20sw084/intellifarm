import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/screens/farmers_crops_fields_screens/crop_screens/add_crop_record.dart';
import 'package:intellifarm/screens/farmers_crops_fields_screens/field_screens/add_field_record.dart';
import 'package:intellifarm/util/planting_type_enum.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../controller/references.dart';
import '../../../models/crops/cropPlanting.dart';
import '../../../providers/field_provider.dart';
import '../../../providers/planting_provider.dart';
import '../../../util/common_methods.dart';
import '../../../util/field_status_after_planting_enum.dart';
import '../../farmers_crops_fields_screens/crop_screens/add_crop_variety.dart';

class AddPlanting extends StatelessWidget {
  String cropName;
  late String? fieldName;

  AddPlanting({
    super.key,
    required this.cropName,
    this.fieldName,
  });
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _plantingDateController = TextEditingController();
  PlantingType? _plantingTypeController;
  String? _cropVariety;
  final TextEditingController _harvestingDateController =
      TextEditingController();
  final TextEditingController _quantityPlantedController =
      TextEditingController();
  final TextEditingController _estimatedYieldController =
      TextEditingController();
  final TextEditingController _distanceBetweenPlantsController =
      TextEditingController();
  final TextEditingController _seedCompanyController = TextEditingController();
  final TextEditingController _seedTypeController = TextEditingController();
  final TextEditingController _seedLotNumberController =
      TextEditingController();
  final TextEditingController _seedOriginController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedPlantingDate;
  DateTime? _selectedHarvestingDate;
  final ValueNotifier<String?> fieldNameNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> cropNameNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> cropVarietyNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<FieldStatusAfterPlanting?> fieldStatusNotifier =
      ValueNotifier<FieldStatusAfterPlanting?>(null);
  Future<void> _selectPlantingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedPlantingDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (picked != null && picked != _selectedPlantingDate) {
      _selectedPlantingDate = picked;
      _plantingDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectHarvestingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedHarvestingDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedHarvestingDate) {
      _selectedHarvestingDate = picked;
      _harvestingDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    cropNameNotifier.value = cropName;
    return Scaffold(
      appBar: AppBar(
        title: Text("New Planting"),
        backgroundColor: Color(0xff727530),
        foregroundColor: Colors.white,
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
                  controller: _plantingDateController,
                  onTap: () => _selectPlantingDate(context),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Planting Date *',
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
                DropdownButtonFormField<PlantingType>(
                  decoration: InputDecoration(
                    labelText: 'Select Planting Type *',
                    border: OutlineInputBorder(),
                  ),
                  items: PlantingType.values
                      .map((option) => DropdownMenuItem<PlantingType>(
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
                  onChanged: (PlantingType? newValue) {
                    _plantingTypeController = newValue;
                  },
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: getCropDataViaStream(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) return Container();
                            return DropdownButtonFormField(
                              decoration: const InputDecoration(
                                labelText: 'Select Crop *',
                                border: OutlineInputBorder(),
                              ),
                              isExpanded: false,
                              value: cropNameNotifier.value,
                              items: snapshot.data?.docs.map((value) {
                                return DropdownMenuItem(
                                  value: value.get('name'),
                                  child: Text('${value.get('name')}'),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select necessary fields';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _cropVariety = null;
                                cropVarietyNotifier.value = null;
                                cropNameNotifier.value = value.toString();
                                cropName = value.toString();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                        left: 8.0,
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCropRecord(),
                            ),
                          );
                        },
                        backgroundColor: Color(0xff727530),
                        foregroundColor: Colors.white,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ValueListenableBuilder<String?>(
                  valueListenable: cropNameNotifier,
                  builder: (context, cropName, child) {
                    if (cropName != null && cropName.isNotEmpty) {
                      return Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: getCropVarietyDataViaStream(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return Text("No crop varieties available");
                                  }
                                  return ValueListenableBuilder<String?>(
                                    valueListenable: cropVarietyNotifier,
                                    builder: (context, selectedVariety, _) {
                                      return DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          labelText: 'Select Crop Variety *',
                                          border: OutlineInputBorder(),
                                        ),
                                        isExpanded: true,
                                        value: selectedVariety,
                                        items: snapshot.data!.docs.map((doc) {
                                          String varietyName =
                                              doc.get('varietyName');
                                          return DropdownMenuItem(
                                            value: varietyName,
                                            child: Text(varietyName),
                                          );
                                        }).toList(),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a crop variety';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          cropVarietyNotifier.value = value;
                                          _cropVariety = value.toString();
                                          debugPrint(
                                              'Selected crop variety: $value');
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddCropVariety(cropName: cropName),
                                  ),
                                );
                              },
                              backgroundColor: Color(0xff727530),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink(); // Hide when no crop is selected
                  },
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: getFieldDataViaStream(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) return Container();
                            return DropdownButtonFormField(
                              decoration: const InputDecoration(
                                labelText: 'Select Field *',
                                border: OutlineInputBorder(),
                              ),
                              isExpanded: false,
                              value: fieldNameNotifier.value,
                              items: snapshot.data?.docs.map((value) {
                                return DropdownMenuItem(
                                  value: value.get('name'),
                                  child: Text('${value.get('name')}'),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select necessary fields';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                fieldNameNotifier.value = value.toString();
                                fieldName = value.toString();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                        left: 8.0,
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddFieldRecord(),
                            ),
                          );
                        },
                        backgroundColor: Color(0xff727530),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Use ValueListenableBuilder to show second dropdown when a field is selected
                ValueListenableBuilder<String?>(
                  valueListenable: fieldNameNotifier,
                  builder: (context, fieldName, child) {
                    if (fieldName != null && fieldName.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child:
                            ValueListenableBuilder<FieldStatusAfterPlanting?>(
                          valueListenable: fieldStatusNotifier,
                          builder: (context, fieldStatus, child) {
                            return DropdownButtonFormField<
                                FieldStatusAfterPlanting>(
                              value: fieldStatus,
                              decoration: InputDecoration(
                                labelText:
                                    'Select field status after Planting *',
                                border: OutlineInputBorder(),
                              ),
                              items: FieldStatusAfterPlanting.values
                                  .map((option) => DropdownMenuItem<
                                          FieldStatusAfterPlanting>(
                                        value: option,
                                        child: Text(
                                            option.toString().split('.')[1]),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select necessary fields';
                                }
                                return null;
                              },
                              onChanged: (FieldStatusAfterPlanting? newValue) {
                                fieldStatusNotifier.value = newValue;
                              },
                            );
                          },
                        ),
                      );
                    }
                    return SizedBox.shrink(); // Hide when no field is selected
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _harvestingDateController,
                  onTap: () => _selectHarvestingDate(context),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'First Harvesting Date *',
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
                  controller: _quantityPlantedController,
                  decoration: InputDecoration(
                    labelText: 'Quantity Planted  *',
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
                  controller: _estimatedYieldController,
                  decoration: InputDecoration(
                    labelText: 'Estimated Yield',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _distanceBetweenPlantsController,
                  decoration: InputDecoration(
                    labelText: 'Distance between Plants.',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _seedCompanyController,
                  decoration: InputDecoration(
                    labelText: 'Seed Company.',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _seedTypeController,
                  decoration: InputDecoration(
                    labelText: 'Seed Type.',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _seedLotNumberController,
                  decoration: InputDecoration(
                    labelText: 'Seed Lot Number.',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _seedOriginController,
                  decoration: InputDecoration(
                    labelText: 'Seed Origin.',
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

  Stream<QuerySnapshot> getCropVarietyDataViaStream() async* {
    References r = References();
    String? id = await r.getLoggedUserId();
    String? cropId = await r.getCropIdByName(cropName);
    yield* r.usersRef
        .doc(id)
        .collection("crops")
        .doc(cropId)
        .collection("varieties")
        .snapshots();
  }

  Future<void> _saveForm(BuildContext context) async {
    CropPlanting c = CropPlanting(
      plantingDate: _plantingDateController.text,
      plantingType: _plantingTypeController,
      cropName: cropName,
      varietyName: _cropVariety,
      fieldName: fieldName,
      firstHarvestDate: _harvestingDateController.text,
      quantityPlanted: int.parse(_quantityPlantedController.text),
      estimatedYield: _estimatedYieldController.text.isNotEmpty
          ? int.parse(_estimatedYieldController.text)
          : 0,
      distanceBetweenPlants: _distanceBetweenPlantsController.text,
      seedCompany: _seedCompanyController.text,
      seedType: _seedTypeController.text,
      seedLotNumber: _seedLotNumberController.text.isNotEmpty
          ? int.parse(_seedLotNumberController.text)
          : 0,
      seedOrigin: _seedOriginController.text,
      notes: _notesController.text,
    );

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

      References r = References();
      String? id = await r.getLoggedUserId();

      try {
        String? cropId = await r.getCropIdByName(cropName);
        if (id != null) {
          DocumentReference docRef = await r.usersRef
              .doc(id)
              .collection('crops')
              .doc(cropId)
              .collection("plantings")
              .add(c.getCropPlantingDataMap());

          // Fetch the newly added planting document
          DocumentSnapshot newPlanting = await docRef.get();

          // Notify the PlantingProvider
          Provider.of<PlantingProvider>(context, listen: false)
              .addPlanting(newPlanting);

          // Update field status
          String? fieldId = await r.getFieldIdByName(c.fieldName!);
          await r.usersRef.doc(id).collection('fields').doc(fieldId).update({
            "fieldStatus": fieldStatusNotifier.value.toString().split(".").last,
          });

          Provider.of<FieldProvider>(context, listen: false).needsRefresh =
              true;
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          print("Error: User ID is null");
          Navigator.pop(context);
        }
      } catch (e) {
        print(e);
        Navigator.pop(context); // Close the dialog
      }
    }
  }
}
// TODO: fields 2bara na aaen jab fully cultivate wala scene hojaye. y check khan lagana h dekhlena : app se dekho pehle
