import 'dart:convert';

import 'package:client/services/entities/mini_supplier.dart';

FilterSortSupplysData filterSortDataFromJson(String str) => FilterSortSupplysData.fromJson(jsonDecode(str));

String filterSortDataToJson(FilterSortSupplysData data) => jsonEncode(data.toJson());

class FilterSortSupplysData {
    FilterSortSupplysData({
        required this.maxDate,
        required this.minDate,
        required this.maxPrice,
        required this.suppliers,
    }) : fPriceTo = maxPrice,
         fDateFrom = minDate,
         fDateTo = maxDate;

    DateTime minDate;
    DateTime maxDate;
    double maxPrice;
    List<MiniSupplier> suppliers;

    String sortCollumn = 'supply_date';
    String sortDirection = 'desc';
    double fPriceFrom = 0.0;
    double fPriceTo;
    DateTime fDateFrom;
    DateTime fDateTo;

    // String get sortCollumn => _sortCollumn;
    // set sortCollumn(String newVal) => sortCollumn = newVal;

    factory FilterSortSupplysData.fromJson(Map<String, dynamic> json) => FilterSortSupplysData(
        maxDate: DateTime.parse(json["max_date"]),
        minDate: DateTime.parse(json["min_date"]),
        maxPrice: json["max_summ"].toDouble(),
        suppliers: List<MiniSupplier>.from(json["suppliers"].map((x) => MiniSupplier.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
      'sort_collumn' : sortCollumn,
      'sort_direction' : sortDirection,
      'price_from' : fPriceFrom,
      'price_to' : fPriceTo,
      'date_from' : fDateFrom,
      'date_to' : fDateTo,
      'suppliers' : List<int>.from(suppliers
        .where((element) => element.selected == true)
        .map((e) => e.supplierId))
        .join('+')
    };
}
