import 'dart:convert';

import 'package:equatable/equatable.dart';


List<DishGroup> groupFromJson(String str) => List<DishGroup>.from(json.decode(str).map((x) => DishGroup.fromJson(x)));

String groupToJson(List<DishGroup> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DishGroup extends Equatable {

  const DishGroup({
    required this.groupId,
    required this.groupName,
  });

  final int groupId;
  final String groupName;

  factory DishGroup.fromJson(Map<String, dynamic> json) => DishGroup(
    groupId: json["dish_gr_id"],
    groupName: json["dish_gr_name"],
  );

  Map<String, dynamic> toJson() => {
    "dish_gr_id": groupId,
    "dish_gr_name": groupName,
  };

  DishGroup copyWith({bool? selected}) {
    return DishGroup(
      groupId: groupId,
      groupName: groupName,
    );
  }

  @override
  List<Object?> get props => [
    groupId,
    groupName,
  ];
}