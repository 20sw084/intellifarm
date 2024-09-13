import '../../util/field_type_enum.dart';
import '../../util/light_profile_enum.dart';

class CropVariety {
  String? varietyName;
  LightProfile? lightProfile;
  FieldType? fieldType;
  int? daysToMaturity;
  int? harvestWindowDays;
  String? notes;

  CropVariety({
    required this.varietyName,
    required this.lightProfile,
    required this.fieldType,
    required this.daysToMaturity,
    required this.harvestWindowDays,
    this.notes,
  });
  Map<String, dynamic> getCropVarietyDataMap() {
    return {
      "varietyName": varietyName,
      "lightProfile": lightProfile.toString(),
      "fieldType": fieldType.toString(),
      "daysToMaturity": daysToMaturity,
      "harvestWindowDays": harvestWindowDays,
      "notes": notes ?? " ",
    };
  }
}
