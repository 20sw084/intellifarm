import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/util/planting_type_enum.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../controller/references.dart';
import '../../../models/crops/cropPlanting.dart';
import '../../../providers/field_provider.dart';
import '../../../util/field_status_after_planting_enum.dart';
import '../crop_screens/add_crop_record.dart';
import '../crop_screens/add_crop_variety.dart';

class AddFieldPlanting extends StatefulWidget {
  final String fieldName;
  const AddFieldPlanting({
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
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String?> cropNameNotifier = ValueNotifier<String?>(null);

  final ValueNotifier<String?> cropVarietyNotifier =  ValueNotifier<String?>(null);

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
      body: Stack(
        children: [
          Padding(
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
                              // color: Colors.white,
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
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      }
                                      if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      }
                                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                                              String varietyName = doc.get('varietyName');
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
                                              _cropVariety = value.toString();
                                              cropVarietyNotifier.value = value;
                                              debugPrint('Selected crop variety: $value');
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddCropVariety(cropName: cropName),
                                      ),
                                    );
                                  },
                                  backgroundColor: Color(0xff727530),
                                  foregroundColor: Colors.white,
                                  child: Icon(Icons.add),
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
                            child: TextFormField(
                              initialValue: widget.fieldName,
                              decoration: InputDecoration(
                                labelText: 'Field Name',
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
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
          ValueListenableBuilder<bool>(
            valueListenable: _isLoadingNotifier,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text(
                          'Saving...',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _isLoadingNotifier.value = true;

      CropPlanting c = CropPlanting(
        plantingDate: _plantingDateController.text,
        plantingType: _plantingTypeController,
        cropName: cropName,
        varietyName: _cropVariety,
        fieldName: widget.fieldName,
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

      References r = References();
      String? id = await r.getLoggedUserId();

      try {
        String? cropId = await r.getCropIdByName(cropName!);
        if (id != null) {
          await r.usersRef
              .doc(id)
              .collection('crops')
              .doc(cropId)
              .collection("plantings")
              .add(
            c.getCropPlantingDataMap(),
          );
          String? fieldId = await r.getFieldIdByName(c.fieldName!);
          await r.usersRef.doc(id).collection('fields').doc(fieldId).update({
            "fieldStatus":
            _fieldStatusAfterPlantingController.toString().split(".").last,
          });

          Provider.of<FieldProvider>(context, listen: false).needsRefresh =
          true;
          Navigator.pop(context);
        } else {
          if (kDebugMode) {
            print("Error: User ID is null");
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      } finally {
        _isLoadingNotifier.value = false;
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
      yield* r.usersRef
          .doc(id)
          .collection("crops")
          .doc(cropId)
          .collection("varieties")
          .snapshots();
    } else {
      yield* Stream.empty();
    }
  }
}