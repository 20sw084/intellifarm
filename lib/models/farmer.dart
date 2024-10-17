import '../util/share_rule_enum.dart';

class Farmer {
  String name;
  String? cnic;
  String phoneNumber;
  String loginCode;
  ShareRule shareRule;
  String? userId;
  String? cropPlantingId; // Add this field

  Farmer({
    required this.name,
    required this.phoneNumber,
    this.cnic,
    required this.loginCode,
    required this.shareRule,
    this.userId,
    this.cropPlantingId, // Initialize it in the constructor
  });

  Map<String, dynamic> getFarmerDataMap() {
    return {
      "name": name,
      "phoneNumber": phoneNumber,
      "cnic": cnic ?? " ",
      "loginCode": loginCode,
      "shareRule": shareRule.toString(),
      "cropPlantingId": cropPlantingId, // Include this in the map
    };
  }

  Map<String, dynamic> getFarmerDataMapWithUserID(String id) {
    return {
      "name": name,
      "phoneNumber": phoneNumber,
      "cnic": cnic ?? " ",
      "shareRule": shareRule.toString(),
      "loginCode": loginCode,
      "userId": id,
      "cropPlantingId": cropPlantingId, // Include this in the map
    };
  }
}
