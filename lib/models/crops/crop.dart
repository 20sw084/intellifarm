import 'package:intellifarm/models/crops/cropVariety.dart';
import 'package:intellifarm/util/units_enum.dart';

import 'cropPlanting.dart';

class Crop {
  String? name;
  Units? harvestUnit;
  String? notes;
  CropPlanting? cropPlantings;
  CropVariety? cropVarieties;
  Crop({required this.name, required this.harvestUnit, this.notes, this.cropPlantings, this.cropVarieties,});
  Map<String, dynamic> getCropDataMap() {
    return {
      "name": name,
      "harvestUnit": harvestUnit.toString(),
      "notes": notes ?? " ",
      "cropPlantings": cropPlantings ?? " ",
      "cropVarieties": cropVarieties ?? " ",
    };
  }
}
