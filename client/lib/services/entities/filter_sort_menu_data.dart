import 'package:client/services/entities/dish_group.dart';
import 'package:client/services/entities/grocery/grocery.dart';

class FilterSortMenuData {
  String asc = 'desc';
  String sortColumn = 'dish_name'; // 'dish_price'
  double? priceFrom;
  double? priceTo;

  String like = '';
  List<Grocery> groceries = [];
  List<DishGroup> groups = [];

  FilterSortMenuData({
    this.priceFrom,
    this.priceTo
  });

  factory FilterSortMenuData.fromJson(Map m) => FilterSortMenuData(
    priceFrom: double.parse(m['min_price']),
    priceTo: double.parse(m['max_price'])
  );

  /// actually, toQuery()
  Map<String, dynamic> toJson() => {
      "asc" : asc,
      "sort_column" : sortColumn,
      "like" : like,
      "price_from" : priceFrom,
      "price_to" : priceTo,
      "groceries" : groceries.map((e) => e.grocId).toList().join('+'),
      "groups" : groups.map((e) => e.groupId).toList().join('+'),
  };
}