import 'dart:convert';
import 'dart:io';

import 'package:client/services/entities/dish_grocery.dart';

List<Dish> listDishFromJson(String str) => List<Dish>.from(json.decode(str).map((x) => Dish.fromJson(x)));

String listDishToJson(List<Dish> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Dish {
    Dish({
        required this.dishId,
        required this.dishName,
        required this.dishPrice,
        required this.dishGrId,
        required this.dishGrocs, 
        required this.dishPhotoIndex,
        required this.dishDescr,
    });

    int? dishId;
    String dishName;
    double? dishPrice;
    int dishGrId;
    List<DishGrocery> dishGrocs;
    int dishPhotoIndex;
    String dishDescr;
    File? photo;

    factory Dish.initial() => Dish(
      dishId: null,
      dishName: '',
      dishPrice: null,
      dishGrId: 1, // unsorted
      dishPhotoIndex: 0,
      dishDescr: '',
      dishGrocs: []
    );

    factory Dish.fromJson(Map<String, dynamic> json) => Dish(
        dishId: json["dish_id"],
        dishName: json["dish_name"],
        dishPrice: json["dish_price"].toDouble(),
        dishGrId: json["dish_gr_id"],
        dishPhotoIndex: json['dish_photo_index'],
        dishDescr: json['dish_descr'],
        dishGrocs: List<DishGrocery>.from(json["consist"]?.map((x) => DishGrocery.fromJson(x)) ?? []),
    );

    factory Dish.copy(Dish other) => Dish(
      dishId: other.dishId,
      dishName: other.dishName,
      dishPrice: other.dishPrice,
      dishGrId: other.dishGrId,
      dishPhotoIndex: other.dishPhotoIndex,
      dishDescr: other.dishDescr,
      dishGrocs: List.from(other.dishGrocs)
    );

    Map<String, dynamic> toJson() => {
        "dish_id": dishId,
        "dish_name": dishName,
        "dish_price": dishPrice,
        "dish_gr_id": dishGrId,
        "dish_photo_index" : dishPhotoIndex,
        "consist": List<dynamic>.from(dishGrocs.map((x) => x.toJson())),
        "photo": (photo != null) ? base64Encode(photo!.readAsBytesSync()) : null,
        "dish_descr": dishDescr,
    };

    bool get isSaveable => dishPrice != 0 
      && dishName.isNotEmpty 
      && !dishGrocs.map<double>((e) => e.grocCount).contains(0) 
      && dishGrocs.isNotEmpty;
}