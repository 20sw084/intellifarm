import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/util/common_methods.dart';
import 'package:intellifarm/widgets/yes_no_radio_button.dart';
import 'package:intl/intl.dart';
import '../../../controller/references.dart';
import '../../../models/harvest.dart'; // Import for date formatting

class EditViewActivityHarvest extends StatelessWidget {
  Harvest harvest;
  EditViewActivityHarvest({super.key, required this.harvest});

  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _harvestDateController =  TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _harvestDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
  String? selectedPlanting;
  YesNoRadioButtonController yesNoController = YesNoRadioButtonController();
  final TextEditingController _plantingNameController =  TextEditingController();
  final TextEditingController _quantityHarvestedController =  TextEditingController();
  final TextEditingController _batchNumberController =  TextEditingController();
  final TextEditingController _harvestQualityController =  TextEditingController();
  final TextEditingController _quantityRejectedController =  TextEditingController();
  final TextEditingController _unitCostController =  TextEditingController();
  final TextEditingController _incomeController =  TextEditingController();
  final TextEditingController _notesController =  TextEditingController();
  String? cropName;
  String? fieldName;
  String? cropVariety;

  @override
  Widget build(BuildContext context) {
    yesNoController.selectedOption = harvest.finalHarvest;
    _harvestDateController.text = harvest.harvestDate!;
    _plantingNameController.text = harvest.plantingToHarvest!;
    _quantityHarvestedController.text = harvest.quantityHarvested.toString();
    _batchNumberController.text = harvest.batchNumber!;
    _harvestQualityController.text = harvest.harvestQuality!;
    _quantityRejectedController.text = harvest.quantityRejected.toString();
    _unitCostController.text = harvest.unitCost.toString();
    _incomeController.text = harvest.incomeFromThisHarvest.toString();
    _notesController.text = harvest.notes!;
    cropName = harvest.plantingToHarvest!.split("|")[0].trim();
    fieldName = harvest.plantingToHarvest!.split("|")[1].trim();
    cropVariety = harvest.plantingToHarvest!.split("|")[2].trim();


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit/View Harvest"),
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
                    controller: _harvestDateController,
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Harvest Date *',
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
                  StreamBuilder<QuerySnapshot>(
                    stream: getAllPlantingsStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return Container();
                      return DropdownButtonFormField(
                        value: _plantingNameController.text.isEmpty ? null : _plantingNameController.text,
                        decoration: const InputDecoration(
                          labelText: 'Select Planting to Harvest *',
                          border: OutlineInputBorder(),
                        ),
                        isExpanded: false,
                        items: snapshot.data?.docs.map((DocumentSnapshot value) {
                          return DropdownMenuItem(
                            value: "${value.get('cropName')} | ${value.get('varietyName')} | ${value.get('fieldName')}",
                            child: Text("${value.get('cropName')} | ${value.get('varietyName')} | ${value.get('fieldName')}"),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select necessary fields';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          selectedPlanting = value as String;
                          _plantingNameController.text = selectedPlanting!;
                          cropName = value.toString().split("|")[0].trim();
                          fieldName = value.toString().split("|")[1].trim();
                          cropVariety = value.toString().split("|")[2].trim();
                        },
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _quantityHarvestedController,
                    decoration: InputDecoration(
                      labelText: 'Quantity Harvested (Bushels)  *',
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
                    controller: _batchNumberController,
                    decoration: InputDecoration(
                      labelText: 'Batch Number (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _harvestQualityController,
                    decoration: InputDecoration(
                      labelText: 'Harvest Quality (e.g A, B, etc)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Is this a final harvest for the planting?"),
                      ),
                      YesNoRadioButton(controller: yesNoController),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text("Harvest Income (Optional, can be filled later after selling the harvest)."),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _quantityRejectedController,
                    decoration: InputDecoration(
                      labelText: 'Quantity Rejected (Bushels)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _unitCostController,
                    decoration: InputDecoration(
                      labelText: 'Unit Cost',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _incomeController,
                    decoration: InputDecoration(
                      labelText: 'Income from this Harvest',
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

      if (cropName == null || fieldName == null || cropVariety == null) {
        print("Error: Some required values are null");
        return; // Exit the function early if any required value is null
      }

      try {
        String? cropId = await r.getCropIdByName(cropName!);
        if (cropId == null) {
          print("Error: cropId is null");
          return; // Exit the function early if cropId is null
        }
        String? plantingId = await r.getPlantingIdByFieldAndCropVariety(cropId, cropVariety! ,fieldName!,);
        if (plantingId == null) {
          print("Error: plantingId is null");
          return; // Exit the function early if plantingId is null
        }

        Harvest c = Harvest(
          harvestDate: _harvestDateController.text,
          plantingToHarvest: harvest.plantingToHarvest,
          quantityHarvested: int.tryParse(_quantityHarvestedController.text),
          batchNumber: _batchNumberController.text,
          harvestQuality: _harvestQualityController.text,
          finalHarvest: yesNoController.selectedOption,
          quantityRejected: int.tryParse(_quantityRejectedController.text),
          unitCost: int.tryParse(_unitCostController.text),
          incomeFromThisHarvest: int.tryParse(_incomeController.text),
          notes: _notesController.text,
        );

        String? harvestId = await r.getHarvestIdByName(cropId, plantingId, c.plantingToHarvest!);

        await r.usersRef.doc(id).collection('crops').doc(cropId).collection("plantings").doc(plantingId).collection("harvests").doc(harvestId).update(
          c.getHarvestDataMap(),
        );

        print("Success: Harvest updated successfully.");
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }
  }

}



// import 'package:flutter/material.dart';
// import 'package:intellifarm/util/planting_type_enum.dart';
// import 'package:intellifarm/widgets/yes_no_radio_button.dart';
// import 'package:intl/intl.dart';
//
// // TODO: Look at this, if add crop planting and add activity planting are same at last
//
// class EditViewActivityHarvest extends StatelessWidget {
//   EditViewActivityHarvest({super.key});
//
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _dateController = TextEditingController();
//   DateTime? _selectedDate;
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate) {
//       _selectedDate = picked;
//       _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit/View Harvest"),
//         backgroundColor: Colors.greenAccent,
//         actions: [
//           IconButton(
//             onPressed: () {
//               _saveForm(context);
//             },
//             icon: Icon(Icons.check_box),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 SizedBox(height: 30),
//                 TextFormField(
//                   controller: _dateController,
//                   onTap: () => _selectDate(context),
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     labelText: 'Harvest Date *',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'This field is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 // TODO: (Incomplete alert) yahan data read hoga plantings ka
//                 DropdownButtonFormField<PlantingType>(
//                   decoration: InputDecoration(
//                     labelText: 'Select Planting to Harvest *',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: PlantingType.values
//                       .map((option) => DropdownMenuItem<PlantingType>(
//                     value: option,
//                     child: Text(option.toString().split('.')[1]),
//                   ))
//                       .toList(),
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Please select necessary fields';
//                     }
//                     return null;
//                   },
//                   onChanged: (PlantingType? newValue) {
//                     // Do something with the selected value
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Quantity Harvested (Bushels)  *',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'This field is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Batch Number (Optional)',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Harvest Quality (e.g A, B, etc)',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text("Is this a final harvest for the planting?"),
//                     ),
//                     YesNoRadioButton(controller: YesNoRadioButtonController(),),
//                   ],
//                 ),
//                 SizedBox(height: 30),
//                 Text("Harvest Income (Optional, can be filled later after selling the harvest)."),
//                 SizedBox(height: 30),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Kuantity Rejected (Bushels)',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Unit Cost',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Income from this Harvest',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Notes (for your convenience)',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 4,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _saveForm(BuildContext context) {
//     if (_formKey.currentState!.validate()) {
//       // Form is valid, proceed with saving data
//       Navigator.pop(context);
//     }
//   }
// }
