import 'package:flutter/foundation.dart';

class BorderProvider extends ChangeNotifier{
  bool _showBorder = true;

  bool get showBorder => _showBorder;

  setBorder(con){
    _showBorder = con;
    notifyListeners();
  }
}