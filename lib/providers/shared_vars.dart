import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedVars with ChangeNotifier {
  int _gridType = 1;
  
  int get gridType {
    return _gridType;
  }

  Future<void> initGridType() async {
    _gridType = await getGridType();
    notifyListeners();
  }

  Future<void> toggleGridType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final gridSize = (prefs.getInt('gridType') ?? 1) == 1 ? 2 : 1;
    prefs.setInt('gridType', gridSize) ;
    _gridType = gridSize;
    notifyListeners();
  }



  Future<int> getGridType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getInt('gridType') ?? 1);
  }
}
