import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/references.dart';

class PlantingProvider with ChangeNotifier {
  List<DocumentSnapshot> _plantings = [];

  List<DocumentSnapshot> get plantings => _plantings;

  Future<void> fetchPlantings() async {
    References r = References();
    String? id = await r.getLoggedUserId();
    QuerySnapshot cropsSnapshot =
    await r.usersRef.doc(id).collection("crops").get();
    List<DocumentSnapshot> allPlantings = [];
    for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
      QuerySnapshot plantingsSnapshot =
      await cropDoc.reference.collection("plantings").get();
      allPlantings.addAll(plantingsSnapshot.docs);
    }
    _plantings = allPlantings;
    notifyListeners();
  }

  void addPlanting(DocumentSnapshot planting) {
    _plantings.add(planting);
    notifyListeners();
  }
}
 /*
 In the above code snippet, we have created a  PlantingProvider  class that extends  ChangeNotifier . This class has a private list of  DocumentSnapshot  objects named  _plantings  and a getter method named  plantings  that returns the list of plantings.
 The  fetchPlantings  method fetches the plantings from Firestore and stores them in the  _plantings  list. The  addPlanting  method adds a planting to the list of plantings.
 Step 3: Register the Provider
 Now, we need to register the  PlantingProvider  in the  main.dart  file.
  Open the  main.dart  file and import the  PlantingProvider  class.
  */