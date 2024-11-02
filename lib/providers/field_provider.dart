import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/references.dart';

class FieldProvider with ChangeNotifier {
  List<DocumentSnapshot> _fields = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _needsRefresh = false;

  List<DocumentSnapshot> get fields => _fields;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get needsRefresh => _needsRefresh;

  set needsRefresh(bool value) {
    _needsRefresh = value;
    notifyListeners();
  }

  Future<void> fetchFieldsData() async {
    try {
      References r = References();
      String? id = await r.getLoggedUserId();
      QuerySnapshot fieldsSnapshot = await r.usersRef.doc(id).collection("fields").get();

      _fields = fieldsSnapshot.docs;
      _isLoading = false;
      _needsRefresh = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteField(String fieldName) async {
  try {
    References r = References();
    String? id = await r.getLoggedUserId();
    QuerySnapshot querySnapshot = await r.usersRef.doc(id).collection("fields").where("name", isEqualTo: fieldName).get();
    if (querySnapshot.docs.isNotEmpty) {
      String fieldId = querySnapshot.docs.first.id;
      await r.usersRef.doc(id).collection("fields").doc(fieldId).delete();
      _fields.removeWhere((field) => field.id == fieldId);
      notifyListeners();
    }
  } catch (e) {
    _errorMessage = e.toString();
    notifyListeners();
  }
}
}