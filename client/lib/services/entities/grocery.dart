import 'package:client/services/entities/supplier.dart';

class Grocery {

    Grocery({
        required this.supplierId,
        required this.grocId,
        required this.grocName,
        required this.supGrocPrice,
        required this.grocMeasure,
        required this.avaCount,
        required this.suppliedBy,
    });

    int? supplierId; // GroceriesCard doesn't need this
    int grocId;
    String grocName;
    double? supGrocPrice; // GroceriesCard doesn't need this
    String grocMeasure;
    double avaCount;
    List<Supplier> suppliedBy;
    bool selected = false;

    factory Grocery.fromJson(Map<String, dynamic> json) => Grocery(
        supplierId: json["supplier_id"],
        grocId: json["groc_id"],
        grocName: json["groc_name"],
        supGrocPrice: json["sup_groc_price"],
        grocMeasure: json["groc_measure"],
        avaCount: json["ava_count"],
        suppliedBy: json["supplied_by"].map<Supplier>((e) => Supplier.fromJson(e)).toList(),
    );

    Map<String, dynamic> toJson() => {
        "supplier_id": supplierId,
        "groc_id": grocId,
        "groc_name": grocName,
        "sup_groc_price": supGrocPrice,
        "groc_measure": grocMeasure,
        "ava_count": avaCount,
        // "supplied_by": suppliedBy,
    };
}