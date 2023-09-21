import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constants {
  static const Size groceryDialogSize = Size(500, 500);
  static const Color grey = Colors.grey;
  static const TextStyle boldText = TextStyle(fontWeight: FontWeight.bold);
  
  static const String configFileName = 'config.json';
  static const String configBrightness = 'brightness';
  static const String configLang = 'language'; 

  static final DateFormat dateOnlyFormat = DateFormat('yyyy-MM-dd');

  static const dishPlaceholderAsset = 'assets/dish_placeholder.jpeg';
}

