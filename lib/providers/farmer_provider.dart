// lib/providers/farmer_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/references.dart';

class FarmerProvider with ChangeNotifier {
  List<DocumentSnapshot> _farmers = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _needsRefresh = false;

  List<DocumentSnapshot> get farmers => _farmers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get needsRefresh => _needsRefresh;

  set needsRefresh(bool value) {
    _needsRefresh = value;
    notifyListeners();
  }

  Future<void> deleteFarmer(String farmerName) async {
    try {
      References r = References();
      String? id = await r.getLoggedUserId();
      QuerySnapshot querySnapshot = await r.usersRef.doc(id).collection("farmers").where("name", isEqualTo: farmerName).get();
      if (querySnapshot.docs.isNotEmpty) {
        String farmerId = querySnapshot.docs.first.id;
        await r.usersRef.doc(id).collection("farmers").doc(farmerId).delete();
        _farmers.removeWhere((farmer) => farmer.id == farmerId);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchFarmersData() async {
    try {
      References r = References();
      String? id = await r.getLoggedUserId();
      QuerySnapshot farmersSnapshot = await r.usersRef.doc(id).collection("farmers").get();

      _farmers = farmersSnapshot.docs;
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