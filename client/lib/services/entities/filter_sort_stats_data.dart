class FilterSortStatsData {
  
  DateTime fromBase;
  DateTime toBase;
  DateTime ordFrom;
  DateTime ordTo;
  String group;
  DateTime dishFrom;
  DateTime dishTo;

  FilterSortStatsData({
    required this.fromBase,
    required this.toBase,
    required this.ordFrom,
    required this.ordTo,
    required this.group,
    required this.dishTo,
    required this.dishFrom
  });

  factory FilterSortStatsData.fromJson(Map<String, dynamic> json) => FilterSortStatsData(
    fromBase: DateTime.parse(json['ord_from']), // 'from_base'
    toBase: DateTime.parse(json['ord_to']), // 'to_base'
    ordFrom: DateTime.parse(json['ord_from']),
    ordTo: DateTime.parse(json['ord_to']),
    dishFrom: DateTime.parse(json['dish_from']),
    dishTo: DateTime.parse(json['dish_to']),
    group: json['group']
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ord_from' : ordFrom.  toIso8601String(),
      'ord_to'   : ordTo.    toIso8601String(),
      'dish_from': dishFrom. toIso8601String(),
      'dish_to'  : dishTo.   toIso8601String(),
      'group': group
    };
  }
}