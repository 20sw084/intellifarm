import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../controller/references.dart';
import '../../../models/task.dart';
import '../../../util/common_methods.dart';
import '../../../util/task_specific_to_planting_enum.dart';
import '../../../util/task_status_enum.dart';
import '../../farmers_crops_fields_screens/field_screens/add_field_record.dart'; // Import for date formatting

class EditActivityTask extends StatelessWidget {
  Task task;
  EditActivityTask({super.key, required this.task,});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskDateController = TextEditingController();
  DateTime? _selectedDate;

  final TextEditingController _taskNameController =  TextEditingController();
  final TextEditingController _fieldNameController =  TextEditingController();
  final TextEditingController _plantingNameController =  TextEditingController();
  final TextEditingController _notesController =  TextEditingController();

  String? cropName;
  String? cropVariety;
  String? _selectedFieldName; // Initialize this to null or a default value if necessary

  final ValueNotifier<TaskSpecificToPlanting?> _selectedTaskSpecificToPlanting = ValueNotifier<TaskSpecificToPlanting?>(null);
  final ValueNotifier<TaskStatus?> _selectedTaskStatus = ValueNotifier<TaskStatus?>(null);


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _taskDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    _taskDateController.text = task.taskDate;
    _selectedTaskStatus.value = task.taskStatus;
    _taskNameController.text = task.taskName;
    _selectedTaskSpecificToPlanting.value = task.taskSpecificToPlanting;
    _plantingNameController.text = task.plantingName ?? " ";
    _fieldNameController.text = task.fieldName;
    _notesController.text = task.notes ?? "";
    _selectedFieldName = task.fieldName;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task"),
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
                  controller: _taskDateController,
                  onTap: () => _selectDate(context),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Task Date *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Text("Status (Auto-filled, depends on date selected)"),
                SizedBox(height: 15),
                DropdownButtonFormField<TaskStatus>(
                  value: _selectedTaskStatus.value,
                  decoration: InputDecoration(
                    labelText: 'Select Status of Task *',
                    border: OutlineInputBorder(),
                  ),
                  items: TaskStatus.values
                      .map((option) => DropdownMenuItem<TaskStatus>(
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
                  onChanged: (TaskStatus? newValue) {
                    _selectedTaskStatus.value = newValue;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _taskNameController,
                  decoration: InputDecoration(
                    labelText: 'Task name *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select necessary fields';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                DropdownButtonFormField<TaskSpecificToPlanting>(
                  value: _selectedTaskSpecificToPlanting.value,
                  decoration: InputDecoration(
                    labelText: 'Task Specific to Planting *',
                    border: OutlineInputBorder(),
                  ),
                  items: TaskSpecificToPlanting.values
                      .map((option) => DropdownMenuItem<TaskSpecificToPlanting>(
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
                  onChanged: (TaskSpecificToPlanting? newValue) {
                    _selectedTaskSpecificToPlanting.value = newValue; // Update the notifier value
                  },
                ),
                SizedBox(height: 30),
              ValueListenableBuilder<TaskSpecificToPlanting?>(
                valueListenable: _selectedTaskSpecificToPlanting,
                builder: (context, value, child) {
                  if (value == TaskSpecificToPlanting.Yes) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: getAllPlantingsStream(), // Replace this with your actual Firestore stream
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return Container(); // Or show a loading indicator

                        // Create a list of dropdown items
                        List<DropdownMenuItem<String>> items = snapshot.data?.docs.map((DocumentSnapshot doc) {
                          String combinedValue = "${doc.get('cropName')} | ${doc.get('varietyName')} | ${doc.get('plantingDate')}";
                          return DropdownMenuItem<String>(
                            value: combinedValue,
                            child: Text(combinedValue),
                          );
                        }).toList() ?? [];

                        // Ensure the controller's value matches one of the items
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
        Task t = Task(
          taskDate: _taskDateController.text,
          taskStatus: _selectedTaskStatus.value!,
          taskName: _taskNameController.text,
          fieldName: _fieldNameController.text,
          taskSpecificToPlanting: _selectedTaskSpecificToPlanting.value!,
          plantingName: _selectedTaskSpecificToPlanting.value == TaskSpecificToPlanting.Yes && _plantingNameController.text.contains("|")
              ? "${_plantingNameController.text.split("|").first.trim()} | ${_plantingNameController.text.split("|")[1].trim()}"
              : "",
          notes: _notesController.text,
        );

        // Split plantingName only if TreatmentSpecificToPlanting is 'Yes'
        if (task.taskSpecificToPlanting == TaskSpecificToPlanting.Yes) {
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

          String? taskId = await r.getTaskIdOfYes(task.fieldName, cropId, plantingId);
          if (taskId == null) {
            print("Error: taskId is null");
            return; // Exit the function early if plantingId is null
          }

          await r.usersRef.doc(id).collection('crops').doc(cropId).collection("plantings").doc(plantingId).collection("tasks").doc(taskId).update(
            t.getTaskDataMap(),
          );
          print("Success: Task updated successfully in Crop Plantings.");
        }

        else if (task.taskSpecificToPlanting == TaskSpecificToPlanting.No) {
          if (t.fieldName.isEmpty) {
            print("Error: fieldName is empty");
            return; // Exit the function early if fieldName is empty
          }

          String? fieldId = await r.getFieldIdByName(t.fieldName);
          if (fieldId == null) {
            print("Error: fieldId is null");
            return; // Exit the function early if fieldId is null
          }

          String? taskId = await r.getTaskIdOfNo(task.fieldName, fieldId);
          if (taskId == null) {
            print("Error: taskId is null");
            return; // Exit the function early if plantingId is null
          }

          await r.usersRef.doc(id).collection('fields').doc(fieldId).collection("tasks").doc(taskId).update(
            t.getTaskDataMap(),
          );
          print("Success: Task updated successfully in Fields.");
        } else {
          print("Error: Unexpected taskSpecificToPlanting value");
        }

        Navigator.pop(context);
      } catch (e) {
        print("Error: $e");
      }
    }
  }
}
