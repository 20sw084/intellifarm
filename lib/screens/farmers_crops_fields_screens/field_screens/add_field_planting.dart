import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/util/planting_type_enum.dart';
import 'package:intl/intl.dart';
import '../../../controller/references.dart';
import '../../../models/crops/cropPlanting.dart';
import '../../../util/field_status_after_planting_enum.dart';
import '../crop_screens/add_crop_record.dart';
import '../crop_screens/add_crop_variety.dart';
import 'add_field_record.dart';

class AddFieldPlanting extends StatefulWidget {
  String fieldName;
  AddFieldPlanting({
    super.key,
    required this.fieldName,
  });

  @override
  AddFieldPlantingState createState() => AddFieldPlantingState();
}

class AddFieldPlantingState extends State<AddFieldPlanting> {
  final _formKey = GlobalKey<FormState>();
  String? cropName;

  final TextEditingController _plantingDateController = TextEditingController();
  PlantingType? _plantingTypeController;
  FieldStatusAfterPlanting? _fieldStatusAfterPlantingController;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("New Planting"),
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
                // Other fields...
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
                  },
                ),
                SizedBox(height: 30),
                // Crop selection field
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
                              value: cropName,
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
                                setState(() {
                                  cropName = value.toString();
                                  _cropVariety = null; // Reset crop variety
                                });
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
                if (cropName != null)
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
                                  setState(() {
                                    _cropVariety = value.toString();
                                  });
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
                                builder: (context) => AddCropVariety(cropName: cropName!,),
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
                              value: widget.fieldName,
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
                                // debugPrint('selected onchange: $value');
                                widget.fieldName = value.toString();
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
                DropdownButtonFormField<FieldStatusAfterPlanting>(
                  value: _fieldStatusAfterPlantingController,
                  decoration: InputDecoration(
                    labelText: 'Select field status after Planting *',
                    border: OutlineInputBorder(),
                  ),
                  items: FieldStatusAfterPlanting.values
                      .map((option) =>
                      DropdownMenuItem<FieldStatusAfterPlanting>(
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
                  onChanged: (FieldStatusAfterPlanting? newValue) {
                    // Do something with the selected value
                    _fieldStatusAfterPlantingController = newValue;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _harvestingDateController,
                  onTap: () => _selectHarvestingDate(context),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'First Harvesting Date',
                    border: OutlineInputBorder(),
                  ),
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
                // Other fields...
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveForm(BuildContext context) async {
    CropPlanting c = CropPlanting(
      plantingDate: _plantingDateController.text,
      plantingType: _plantingTypeController,
      cropName: cropName,
      varietyName: _cropVariety,
      fieldName: widget.fieldName,
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
        String? cropId = await r.getCropIdByName(cropName!);
        if (id != null) {
          await r.usersRef.doc(id).collection('crops').doc(cropId).collection("plantings").add(
            c.getCropPlantingDataMap(),
          );
          String? fieldId = await r.getFieldIdByName(c.fieldName!);
          await r.usersRef
              .doc(id)
              .collection('fields')
              .doc(fieldId)
              .update(
              {"fieldStatus" : _fieldStatusAfterPlantingController.toString().split(".").last,}
          );
          print("Success: Planting added successfully.");
          Navigator.pop(context);
        } else {
          print("Error: User ID is null");
        }
      } catch (e) {
        print(e);
      }
    }
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
    if (cropName != null) {
      String? cropId = await r.getCropIdByName(cropName!);
      yield* r.usersRef.doc(id).collection("crops").doc(cropId).collection("varieties").snapshots();
    } else {
      yield* Stream.empty();
    }
  }
}

