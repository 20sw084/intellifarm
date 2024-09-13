import '../../util/planting_type_enum.dart';

class CropPlanting {
  String? plantingDate;
  PlantingType? plantingType;
  String? cropName;
  String? varietyName;
  String? fieldName;
  String? firstHarvestDate;
  int? quantityPlanted;
  int? estimatedYield;
  String? distanceBetweenPlants;
  String? seedCompany;
  String? seedType;
  int? seedLotNumber;
  String? seedOrigin;
  String? notes;

  CropPlanting({
    required this.plantingDate,
    required this.plantingType,
    required this.cropName,
    required this.varietyName,
    required this.fieldName,
    this.firstHarvestDate,
    required this.quantityPlanted,
    this.estimatedYield,
    this.distanceBetweenPlants,
    this.seedCompany,
    this.seedType,
    this.seedLotNumber,
    this.seedOrigin,
    this.notes,
  });
  Map<String, dynamic> getCropPlantingDataMap() {
    return {
      "plantingDate": plantingDate,
      "plantingType": plantingType.toString(),
      "cropName": cropName,
      "varietyName": varietyName,
      "fieldName" : fieldName,
      "firstHarvestDate": firstHarvestDate ?? " ",
      "quantityPlanted": quantityPlanted,
      "estimatedYield": estimatedYield ?? " ",
      "distanceBetweenPlants": distanceBetweenPlants ?? " ",
      "seedCompany": seedCompany ?? " ",
      "seedType": seedType ?? " ",
      "seedLotNumber": seedLotNumber ?? " ",
      "seedOrigin": seedOrigin ?? " ",
      "notes": notes ?? " ",
    };
  }
}
