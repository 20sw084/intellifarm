import 'package:intellifarm/util/treatment_specific_to_planting_enum.dart';
import 'package:intellifarm/util/treatment_status_enum.dart';
import 'package:intellifarm/util/treatment_type_enum.dart';

class Treatment {
  String treatmentDate;
  TreatmentStatus? treatmentStatus;
  TreatmentType? treatmentType;
  String fieldName;
  TreatmentSpecificToPlanting? treatmentSpecificToPlanting;
  String? plantingName;
  String? productUsed;
  int? quantityOfProduct;
  String? notes;
  Treatment({
    required this.treatmentDate,
    required this.treatmentStatus,
    required this.treatmentType,
    required this.fieldName,
    required this.treatmentSpecificToPlanting,
    this.plantingName,
    this.productUsed,
    this.quantityOfProduct,
    this.notes,
  });
  Map<String, dynamic> getTreatmentDataMap() {
    return {
      'treatmentDate': treatmentDate,
      'treatmentStatus': treatmentStatus?.toString().split('.').last, // Convert to String
      'treatmentType': treatmentType?.toString().split('.').last, // Convert to String
      'fieldName': fieldName,
      'treatmentSpecificToPlanting': treatmentSpecificToPlanting?.toString().split('.').last, // Convert to String
      'plantingName': plantingName,
      'productUsed': productUsed,
      'quantityOfProduct': quantityOfProduct,
      'notes': notes,
    };
  }
}
