// lib/providers/crop_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../controller/references.dart';

class CropProvider with ChangeNotifier {
  List<DocumentSnapshot> _crops = [];
  List<int> _plantingsCountList = [];
  List<int> _varietiesCountList = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _needsRefresh = false;

  List<DocumentSnapshot> get crops => _crops;
  List<int> get plantingsCountList => _plantingsCountList;
  List<int> get varietiesCountList => _varietiesCountList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get needsRefresh => _needsRefresh;

  set needsRefresh(bool value) {
    _needsRefresh = value;
    notifyListeners();
  }

  Future<void> deleteCrop(String cropName) async {
    try {
      References r = References();
      String? id = await r.getLoggedUserId();
      QuerySnapshot querySnapshot = await r.usersRef.doc(id).collection("crops").where("name", isEqualTo: cropName).get();
      if (querySnapshot.docs.isNotEmpty) {
        String cropId = querySnapshot.docs.first.id;
        await r.usersRef.doc(id).collection("crops").doc(cropId).delete();
        _crops.removeWhere((crop) => crop.id == cropId);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchCropsData() async {
    try {
      References r = References();
      String? id = await r.getLoggedUserId();
      QuerySnapshot cropsSnapshot = await r.usersRef.doc(id).collection("crops").get();

      List<int> plantingsCountList = [];
      List<int> varietiesCountList = [];

      for (QueryDocumentSnapshot cropDoc in cropsSnapshot.docs) {
        QuerySnapshot plantingsSnapshot = await cropDoc.reference.collection("plantings").get();
        QuerySnapshot varietiesSnapshot = await cropDoc.reference.collection("varieties").get();
        plantingsCountList.add(plantingsSnapshot.size);
        varietiesCountList.add(varietiesSnapshot.size);
      }

      _crops = cropsSnapshot.docs;
      _plantingsCountList = plantingsCountList;
      _varietiesCountList = varietiesCountList;
      _isLoading = false;
      _needsRefresh = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}