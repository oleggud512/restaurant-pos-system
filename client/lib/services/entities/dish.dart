import 'dart:convert';

import 'package:client/services/entities/grocery/dish_grocery.dart';
import 'package:equatable/equatable.dart';

List<Dish> listDishFromJson(String str) => List<Dish>.from(json.decode(str).map((x) => Dish.fromJson(x)));

String listDishToJson(List<Dish> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Dish extends Equatable {
  const Dish({
    this.dishId = 0,
    this.dishName = '',
    this.dishPrice,
    this.dishGrId = 0,
    this.dishPhotoIndex = 0,
    this.dishDescr = '',
    this.dishGroceries = const [],
    this.dishPhotoUrl = ''
  });

  final int dishId;
  final String dishName;
  final double? dishPrice;
  final int dishGrId;
  final List<DishGrocery> dishGroceries;
  final int dishPhotoIndex;
  final String dishDescr;
  final String dishPhotoUrl;

  Dish copyWith({
    int? dishId,
    String? dishName,
    double? Function()? dishPrice,
    int? dishGrId,
    List<DishGrocery>? dishGroceries,
    int? dishPhotoIndex,
    String? dishDescr,
    String? dishPhotoUrl
  }) {
    return Dish(
      dishId: dishId ?? this.dishId,
      dishName: dishName ?? this.dishName,
      dishPrice: dishPrice != null ? dishPrice() : this.dishPrice,
      dishGrId: dishGrId ?? this.dishGrId,
      dishGroceries: dishGroceries ?? this.dishGroceries,
      dishPhotoIndex: dishPhotoIndex ?? this.dishPhotoIndex,
      dishDescr: dishDescr ?? this.dishDescr,
      dishPhotoUrl: dishPhotoUrl ?? this.dishPhotoUrl,
    );
  }

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
    dishId: json["dish_id"],
    dishName: json["dish_name"],
    // TODO: (1) dish_price is String in some cases, and double in another...
    dishPrice: json["dish_price"] is String
        ? double.parse(json['dish_price'])
        : json['dish_price'],
    dishGrId: json["dish_gr_id"],
    dishPhotoUrl: json["dish_photo_url"],
    dishDescr: json['dish_descr'],
    dishGroceries: List.from(json["dish_groceries"] ?? [])
      .map((x) => DishGrocery.fromJson(x)).toList(),
  );

  Map<String, dynamic> toJson() => {
    "dish_id": dishId,
    "dish_name": dishName,
    "dish_price": dishPrice,
    "dish_gr_id": dishGrId,
    "dish_groceries": List<dynamic>.from(dishGroceries.map((x) => x.toJson())),
    "dish_photo_url": dishPhotoUrl,
    "dish_descr": dishDescr,
  };

  // TODO: throw appropriate exceptions on each
  bool get isSaveable => dishPrice != 0 
    && dishName.isNotEmpty 
    && !dishGroceries.map<double>((e) => e.grocCount).contains(0)
    && dishGroceries.isNotEmpty;
    
  @override
  List<Object?> get props => [
    dishId,
    dishName,
    dishPrice,
    dishGrId,
    dishPhotoIndex,
    dishDescr,
    dishGroceries,
    dishPhotoUrl
  ];
}