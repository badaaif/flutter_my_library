import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedVars with ChangeNotifier {
  int _gridSize = 2;
  
  int get gridSize {
    return _gridSize;
  }

  Future<void> initGridSize() async {
    _gridSize = await getGridSize();
    notifyListeners();
  }

  Future<void> toggleGridSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final gridSize = (prefs.getInt('gridSize') ?? 2) == 2 ? 3 : 2;
    prefs.setInt('gridSize', gridSize) ;
    _gridSize = gridSize;
    notifyListeners();
  }



  Future<int> getGridSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getInt('gridSize') ?? 2);
  }
}
