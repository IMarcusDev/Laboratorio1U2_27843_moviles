import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  bool loading = false;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}