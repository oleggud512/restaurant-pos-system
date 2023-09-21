import 'dart:convert';

import 'package:client/utils/constants.dart';

FilterSortEmployeeData filterSortEmployeeDataFromJson(String str) => FilterSortEmployeeData.fromJson(json.decode(str));

String filterSortEmployeeDataToJson(FilterSortEmployeeData data) => json.encode(data.toJson());

class FilterSortEmployeeData {
  FilterSortEmployeeData({
    required this.birthdayFrom,
    required this.birthdayTo,
    required this.hoursPerMonthFrom,
    required this.hoursPerMonthTo,
    required this.gender,
    required this.sortColumn,
    required this.asc
  });

  DateTime birthdayFrom;
  DateTime birthdayTo;
  int hoursPerMonthFrom;
  int hoursPerMonthTo;
  String gender;
  String sortColumn;
  String asc;
  List<int> roles = [];

  factory FilterSortEmployeeData.fromJson(Map<String, dynamic> json) =>
    FilterSortEmployeeData(
      birthdayFrom: DateTime.parse(json["birthday_from"]),
      birthdayTo: DateTime.parse(json["birthday_to"]),
      hoursPerMonthFrom: json["hours_per_month_from"],
      hoursPerMonthTo: json["hours_per_month_to"],
      gender: json["gender"],
      sortColumn: json['sort_column'],
      asc: json['asc']
    );

  Map<String, dynamic> toJson() => {
    // "birthday_from": "${birthdayFrom.year.toString().padLeft(4, '0')}-${birthdayFrom.month.toString().padLeft(2, '0')}-${birthdayFrom.day.toString().padLeft(2, '0')}",
    "birthday_from": Constants.dateOnlyFormat.format(birthdayFrom),
    // "birthday_to": "${birthdayTo.year.toString().padLeft(4, '0')}-${birthdayTo.month.toString().padLeft(2, '0')}-${birthdayTo.day.toString().padLeft(2, '0')}",
    "birthday_to": Constants.dateOnlyFormat.format(birthdayTo),
    "hours_per_month_from": hoursPerMonthFrom,
    "hours_per_month_to": hoursPerMonthTo,
    "gender": gender,
    'sort_column': sortColumn,
    'asc': asc,
    'roles': roles.join('+')
  };
}