import 'package:intellifarm/util/transaction_specific_to_planting_enum.dart';
import '../util/transaction_specific_to_field_enum.dart';

class TransactionModel {
  TransactionSpecificToField transactionSpecificToField;
  String? fieldName;
  TransactionSpecificToPlanting? transactionSpecificToPlanting;
  String? plantingNameTransaction;
  String typeOfTransaction;
  String? transactionTypeOther;
  String? transactionTypeCategory;
  int earningAmount;
  String transactionDate;
  String? receiptNumber;
  String? customerName;
  String? notes;
  TransactionModel({
    required this.transactionSpecificToField,
    required this.typeOfTransaction,
    required this.earningAmount,
    required this.transactionDate,
    this.fieldName,
    this.transactionSpecificToPlanting,
    this.plantingNameTransaction,
    this.transactionTypeOther,
    this.transactionTypeCategory,
    this.receiptNumber,
    this.customerName,
    this.notes,
  });
  Map<String, dynamic> getTransactionDataMap() {
    return {
      'transactionSpecificToField': transactionSpecificToField.toString().split('.').last, // Convert to String
      'typeOfTransaction': typeOfTransaction,
      'earningAmount': earningAmount,
      'transactionDate': transactionDate,
      'fieldName': fieldName,
      'transactionSpecificToPlanting': transactionSpecificToPlanting?.toString().split('.').last, // Convert to String
      'plantingNameTransaction': plantingNameTransaction,
      'transactionTypeOther': transactionTypeOther,
      'transactionTypeCategory': transactionTypeCategory,
      'receiptNumber': receiptNumber,
      'customerName': customerName,
      'notes': notes,
    };
  }
}
