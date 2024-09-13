import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class  References{
  final usersRef = FirebaseFirestore.instance.collection('users');

  Future<String?> getLoggedUserId() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.get("userId").toString();
  }

  Future<String?> getSecondaryUserId() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.get("secondaryUserId").toString();
  }

  Future<String?> getCropIdByName(String cropName) async {
    References r = References();
    String? userId = await r.getLoggedUserId();
    if (userId == null) {
      return null; // Handle the case where user ID is not found
    }

    QuerySnapshot querySnapshot = await r.usersRef
        .doc(userId)
        .collection("crops")
        .where('name', isEqualTo: cropName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0].id; // Return the document ID
    } else {
      return null; // Handle the case where no crop with the given name is found
    }
  }

  Future<String?> getFieldIdByName(String fieldName) async {
    References r = References();
    String? userId = await r.getLoggedUserId();
    if (userId == null) {
      return null; // Handle the case where user ID is not found
    }

    QuerySnapshot querySnapshot = await r.usersRef
        .doc(userId)
        .collection("fields")
        .where('name', isEqualTo: fieldName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0].id; // Return the document ID
    } else {
      return null; // Handle the case where no crop with the given name is found
    }
  }

  Future<String?> getPlantingIdByFieldAndCropVariety(String cropId, String fieldName, String cropVariety) async {
    References r = References();
    String? userId = await r.getLoggedUserId();
    if (userId == null) {
      return null; // Handle the case where user ID is not found
    }

    QuerySnapshot querySnapshot = await r.usersRef
        .doc(userId)
        .collection("crops")
        .doc(cropId)
        .collection("plantings")
        .where('fieldName', isEqualTo: fieldName)
        .where('varietyName', isEqualTo: cropVariety)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0].id; // Return the document ID
    } else {
      return null; // Handle the case where no crop with the given name is found
    }
  }

  Future<String?> getTreatmentIdOfYes(String fieldName, String cropId, String plantingId) async {
    References r = References();
    String? userId = await r.getLoggedUserId();
    if (userId == null) {
      return null; // Handle the case where user ID is not found
    }

    QuerySnapshot querySnapshot = await r.usersRef
        .doc(userId)
        .collection("crops")
        .doc(cropId)
        .collection("plantings")
        .doc(plantingId)
        .collection("treatments")
        .where("fieldName", isEqualTo: fieldName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0].id; // Return the document ID
    } else {
      return null; // Handle the case where no crop with the given name is found
    }
  }

  Future<String?> getTreatmentIdOfNo(String fieldName, String fieldId) async {
    References r = References();
    String? userId = await r.getLoggedUserId();
    if (userId == null) {
      return null; // Handle the case where user ID is not found
    }

    QuerySnapshot querySnapshot = await r.usersRef
        .doc(userId)
        .collection("fields")
        .doc(fieldId)
        .collection("treatments")
        .where("fieldName", isEqualTo: fieldName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0].id; // Return the document ID
    } else {
      return null; // Handle the case where no crop with the given name is found
    }
  }


  Future<String?> getTaskIdOfYes(String fieldName, String cropId, String plantingId) async {
    References r = References();
    String? userId = await r.getLoggedUserId();
    if (userId == null) {
      return null; // Handle the case where user ID is not found
    }

    QuerySnapshot querySnapshot = await r.usersRef
        .doc(userId)
        .collection("crops")
        .doc(cropId)
        .collection("plantings")
        .doc(plantingId)
        .collection("tasks")
        .where("fieldName", isEqualTo: fieldName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0].id; // Return the document ID
    } else {
      return null; // Handle the case where no crop with the given name is found
    }
  }

  Future<String?> getTaskIdOfNo(String fieldName, String fieldId) async {
    References r = References();
    String? userId = await r.getLoggedUserId();
    if (userId == null) {
      return null; // Handle the case where user ID is not found
    }

    QuerySnapshot querySnapshot = await r.usersRef
        .doc(userId)
        .collection("fields")
        .doc(fieldId)
        .collection("tasks")
        .where("fieldName", isEqualTo: fieldName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0].id; // Return the document ID
    } else {
      return null; // Handle the case where no crop with the given name is found
    }
  }

  Future<String?> getCropPlantingIdByName(String cropId, String variety, String fieldName) async {
    References r = References();
    String? userId = await r.getLoggedUserId();
    if (userId == null) {
      return null; // Handle the case where user ID is not found
    }

    QuerySnapshot querySnapshot = await r.usersRef
        .doc(userId)
        .collection("crops")
        .doc(cropId)
        .collection("plantings")
        .where("varietyName", isEqualTo: variety)
        .where("fieldName", isEqualTo: fieldName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0].id; // Return the document ID
    } else {
      return null; // Handle the case where no crop with the given name is found
    }
  }

  Future<String?> getHarvestIdByName(String cropId, String plantingId, String plantingToHarvest) async {
    References r = References();
    String? userId = await r.getLoggedUserId();
    if (userId == null) {
      return null; // Handle the case where user ID is not found
    }

    QuerySnapshot querySnapshot = await r.usersRef
        .doc(userId)
        .collection("crops")
        .doc(cropId)
        .collection("plantings")
        .doc(plantingId)
        .collection("harvests")
        .where("plantingToHarvest", isEqualTo: plantingToHarvest)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0].id; // Return the document ID
    } else {
      return null; // Handle the case where no crop with the given name is found
    }
  }

  
  Future<String?> getCropIdByFieldName(String fieldName) async {
    References r = References();
    String? userId = await r.getLoggedUserId();
    if (userId == null) {
      return null; // Handle the case where user ID is not found
    }

    QuerySnapshot querySnapshot = await r.usersRef
        .doc(userId)
        .collection("fields")
        .where('name', isEqualTo: fieldName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0].id; // Return the document ID
    } else {
      return null; // Handle the case where no crop with the given name is found
    }
  }

  Future<void> deleteCropDocument(String collectionName, String cropName) async {
    try {
      References r = References();
      String? userId = await r.getLoggedUserId();
      if (userId == null) {
        return; // Handle the case where user ID is not found
      }
      String? cropId = await r.getCropIdByName(cropName);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId).collection(collectionName).doc(cropId)
          .delete();
      print('Document successfully deleted!');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

}
