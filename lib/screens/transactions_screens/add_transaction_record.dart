import 'package:flutter/material.dart';
import 'package:intellifarm/util/transaction_specific_to_field_enum.dart';
import 'package:intellifarm/util/type_of_income_enum.dart';
import 'package:intl/intl.dart';

class AddTransactionRecord extends StatelessWidget {
  String type;
  AddTransactionRecord({super.key, required this.type,});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New $type"),
        backgroundColor: Colors.greenAccent,
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
                SizedBox(height: 30),
                DropdownButtonFormField<TransactionSpecificToField>(
                  decoration: InputDecoration(
                    labelText: 'Transaction Specific To a Field?',
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
                    // Do something with the selected value
                  },
                ),
                SizedBox(height: 30),
                // TODO: Make Select Field as Dropdown and sync data of fields from database
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Select Field  *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                // TODO: Transaction specific to Planting ka dropdown ayega
                // TODO: one more DD of that planting name
                SizedBox(height: 30),
                // TODO:
                DropdownButtonFormField<TypeOfIncome>(
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
                    // TODO: Choose Category or other pr extra field aaegi
                    if(newValue ==  TypeOfIncome.ChooseCategory){
                      print("Chooose Category");
                    } else if(newValue ==  TypeOfIncome.FromHarvest){
                      print("From Harvest");
                    } else if(newValue ==  TypeOfIncome.Other){
                      print("Others");
                    }
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'How much did you earn *',
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
                  controller: _dateController,
                  onTap: () => _selectDate(context),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date of Income *',
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
                  decoration: InputDecoration(
                    labelText: 'Reciept # (Optional) ',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name of Customer',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
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
  void _saveForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with saving data
      Navigator.pop(context);
    }
  }
}
