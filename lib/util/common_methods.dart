import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intellifarm/util/task_specific_to_planting_enum.dart';
import 'package:intellifarm/util/task_status_enum.dart';
import 'package:intellifarm/util/transaction_specific_to_field_enum.dart';
import 'package:intellifarm/util/transaction_specific_to_planting_enum.dart';
import 'package:intellifarm/util/treatment_specific_to_planting_enum.dart';
import 'package:intellifarm/util/treatment_status_enum.dart';
import 'package:intellifarm/util/treatment_type_enum.dart';
import 'package:intellifarm/util/type_of_expense_enum.dart';
import 'package:intellifarm/util/type_of_income_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/references.dart';
import '../wrapper.dart';
import 'planting_type_enum.dart';
import 'field_status_enum.dart';
import 'field_type_enum.dart';
import 'light_profile_enum.dart';
import "package:flutter/material.dart";

TreatmentType treatmentTypeFromString(String type) {
  switch (type) {
    case 'Fertilizer':
      return TreatmentType.Fertilizer;
    case 'Fungicide':
      return TreatmentType.Fungicide;
    case 'Herbicide':
      return TreatmentType.Herbicide;
    case 'Insecticide':
      return TreatmentType.Insecticide;
    case 'Nutrients':
      return TreatmentType.Nutrients;
    case 'Other':
      return TreatmentType.Other;
    default:
      throw Exception('Unknown field type');
  }
}

TreatmentStatus treatmentStatusFromString(String type) {
  switch (type) {
    case 'Planned':
      return TreatmentStatus.Planned;
    case 'Done':
      return TreatmentStatus.Done;
    default:
      throw Exception('Unknown field type');
  }
}

TaskStatus taskStatusFromString(String type) {
  switch (type) {
    case 'Planned':
      return TaskStatus.Planned;
    case 'Done':
      return TaskStatus.Done;
    default:
      throw Exception('Unknown field type');
  }
}

TreatmentSpecificToPlanting treatmentSpecificToPlantingFromString(String type) {
  switch (type) {
    case 'Yes':
      return TreatmentSpecificToPlanting.Yes;
    case 'No':
      return TreatmentSpecificToPlanting.No;
    default:
      throw Exception('Unknown TreatmentSpecificToPlanting type');
  }
}

TypeOfIncome typeOfIncomeFromString(String type) {
  switch (type) {
    case 'TypeOfIncome.ChooseCategory':
      return TypeOfIncome.ChooseCategory;
    case 'TypeOfIncome.FromHarvest':
      return TypeOfIncome.FromHarvest;
    case 'TypeOfIncome.Other':
      return TypeOfIncome.Other;
    default:
      throw Exception('Unknown TypeOfIncome type');
  }
}

TypeOfExpense typeOfExpenseFromString(String type) {
  switch (type) {
    case 'TypeOfExpense.ChooseCategory':
      return TypeOfExpense.ChooseCategory;
    case 'TypeOfExpense.Other':
      return TypeOfExpense.Other;
    default:
      throw Exception('Unknown TypeOfExpense type');
  }
}

TaskSpecificToPlanting taskSpecificToPlantingFromString(String type) {
  switch (type) {
    case 'Yes':
      return TaskSpecificToPlanting.Yes;
    case 'No':
      return TaskSpecificToPlanting.No;
    default:
      throw Exception('Unknown TaskSpecificToPlanting type');
  }
}

TransactionSpecificToPlanting transactionSpecificToPlantingFromString(String type) {
  switch (type) {
    case 'Yes':
      return TransactionSpecificToPlanting.Yes;
    case 'No':
      return TransactionSpecificToPlanting.No;
    default:
      throw Exception('Unknown TransactionSpecificToPlanting type');
  }
}

TransactionSpecificToField transactionSpecificToFieldFromString(String type) {
  switch (type) {
    case 'Yes':
      return TransactionSpecificToField.Yes;
    case 'No':
      return TransactionSpecificToField.No;
    default:
      throw Exception('Unknown TransactionSpecificToPlanting type');
  }
}

PlantingType plantingTypeFromString(String type) {
  switch (type) {
    case 'PlantingType.Planted':
      return PlantingType.Planted;
    case 'PlantingType.Harvested':
      return PlantingType.Harvested;
    default:
      throw Exception('Unknown field type');
  }
}

FieldType fieldTypeFromString(String type) {
  switch (type) {
    case 'FieldType.FieldOrOutdoor':
      return FieldType.FieldOrOutdoor;
    case 'FieldType.Greenhouse':
      return FieldType.Greenhouse;
    case 'FieldType.SpeedlingGrowTent':
      return FieldType.SpeedlingGrowTent;
    case 'FieldType.GrowTent':
      return FieldType.GrowTent;
    default:
      throw Exception('Unknown field type');
  }
}
FieldStatus fieldStatusFromString(String type) {
  switch (type) {
    case 'FieldStatus.Available':
      return FieldStatus.Available;
    case 'FieldStatus.PartiallyCultivated':
      return FieldStatus.PartiallyCultivated;
    case 'FieldStatus.FullyCultivated':
      return FieldStatus.FullyCultivated;
    default:
      throw Exception('Unknown field type');
  }
}
LightProfile lightProfileFromString(String type) {
  switch (type) {
    case 'LightProfile.FullSun':
      return LightProfile.FullSun;
    case 'LightProfile.FullToPartialSun':
      return LightProfile.FullToPartialSun;
    case 'LightProfile.PartialSun':
      return LightProfile.PartialSun;
    case 'LightProfile.PartialShade':
      return LightProfile.PartialShade;
    case 'LightProfile.FullShade':
      return LightProfile.FullShade;
    default:
      throw Exception('Unknown field type');
  }
}

// Calculating age in days
int calculateAgeInDays(DateTime plantingDate) {
  DateTime today = DateTime.now();
  Duration difference = today.difference(plantingDate);
  return difference.inDays;
}

// Parsing the date string
DateTime parseDateString(String dateString) {
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    print("Error parsing date: $e");
    return DateTime(2000, 1, 1); // Default to a safe date
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


Future<List<DocumentSnapshot>> getAllPlantings() async {
  References r = References();
  String? id = await r.getLoggedUserId();
  QuerySnapshot cropsSnapshot =
  await r.usersRef.doc(id).collection("crops").get();

  List<DocumentSnapshot> allPlantings = [];

  for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
    // Get all the plantings in the collection for each crop
    QuerySnapshot plantingsSnapshot =
    await cropDoc.reference.collection("plantings").get();

    // Add all the plantings to the list
    allPlantings.addAll(plantingsSnapshot.docs);
  }

  return allPlantings;
}

Future<List<DocumentSnapshot>> getAllHarvests() async {
  References r = References();
  String? id = await r.getLoggedUserId();
  QuerySnapshot cropsSnapshot =
  await r.usersRef.doc(id).collection("crops").get();

  List<DocumentSnapshot> allHarvests= [];

  for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
    // Get all the plantings in the collection for each crop
    QuerySnapshot plantingsSnapshot =
    await cropDoc.reference.collection("plantings").get();

    for (QueryDocumentSnapshot plantingDoc in plantingsSnapshot.docs) {
      QuerySnapshot harvestsSnapshot =
      await plantingDoc.reference.collection("harvests").get();
      allHarvests.addAll(harvestsSnapshot.docs);
    }
  }

  return allHarvests;
}

Future<List<DocumentSnapshot>> getAllIncomeTransactions() async {
  References r = References();
  String? id = await r.getLoggedUserId();
  String typeOfIncome = "TypeOfIncome"; // Replace this with the actual income type identifier
  QuerySnapshot transSnapshot = await r.usersRef.doc(id).collection("transactions").get();
  QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();
  QuerySnapshot fieldsSnapshot = await r.usersRef.doc(id).collection("fields").get();

  List<DocumentSnapshot> incomeTransactions = [];

  // Filter transactions in the main transactions collection
  for (QueryDocumentSnapshot transDoc in transSnapshot.docs) {
    if (transDoc['typeOfTransaction'].toString().startsWith(typeOfIncome)) {
      incomeTransactions.add(transDoc);
    }
  }

  // Filter transactions in the crops' transactions collections
  for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
    QuerySnapshot plantingsSnapshot = await cropDoc.reference.collection("plantings").get();

    for (QueryDocumentSnapshot plantingDoc in plantingsSnapshot.docs) {
      QuerySnapshot transactionsSnapshot =
      await plantingDoc.reference.collection("transactions").get();

      for (QueryDocumentSnapshot transactionDoc in transactionsSnapshot.docs) {
        if (transactionDoc['typeOfTransaction'].toString().startsWith(typeOfIncome)) {
          incomeTransactions.add(transactionDoc);
        }
      }
    }
  }

  // Filter transactions in the fields' transactions collections
  for (QueryDocumentSnapshot fieldDoc in fieldsSnapshot.docs) {
    QuerySnapshot transactionsSnapshot = await fieldDoc.reference.collection("transactions").get();

    for (QueryDocumentSnapshot transactionDoc in transactionsSnapshot.docs) {
      if (transactionDoc['typeOfTransaction'].toString().startsWith(typeOfIncome)) {
        incomeTransactions.add(transactionDoc);
      }
    }
  }

  // TODO: Make this correct later.
  // Fetch all harvests and add to income transactions
  // List<DocumentSnapshot> allHarvests = await getAllHarvests();
  // incomeTransactions.addAll(allHarvests); // Append harvests to the income transactions

  return incomeTransactions;
}

Future<List<DocumentSnapshot>> getAllTreatments() async {
  References r = References();
  String? id = await r.getLoggedUserId();
  QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();
  QuerySnapshot fieldsSnapshot = await r.usersRef.doc(id).collection("fields").get();

  List<DocumentSnapshot> allTreatments = [];

  for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
    // Get all the plantings in the collection for each crop
    QuerySnapshot plantingsSnapshot = await cropDoc.reference.collection("plantings").get();

    for (QueryDocumentSnapshot plantingDoc in plantingsSnapshot.docs) {
      QuerySnapshot treatmentsSnapshot =
      await plantingDoc.reference.collection("treatments").get();
      allTreatments.addAll(treatmentsSnapshot.docs);
    }
  }

  for (QueryDocumentSnapshot fieldDoc in fieldsSnapshot.docs) {
    // Get all the plantings in the collection for each crop
    QuerySnapshot treatmentsSnapshot = await fieldDoc.reference.collection("treatments").get();
    allTreatments.addAll(treatmentsSnapshot.docs);
  }

  return allTreatments;
}

Future<List<DocumentSnapshot>> getAllExpenseTransactions() async {
  References r = References();
  String? id = await r.getLoggedUserId();
  String typeOfExpense = "TypeOfExpense"; // Replace this with the actual income type identifier
  QuerySnapshot transSnapshot = await r.usersRef.doc(id).collection("transactions").get();
  QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();
  QuerySnapshot fieldsSnapshot = await r.usersRef.doc(id).collection("fields").get();

  List<DocumentSnapshot> expenseTransactions = [];

  // Filter transactions in the main transactions collection
  for (QueryDocumentSnapshot transDoc in transSnapshot.docs) {
    if (transDoc['typeOfTransaction'].toString().startsWith(typeOfExpense)) {
      expenseTransactions.add(transDoc);
    }
  }

  // Filter transactions in the crops' transactions collections
  for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
    QuerySnapshot plantingsSnapshot = await cropDoc.reference.collection("plantings").get();

    for (QueryDocumentSnapshot plantingDoc in plantingsSnapshot.docs) {
      QuerySnapshot transactionsSnapshot =
      await plantingDoc.reference.collection("transactions").get();

      for (QueryDocumentSnapshot transactionDoc in transactionsSnapshot.docs) {
        if (transactionDoc['typeOfTransaction'].toString().startsWith(typeOfExpense)) {
          expenseTransactions.add(transactionDoc);
        }
      }
    }
  }

  // Filter transactions in the fields' transactions collections
  for (QueryDocumentSnapshot fieldDoc in fieldsSnapshot.docs) {
    QuerySnapshot transactionsSnapshot = await fieldDoc.reference.collection("transactions").get();

    for (QueryDocumentSnapshot transactionDoc in transactionsSnapshot.docs) {
      if (transactionDoc['typeOfTransaction'].toString().startsWith(typeOfExpense)) {
        expenseTransactions.add(transactionDoc);
      }
    }
  }

  return expenseTransactions;
}

Future<double> getTotalIncomeCost() async {
  References r = References();
  String? id = await r.getLoggedUserId();
  String typeOfIncome = "TypeOfIncome"; // Replace this with the actual income type identifier
  QuerySnapshot transSnapshot = await r.usersRef.doc(id).collection("transactions").get();
  QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();
  QuerySnapshot fieldsSnapshot = await r.usersRef.doc(id).collection("fields").get();

  double totalIncomeCost = 0.0;

  // Calculate total cost in the main transactions collection
  for (QueryDocumentSnapshot transDoc in transSnapshot.docs) {
    if (transDoc['typeOfTransaction'].toString().startsWith(typeOfIncome)) {
      totalIncomeCost += transDoc['earningAmount']; // Assuming the field 'amount' holds the transaction cost
    }
  }

  // Calculate total cost in the crops' transactions collections
  for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
    QuerySnapshot plantingsSnapshot = await cropDoc.reference.collection("plantings").get();

    for (QueryDocumentSnapshot plantingDoc in plantingsSnapshot.docs) {
      QuerySnapshot transactionsSnapshot =
      await plantingDoc.reference.collection("transactions").get();

      for (QueryDocumentSnapshot transactionDoc in transactionsSnapshot.docs) {
        if (transactionDoc['typeOfTransaction'].toString().startsWith(typeOfIncome)) {
          totalIncomeCost += transactionDoc['earningAmount']; // Add to total cost
        }
      }
    }
  }

  // Calculate total cost in the fields' transactions collections
  for (QueryDocumentSnapshot fieldDoc in fieldsSnapshot.docs) {
    QuerySnapshot transactionsSnapshot = await fieldDoc.reference.collection("transactions").get();

    for (QueryDocumentSnapshot transactionDoc in transactionsSnapshot.docs) {
      if (transactionDoc['typeOfTransaction'].toString().startsWith(typeOfIncome)) {
        totalIncomeCost += transactionDoc['earningAmount']; // Add to total cost
      }
    }
  }

  for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
    QuerySnapshot plantingsSnapshot = await cropDoc.reference.collection("plantings").get();

    for (QueryDocumentSnapshot plantingDoc in plantingsSnapshot.docs) {
      QuerySnapshot harvestsSnapshot = await plantingDoc.reference.collection("harvests").get();
      for (QueryDocumentSnapshot harvestDoc in harvestsSnapshot.docs) {
        if (harvestDoc['incomeFromThisHarvest'] == null) {
          totalIncomeCost += (harvestDoc['quantityHarvested'] - harvestDoc['quantityRejected']) * harvestDoc['unitCost'];
        }
        else {
          totalIncomeCost += harvestDoc['incomeFromThisHarvest'];
        }
      }
    }
  }

  return totalIncomeCost;
}

Future<double> getTotalExpenseCost() async {
  References r = References();
  String? id = await r.getLoggedUserId();
  String typeOfExpense = "TypeOfExpense"; // Replace this with the actual expense type identifier
  double totalExpenseCost = 0.0;

  // Fetch the main transactions, crops, and fields collections
  QuerySnapshot transSnapshot = await r.usersRef.doc(id).collection("transactions").get();
  QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();
  QuerySnapshot fieldsSnapshot = await r.usersRef.doc(id).collection("fields").get();

  // Sum expenses from the main transactions collection
  for (QueryDocumentSnapshot transDoc in transSnapshot.docs) {
    if (transDoc['typeOfTransaction'].toString().startsWith(typeOfExpense)) {
      totalExpenseCost += transDoc['earningAmount']; // Assuming 'amount' field contains the expense value
    }
  }

  // Sum expenses from the crops' transactions collections
  for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
    QuerySnapshot plantingsSnapshot = await cropDoc.reference.collection("plantings").get();

    for (QueryDocumentSnapshot plantingDoc in plantingsSnapshot.docs) {
      QuerySnapshot transactionsSnapshot =
      await plantingDoc.reference.collection("transactions").get();

      for (QueryDocumentSnapshot transactionDoc in transactionsSnapshot.docs) {
        if (transactionDoc['typeOfTransaction'].toString().startsWith(typeOfExpense)) {
          totalExpenseCost += transactionDoc['earningAmount']; // Sum the expense amounts
        }
      }
    }
  }

  // Sum expenses from the fields' transactions collection
  for (QueryDocumentSnapshot fieldDoc in fieldsSnapshot.docs) {
    QuerySnapshot transactionsSnapshot = await fieldDoc.reference.collection("transactions").get();

    for (QueryDocumentSnapshot transactionDoc in transactionsSnapshot.docs) {
      if (transactionDoc['typeOfTransaction'].toString().startsWith(typeOfExpense)) {
        totalExpenseCost += transactionDoc['earningAmount']; // Sum the expense amounts
      }
    }
  }

  return totalExpenseCost; // Return the total expense cost
}

Future<List<DocumentSnapshot>> getAllTasks() async {
  References r = References();
  String? id = await r.getLoggedUserId();
  QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();
  QuerySnapshot fieldsSnapshot = await r.usersRef.doc(id).collection("fields").get();

  List<DocumentSnapshot> allTasks = [];

  for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
    // Get all the plantings in the collection for each crop
    QuerySnapshot plantingsSnapshot = await cropDoc.reference.collection("plantings").get();

    for (QueryDocumentSnapshot plantingDoc in plantingsSnapshot.docs) {
      QuerySnapshot tasksSnapshot =
      await plantingDoc.reference.collection("tasks").get();
      allTasks.addAll(tasksSnapshot.docs);
    }
  }

  for (QueryDocumentSnapshot fieldDoc in fieldsSnapshot.docs) {
    // Get all the plantings in the collection for each crop
    QuerySnapshot treatmentsSnapshot = await fieldDoc.reference.collection("tasks").get();
    allTasks.addAll(treatmentsSnapshot.docs);
  }

  return allTasks;
}

Stream<QuerySnapshot> getAllPlantingsStream() async* {
  References r = References();
  String? id = await r.getLoggedUserId();

  QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();

  for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
    // Listen to real-time updates for the plantings in each crop's collection
    yield* cropDoc.reference.collection("plantings").snapshots();
  }
}

void saveFarmerId(String e) async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  final farmersRef = FirebaseFirestore.instance.collection('farmers');
  await farmersRef.get().then(
        (res) {
      for (var change in res.docChanges) {
        if (change.doc['loginCode'].toString().toLowerCase().endsWith(e)) {sf.setString("userId", change.doc.id);}
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
}

void saveLandlordId(String e) async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  final usersRef = FirebaseFirestore.instance.collection('users');
  await usersRef.get().then(
        (res) {
      for (var change in res.docChanges) {
        if (change.doc['email'].toString().toLowerCase().endsWith(e)) {sf.setString("userId", change.doc.id);}
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
}

void saveSecondaryUserId(String e) async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  final usersRef = FirebaseFirestore.instance.collection('farmers');

  // Fetch the documents from Firestore
  try {
    final res = await usersRef.get();

    // Iterate over the documents
    for (var doc in res.docs) {
      if (doc['loginCode'].toString().toLowerCase().endsWith(e)) {
        // Get the userId from the document
        String userId = doc['userId'];
        // Save it in SharedPreferences
        await sf.setString("secondaryUserId", userId);
        break; // Exit the loop once we find the match
      }
    }
  } catch (error) {
    print("Error completing: $error");
  }
}

void logout(BuildContext context) async {
  try {
    // Sign out the user
    await FirebaseAuth.instance.signOut();

    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('name');
    sp.remove('userId');
    sp.remove('secondaryUserId');

    // Optionally, navigate to the login screen or perform any other action
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Wrapper(),
      ),
    );

    print('User successfully logged out.');
  } catch (e) {
    print('Error during logout: $e');
    // Optionally, show a user-friendly error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error during logout: ${e.toString()}'),
      ),
    );
  }
}


String generateRandomDocId() {
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();

  // Generate a random 15-character alphanumeric string
  String code = List.generate(25, (index) => chars[random.nextInt(chars.length)]).join();

  return code;
}
