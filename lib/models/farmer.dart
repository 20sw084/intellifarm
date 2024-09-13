class Farmer {
  String name;
  String? cnic;
  String phoneNumber;
  String loginCode;
  String? userId;
  String? cropPlantingId; // Add this field

  Farmer({
    required this.name,
    required this.phoneNumber,
    this.cnic,
    required this.loginCode,
    this.userId,
    this.cropPlantingId, // Initialize it in the constructor
  });

  Map<String, dynamic> getFarmerDataMap() {
    return {
      "name": name,
      "phoneNumber": phoneNumber,
      "cnic": cnic ?? " ",
      "loginCode": loginCode,
      "cropPlantingId": cropPlantingId, // Include this in the map
    };
  }

  Map<String, dynamic> getFarmerDataMapWithUserID(String id) {
    return {
      "name": name,
      "phoneNumber": phoneNumber,
      "cnic": cnic ?? " ",
      "loginCode": loginCode,
      "userId": id,
      "cropPlantingId": cropPlantingId, // Include this in the map
    };
  }
}
