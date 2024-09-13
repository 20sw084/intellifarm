import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/screens/farmers_crops_fields_screens/crop_screens/add_crop_record.dart';
import 'package:intellifarm/screens/farmers_crops_fields_screens/field_screens/add_field_record.dart';
import 'package:intellifarm/util/planting_type_enum.dart';
import 'package:intl/intl.dart';
import '../../../controller/references.dart';
import '../../../models/crops/cropPlanting.dart';
import '../../farmers_crops_fields_screens/crop_screens/add_crop_variety.dart'; // Import for date formatting

class EditPlanting extends StatelessWidget {
  CropPlanting cropPlanting;
  EditPlanting({
    super.key,
    required this.cropPlanting,
  });

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _plantingDateController = TextEditingController();
  final TextEditingController _cropNameController = TextEditingController();
  String? _fieldNameController;
  PlantingType? _plantingTypeController;
  String? _cropVariety;
  final TextEditingController _harvestingDateController =  TextEditingController();
  final TextEditingController _quantityPlantedController =  TextEditingController();
  final TextEditingController _estimatedYieldController =  TextEditingController();
  final TextEditingController _distanceBetweenPlantsController =  TextEditingController();
  final TextEditingController _seedCompanyController = TextEditingController();
  final TextEditingController _seedTypeController = TextEditingController();
  final TextEditingController _seedLotNumberController =  TextEditingController();
  final TextEditingController _seedOriginController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedPlantingDate;
  DateTime? _selectedHarvestingDate;
  Future<void> _selectPlantingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedPlantingDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
    _plantingDateController.text = cropPlanting.plantingDate!;
    _plantingTypeController = cropPlanting.plantingType!;
    _cropNameController.text = cropPlanting.cropName!;
    _cropVariety = cropPlanting.varietyName!;
    _fieldNameController = cropPlanting.fieldName!;
    _harvestingDateController.text = cropPlanting.firstHarvestDate!;
    _quantityPlantedController.text = cropPlanting.quantityPlanted.toString();
    _estimatedYieldController.text = cropPlanting.estimatedYield.toString();
    _distanceBetweenPlantsController.text = cropPlanting.distanceBetweenPlants.toString();
    _seedCompanyController.text = cropPlanting.seedCompany!;
    _seedTypeController.text = cropPlanting.seedType!;
    _seedLotNumberController.text = cropPlanting.seedLotNumber.toString();
    _seedOriginController.text = cropPlanting.seedOrigin!;
    _notesController.text = cropPlanting.notes!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Planting"),
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
                  value: _plantingTypeController,
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
                    // Do something with the selected value
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
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) return Container();

                            // Extract the list of crop names
                            List<DropdownMenuItem<String>> cropItems = snapshot.data!.docs.map((value) {
                              return DropdownMenuItem<String>(
                                value: value.get('name'),
                                child: Text(value.get('name')),
                              );
                            }).toList();

                            // Ensure _cropNameController.text is in the cropItems list
                            if (_cropNameController.text.isNotEmpty && !cropItems.any((item) => item.value == _cropNameController.text)) {
                              _cropNameController.text = '';
                            }

                            return DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Select Crop *',
                                border: OutlineInputBorder(),
                              ),
                              value: _cropNameController.text.isEmpty ? null : _cropNameController.text,
                              items: cropItems,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select necessary fields';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _cropNameController.text = value!;
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
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: getCropVarietyDataViaStream(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) return Container();
                            return DropdownButtonFormField(
                              decoration: const InputDecoration(
                                labelText: 'Select Crop Variety *',
                                border: OutlineInputBorder(),
                              ),
                              isExpanded: false,
                              value: _cropVariety,
                              items: snapshot.data?.docs.map((value) {
                                return DropdownMenuItem(
                                  value: value.get('varietyName'),
                                  child: Text('${value.get('varietyName')}'),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select necessary fields';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _cropVariety = value.toString();
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
                              builder: (context) => AddCropVariety(cropName: cropPlanting.cropName!,),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.greenAccent,
                      ),
                    ),
                  ],
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
                              value: _fieldNameController,
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
                                _fieldNameController = value.toString();
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

  Stream<QuerySnapshot> getCropDataViaStream() async* {
    References r = References();
    String? id = await r.getLoggedUserId();
    yield* r.usersRef.doc(id).collection("crops").snapshots();
  }
  Stream<QuerySnapshot> getFieldDataViaStream() async* {
    References r = References();
    String? id = await r.getLoggedUserId();
    yield* r.usersRef.doc(id).collection("fields").snapshots();
  }
  Stream<QuerySnapshot> getCropVarietyDataViaStream() async* {
    References r = References();
    String? id = await r.getLoggedUserId();
    String? cropId = await r.getCropIdByName(cropPlanting.cropName!);
    yield* r.usersRef.doc(id).collection("crops").doc(cropId).collection("varieties").snapshots();
  }

  Future<void> _saveForm(BuildContext context) async {
    CropPlanting c = CropPlanting(
      plantingDate: _plantingDateController.text,
      plantingType: _plantingTypeController,
      cropName: _cropNameController.text,
      varietyName: _cropVariety,
      fieldName: _fieldNameController,
      firstHarvestDate: _harvestingDateController.text,
      // TODO: Handle null operation wisely here
      quantityPlanted: int.parse(_quantityPlantedController.text), // ?? "0"),
      estimatedYield: int.parse(_estimatedYieldController.text),
      distanceBetweenPlants: _distanceBetweenPlantsController.text,
      seedCompany: _seedCompanyController.text,
      seedType: _seedTypeController.text,
      seedLotNumber: int.parse(_seedLotNumberController.text),
      seedOrigin: _seedOriginController.text,
      notes: _notesController.text,
    );

    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with saving data
      References r = References();
      String? id = await r.getLoggedUserId();

      try {
        // crop name k basis per code lena h
        String? cropId = await r.getCropIdByName(cropPlanting.cropName!);
        String? plantingId = await r.getCropPlantingIdByName(cropId!, cropPlanting.varietyName!, cropPlanting.fieldName!,);
        if (id != null) {
          await r.usersRef.doc(id).collection('crops').doc(cropId).collection("plantings").doc(plantingId).update(
            c.getCropPlantingDataMap(),
          );
          print("Success: Planting updated successfully.");
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
