import 'package:flutter/foundation.dart';

class imagepathprovider extends ChangeNotifier{
  String _imagepath = '';

  String get imagepath => _imagepath;

  void setImagePath(String path){
    _imagepath = path;
    notifyListeners();
  }
}
