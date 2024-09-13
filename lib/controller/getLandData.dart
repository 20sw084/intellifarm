import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class getLandData {

  Future<List<DocumentSnapshot>> getFarmers(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(
      "users",
    )
        .doc(
      (await SharedPreferences.getInstance()).getString(
        "userId",
      ),
    )
        .collection(
      "land",
    )
        .doc(
      id,
    )
        .collection(
      "farmers",
    )
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getCrops(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(
      "users",
    )
        .doc(
      (await SharedPreferences.getInstance()).getString(
        "userId",
      ),
    )
        .collection(
      "land",
    )
        .doc(
      id,
    )
        .collection(
      "crops",
    )
        .get();
    return querySnapshot.docs;
  }

  // Future<Land> getLand(String id) async {
  //   final landsRef = FirebaseFirestore.instance
  //       .collection(
  //         "users",
  //       )
  //       .doc(
  //         (await SharedPreferences.getInstance()).getString(
  //           "userId",
  //         ),
  //       )
  //       .collection(
  //         "land",
  //       )
  //       .doc(
  //         id,
  //       );

    // final landFarmers = await landsRef.collection("farmers").get();
    //
    // final farmers = landFarmers.docs.map((doc) {
    //   return Farmer(
    //     name: doc["name"],
    //     cnic: doc["cnic"],
    //     phone: doc["phone"],
    //   );
    // }).toList();
    //
    // final landCrops = await landsRef.collection("crops").get();

    // final crops = landCrops.docs.map((doc) {
    //   return Crop(
    //     name: doc["name"],
    //     plantingDate: doc["plantingDate"],
    //     harvestingDate: doc["harvestingDate"],
    //     price: doc["price"],
    //   );
    // }).toList();

    // final landsData = await landsRef.get();
    //
    // return Land(
    //   surveyNo: landsData['SurveyNum'],
    //   area: landsData['area'],
    //   farmers: farmers,
    //   crops: crops,
    // );
  }
