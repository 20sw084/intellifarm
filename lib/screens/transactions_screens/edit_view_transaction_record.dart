import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellifarm/util/transaction_specific_to_field_enum.dart';
import 'package:intellifarm/util/type_of_income_enum.dart';
import 'package:intl/intl.dart';
import '../../controller/references.dart';
import '../../models/transaction.dart';
import '../../util/common_methods.dart';
import '../../util/transaction_specific_to_planting_enum.dart';
import '../../util/type_of_expense_enum.dart';

class EditViewTransactionRecord extends StatelessWidget {
  final TransactionModel transaction;
  final String type;
  EditViewTransactionRecord({super.key, required this.type, required this.transaction});
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _transactionDateController = TextEditingController();
  final TextEditingController _earningAmountController =  TextEditingController();
  final TextEditingController _plantingNameTransactionController =  TextEditingController();
  final TextEditingController _incomeTypeOtherController =  TextEditingController();
  final TextEditingController _expenseTypeOtherController =  TextEditingController();
  final TextEditingController _receiptNumberController =  TextEditingController();
  final TextEditingController _customerNameController =  TextEditingController();
  final TextEditingController _notesController =  TextEditingController();
  String? cropName;
  String? cropVariety;
  String? _selectedFieldName;

  // TODO : Change the query from add to update transactions.

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _transactionDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
  final ValueNotifier<TransactionSpecificToField?> _selectedTransactionSpecificToField = ValueNotifier<TransactionSpecificToField?>(null);
  final ValueNotifier<TransactionSpecificToPlanting?> _selectedTransactionSpecificToPlanting = ValueNotifier<TransactionSpecificToPlanting?>(null);
  final ValueNotifier<TypeOfIncome?> _selectedTypeOfIncome = ValueNotifier<TypeOfIncome?>(null);
  final ValueNotifier<TypeOfExpense?> _selectedTypeOfExpense = ValueNotifier<TypeOfExpense?>(null);
  final ValueNotifier<bool> _fieldSelected = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    _transactionDateController.text = transaction.transactionDate;
    _earningAmountController.text = transaction.earningAmount.toString();
    _plantingNameTransactionController.text = transaction.plantingNameTransaction!;
    _incomeTypeOtherController.text = transaction.transactionTypeOther!;
    _expenseTypeOtherController.text = transaction.transactionTypeOther!;
    _receiptNumberController.text = transaction.receiptNumber!;
    _customerNameController.text = transaction.customerName!;
    _notesController.text = transaction.notes!;
    _selectedFieldName = transaction.fieldName;
    _selectedTransactionSpecificToField.value = transaction.transactionSpecificToField;
    _selectedTransactionSpecificToPlanting.value = transaction.transactionSpecificToPlanting;
    if (transaction.typeOfTransaction.split(".").first == "TypeOfIncome") {
      // If the transaction is of income type, set the income value
      _selectedTypeOfIncome.value = typeOfIncomeFromString(transaction.typeOfTransaction);
      _selectedTypeOfExpense.value = null; // Clear the expense value
    } else if (transaction.typeOfTransaction.split(".").first == "TypeOfExpense") {
      // If the transaction is of expense type, set the expense value
      _selectedTypeOfExpense.value = typeOfExpenseFromString(transaction.typeOfTransaction);
      _selectedTypeOfIncome.value = null; // Clear the income value
    }

    _fieldSelected.value = transaction.fieldName?.isNotEmpty ?? false;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit/View $type"),
          backgroundColor: Color(0xff727530),
          foregroundColor: Colors.white,
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
                  SizedBox(height: 15),
                  DropdownButtonFormField<TransactionSpecificToField>(
                    value: _selectedTransactionSpecificToField.value,
                    decoration: InputDecoration(
                      labelText: 'Transaction Specific To a Field? *',
                      border: OutlineInputBorder(),
                    ),
                    items: TransactionSpecificToField.values
                        .map((option) => DropdownMenuItem<TransactionSpecificToField>(
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
                    onChanged: (TransactionSpecificToField? newValue) {
                      _selectedTransactionSpecificToField.value = newValue; // Update the notifier value
                    },
                  ),
                  SizedBox(height: 15),
                  ValueListenableBuilder<TransactionSpecificToField?>(
                    valueListenable: _selectedTransactionSpecificToField,
                    builder: (context, value, child) {
                      if (value == TransactionSpecificToField.Yes) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: getFieldDataViaStream(), // Replace this with your actual Firestore stream
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) return Container(); // Or show a loading indicator
                            return DropdownButtonFormField(
                              decoration: const InputDecoration(
                                labelText: 'Select Field *',
                                border: OutlineInputBorder(),
                              ),
                              isExpanded: false,
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
                                // Handle value change for field selection
                                _fieldSelected.value = value != null;
                                _selectedFieldName = value.toString();
                              },
                            );
                          },
                        );
                      } else {
                        return SizedBox.shrink(); // No field shown
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  ValueListenableBuilder<bool>(
                    valueListenable: _fieldSelected,
                    builder: (context, fieldSelected, child) {
                      if (fieldSelected) {
                        return Column(
                          children: [
                            // Transaction Specific to Planting dropdown
                            DropdownButtonFormField<TransactionSpecificToPlanting>(
                              value: _selectedTransactionSpecificToPlanting.value,
                              decoration: InputDecoration(
                                labelText: 'Transaction Specific to Planting *',
                                border: OutlineInputBorder(),
                              ),
                              items: TransactionSpecificToPlanting.values
                                  .map((option) => DropdownMenuItem<TransactionSpecificToPlanting>(
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
                              onChanged: (TransactionSpecificToPlanting? newValue) {
                                _selectedTransactionSpecificToPlanting.value = newValue; // Update the notifier value
                              },
                            ),
                            SizedBox(height: 15),
                            // Show Planting Dropdown if "Transaction Specific to Planting" is Yes
                            ValueListenableBuilder<TransactionSpecificToPlanting?>(
                              valueListenable: _selectedTransactionSpecificToPlanting,
                              builder: (context, value, child) {
                                if (value == TransactionSpecificToPlanting.Yes) {
                                  return StreamBuilder<QuerySnapshot>(
                                    stream: getAllPlantingsStream(), // Replace this with your actual Firestore stream
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) return Container(); // Or show a loading indicator
      
                                      return DropdownButtonFormField(
                                        value: _plantingNameTransactionController.text.isEmpty ? null : _plantingNameTransactionController.text,
                                        decoration: const InputDecoration(
                                          labelText: 'Select Planting *',
                                          border: OutlineInputBorder(),
                                        ),
                                        isExpanded: false,
                                        items: snapshot.data?.docs.map((DocumentSnapshot value) {
                                          return DropdownMenuItem(
                                            value: "${value.get('cropName')} | ${value.get('varietyName')} | ${value.get('plantingDate')}",
                                            child: Text("${value.get('cropName')} | ${value.get('varietyName')} | ${value.get('plantingDate')}"),
                                          );
                                        }).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select necessary fields';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          _plantingNameTransactionController.text = value.toString();
                                          cropName = value?.split("|")[0].trim();
                                          cropVariety = value?.split("|")[2].trim();
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  return SizedBox.shrink(); // No field shown
                                }
                              },
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink(); // No second set of fields shown
                      }
                    },
                  ),
                  // TODO: ADD the Category class in income and expense (Impact: Optional)
                  SizedBox(height: 15),
                  if(type == "Income")
                    DropdownButtonFormField<TypeOfIncome>(
                      value: _selectedTypeOfIncome.value,
                      decoration: InputDecoration(
                        labelText: 'Type Of Income *',
                        border: OutlineInputBorder(),
                      ),
                      items: TypeOfIncome.values
                          .map((option) => DropdownMenuItem<TypeOfIncome>(
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
                      onChanged: (TypeOfIncome? newValue) {
                        _selectedTypeOfIncome.value = newValue;
                      },
                    ),
                  SizedBox(height: 15),
                  if(type == "Income")
                    ValueListenableBuilder<TypeOfIncome?>(
                      valueListenable: _selectedTypeOfIncome,
                      builder: (context, value, child) {
                        if (value == TypeOfIncome.Other) {
                          return TextFormField(
                            controller: _incomeTypeOtherController,
                            decoration: InputDecoration(
                              labelText: 'Please specify other income *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              return null;
                            },
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  if(type == "Expense")
                    DropdownButtonFormField<TypeOfExpense>(
                      value: _selectedTypeOfExpense.value,
                      decoration: InputDecoration(
                        labelText: 'Type Of Expense *',
                        border: OutlineInputBorder(),
                      ),
                      items: TypeOfExpense.values
                          .map((option) => DropdownMenuItem<TypeOfExpense>(
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
                      onChanged: (TypeOfExpense? newValue) {
                        _selectedTypeOfExpense.value = newValue;
                      },
                    ),
                  SizedBox(height: 15),
                  if(type == "Expense")
                    ValueListenableBuilder<TypeOfExpense?>(
                      valueListenable: _selectedTypeOfExpense,
                      builder: (context, value, child) {
                        if (value == TypeOfExpense.Other) {
                          return TextFormField(
                            controller: _expenseTypeOtherController,
                            decoration: InputDecoration(
                              labelText: 'Please specify the expense *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              return null;
                            },
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _earningAmountController,
                    decoration: InputDecoration(
                      labelText: 'How much did you ${type == "Income"?"earn":"spend"} *',
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
                    controller: _transactionDateController,
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date of $type *',
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
                    controller: _receiptNumberController,
                    decoration: InputDecoration(
                      labelText: 'Receipt # (Optional) ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _customerNameController,
                    decoration: InputDecoration(
                      labelText: 'Name of Customer',
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

      try {
        if(type == "Income") {
          TransactionModel t = TransactionModel(
            transactionSpecificToField: _selectedTransactionSpecificToField
                .value!,
            typeOfTransaction: _selectedTypeOfIncome.value.toString(),
            earningAmount: int.parse(_earningAmountController.text),
            transactionDate: _transactionDateController.text,
            fieldName: _selectedFieldName,
            transactionSpecificToPlanting: _selectedTransactionSpecificToPlanting
                .value,
            plantingNameTransaction: _plantingNameTransactionController.text,
            transactionTypeOther: _incomeTypeOtherController.text,
            customerName: _customerNameController.text,
            receiptNumber: _receiptNumberController.text,
            notes: _notesController.text,
          );

          if (_selectedTransactionSpecificToField.value ==
              TransactionSpecificToField.Yes) {
            if (t.fieldName == null || t.fieldName!.isEmpty) {
              print("Error: Field name is null or empty");
              return;
            }

            if (_selectedTransactionSpecificToPlanting.value ==
                TransactionSpecificToPlanting.Yes) {
              if (t.plantingNameTransaction == null ||
                  t.plantingNameTransaction!.isEmpty) {
                print("Error: Planting name is null or empty");
                return;
              }

              List<String> plantingParts = t.plantingNameTransaction!
                  .split("|")
                  .map((part) => part.trim())
                  .toList();
              if (plantingParts.length < 2) {
                print("Error: Planting name does not have the correct format");
                return;
              }

              cropName = plantingParts[0];
              cropVariety = plantingParts[1];

              // fieldName = t.fieldName;

              if (cropName == null || _selectedFieldName == null ||
                  cropVariety == null) {
                print("Error: Some required values are null");
                return; // Exit the function early if any required value is null
              }

              String? cropId = await r.getCropIdByName(cropName!);
              if (cropId == null) {
                print("Error: cropId is null");
                return; // Exit the function early if cropId is null
              }

              String? plantingId = await r.getPlantingIdByFieldAndCropVariety(
                  cropId, _selectedFieldName!, cropVariety!);
              if (plantingId == null) {
                print("Error: plantingId is null");
                return; // Exit the function early if plantingId is null
              }
              await r.usersRef.doc(id).collection('crops').doc(cropId)
                  .collection("plantings").doc(plantingId).collection(
                  "transactions")
                  .add(
                t.getTransactionDataMap(),
              );
              print("Success: Transaction added successfully in Crop Plantings.");
            }

            else if (_selectedTransactionSpecificToPlanting.value ==
                TransactionSpecificToPlanting.No) {
              String? fieldId = await r.getFieldIdByName(t.fieldName!);
              if (fieldId == null) {
                print("Error: fieldId is null");
                return; // Exit the function early if fieldId is null
              }
              await r.usersRef.doc(id).collection('fields')
                  .doc(fieldId)
                  .collection("transactions")
                  .add(
                t.getTransactionDataMap(),
              );
              print("Success: Transaction added successfully in Fields.");
            }

            else {
              print("Error: Unexpected transactionSpecificToPlanting value");
            }

            // List<String> plantingParts = t.fieldName!.split("|").map((part) => part.trim()).toList();
            // if (plantingParts.length != 2) {
            //   print("Error: Planting name does not have the correct format");
            //   return;
            // }
            //
            // cropName = plantingParts[0];
            // cropVariety = plantingParts[1];
            //
            // // fieldName = t.fieldName;
            //
            // if (cropName == null || _selectedFieldName == null || cropVariety == null) {
            //   print("Error: Some required values are null");
            //   return; // Exit the function early if any required value is null
            // }
            //
            // String? cropId = await r.getCropIdByName(cropName!);
            // if (cropId == null) {
            //   print("Error: cropId is null");
            //   return; // Exit the function early if cropId is null
            // }
            //
            // String? plantingId = await r.getPlantingIdByFieldAndCropVariety(cropId, _selectedFieldName!, cropVariety!);
            // if (plantingId == null) {
            //   print("Error: plantingId is null");
            //   return; // Exit the function early if plantingId is null
            // }
            // await r.usersRef.doc(id).collection('crops').doc(cropId).collection("plantings").doc(plantingId).collection("treatments").add(
            //   t.getTransactionDataMap(),
            // );
            // print("Success: Treatment added successfully in Crop Plantings.");
          }

          else if (_selectedTransactionSpecificToField.value ==
              TransactionSpecificToField.No) {
            await r.usersRef.doc(id).collection('transactions').add(
              t.getTransactionDataMap(),
            );
            print("Success: Transaction added successfully in Users.");
          }

          else {
            print("Error: Unexpected transactionSpecificToPlanting value");
          }
        }
        else {
          TransactionModel t = TransactionModel(
            transactionSpecificToField: _selectedTransactionSpecificToField
                .value!,
            typeOfTransaction: _selectedTypeOfExpense.value.toString(),
            earningAmount: int.parse(_earningAmountController.text),
            transactionDate: _transactionDateController.text,
            fieldName: _selectedFieldName,
            transactionSpecificToPlanting: _selectedTransactionSpecificToPlanting
                .value,
            plantingNameTransaction: _plantingNameTransactionController.text,
            transactionTypeOther: _expenseTypeOtherController.text,
            customerName: _customerNameController.text,
            receiptNumber: _receiptNumberController.text,
            notes: _notesController.text,
          );

          if (_selectedTransactionSpecificToField.value ==
              TransactionSpecificToField.Yes) {
            if (t.fieldName == null || t.fieldName!.isEmpty) {
              print("Error: Field name is null or empty");
              return;
            }

            if (_selectedTransactionSpecificToPlanting.value ==
                TransactionSpecificToPlanting.Yes) {
              if (t.plantingNameTransaction == null ||
                  t.plantingNameTransaction!.isEmpty) {
                print("Error: Planting name is null or empty");
                return;
              }

              List<String> plantingParts = t.plantingNameTransaction!
                  .split("|")
                  .map((part) => part.trim())
                  .toList();
              if (plantingParts.length < 2) {
                print("Error: Planting name does not have the correct format");
                return;
              }

              cropName = plantingParts[0];
              cropVariety = plantingParts[1];

              // fieldName = t.fieldName;

              if (cropName == null || _selectedFieldName == null ||
                  cropVariety == null) {
                print("Error: Some required values are null");
                return; // Exit the function early if any required value is null
              }

              String? cropId = await r.getCropIdByName(cropName!);
              if (cropId == null) {
                print("Error: cropId is null");
                return; // Exit the function early if cropId is null
              }

              String? plantingId = await r.getPlantingIdByFieldAndCropVariety(
                  cropId, _selectedFieldName!, cropVariety!);
              if (plantingId == null) {
                print("Error: plantingId is null");
                return; // Exit the function early if plantingId is null
              }
              await r.usersRef.doc(id).collection('crops').doc(cropId)
                  .collection("plantings").doc(plantingId).collection(
                  "transactions")
                  .add(
                t.getTransactionDataMap(),
              );
              print(
                  "Success: Transaction added successfully in Crop Plantings.");
            }

            else if (_selectedTransactionSpecificToPlanting.value ==
                TransactionSpecificToPlanting.No) {
              String? fieldId = await r.getFieldIdByName(t.fieldName!);
              if (fieldId == null) {
                print("Error: fieldId is null");
                return; // Exit the function early if fieldId is null
              }
              await r.usersRef.doc(id).collection('fields')
                  .doc(fieldId)
                  .collection("transactions")
                  .add(
                t.getTransactionDataMap(),
              );
              print("Success: Transaction added successfully in Fields.");
            }

            else {
              print("Error: Unexpected transactionSpecificToPlanting value");
            }

            // List<String> plantingParts = t.fieldName!.split("|").map((part) => part.trim()).toList();
            // if (plantingParts.length != 2) {
            //   print("Error: Planting name does not have the correct format");
            //   return;
            // }
            //
            // cropName = plantingParts[0];
            // cropVariety = plantingParts[1];
            //
            // // fieldName = t.fieldName;
            //
            // if (cropName == null || _selectedFieldName == null || cropVariety == null) {
            //   print("Error: Some required values are null");
            //   return; // Exit the function early if any required value is null
            // }
            //
            // String? cropId = await r.getCropIdByName(cropName!);
            // if (cropId == null) {
            //   print("Error: cropId is null");
            //   return; // Exit the function early if cropId is null
            // }
            //
            // String? plantingId = await r.getPlantingIdByFieldAndCropVariety(cropId, _selectedFieldName!, cropVariety!);
            // if (plantingId == null) {
            //   print("Error: plantingId is null");
            //   return; // Exit the function early if plantingId is null
            // }
            // await r.usersRef.doc(id).collection('crops').doc(cropId).collection("plantings").doc(plantingId).collection("treatments").add(
            //   t.getTransactionDataMap(),
            // );
            // print("Success: Treatment added successfully in Crop Plantings.");
          }

          else if (_selectedTransactionSpecificToField.value ==
              TransactionSpecificToField.No) {
            await r.usersRef.doc(id).collection('transactions').add(
              t.getTransactionDataMap(),
            );
            print("Success: Transaction added successfully in Users.");
          }

          else {
            print("Error: Unexpected transactionSpecificToPlanting value");
          }
        }
        Navigator.pop(context);
      } catch (e) {
        print("Error: $e");
      }
    }
  }
}
