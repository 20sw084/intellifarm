import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  bool _searchFlag = false;
  String _searchQuery = '';

  bool get searchFlag => _searchFlag;
  String get searchQuery => _searchQuery;

  void toggleSearch() {
    _searchFlag = !_searchFlag;
    if (!_searchFlag) {
      clearSearch();
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
