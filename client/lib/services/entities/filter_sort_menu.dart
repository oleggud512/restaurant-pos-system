import 'package:client/services/entities/dish_group.dart';
import 'package:client/services/entities/grocery.dart';

class FilterSortMenu {
  String asc = 'desc';
  String sortColumn = 'dish_name'; // 'dish_price'
  String like = '';
  List<Grocery> groceries = [];
  List<DishGroup> groups = [];
  double? priceFrom;
  double? priceTo;

  FilterSortMenu({
    // required this.groceries,
    required this.priceFrom,
    required this.priceTo
  });

  factory FilterSortMenu.fromJson(Map m) => FilterSortMenu(
    // groceries: [],
    priceFrom: m['min_price'],
    priceTo: m['max_price']
  );

  factory FilterSortMenu.init() => FilterSortMenu(
    priceFrom: null,
    priceTo: null
  );

  Map<String, dynamic> toJson() => {
      "asc" : asc,
      "sort_column" : sortColumn,
      "like" : like,
      "price_from" : priceFrom,
      "price_to" : priceTo,
      "groceries" : List<int>.from(groceries.map((e) => e.grocId)).join('+'),
      "groups" : List<int>.from(groups.map((e) => e.groupId)).join('+'),
  };
}