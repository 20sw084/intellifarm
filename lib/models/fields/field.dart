import 'package:intellifarm/util/field_status_enum.dart';
import 'package:intellifarm/util/light_profile_enum.dart';
import '../../util/field_type_enum.dart';

class Field {
  String? name;
  FieldType? fieldType;
  LightProfile? lightProfile;
  FieldStatus? fieldStatus;
  int? sizeOfField;
  String? notes;
  Field({required this.name, required this.fieldType, required this.lightProfile, required this.fieldStatus, this.sizeOfField, this.notes,});
  Map<String, dynamic> getFieldDataMap() {
    return {
      "name": name,
      "fieldType": fieldType.toString().split('.').last,
      "lightProfile": lightProfile.toString().split('.').last,
      "fieldStatus": fieldStatus.toString().split('.').last,
      "sizeOfField": sizeOfField ?? " ",
      "notes": notes ?? " ",
    };
  }
}
