import 'package:client/services/entities/grocery.dart';

class Supplier {
    Supplier({
        required this.supplierId,
        required this.supplierName,
        this.contacts,
        this.groceries = const [],
        this.supGrocPrice
    });

    int supplierId;
    String supplierName;
    String? contacts;
    List<Grocery> groceries;

    // похоже, это вообще не нужно самому Supplier... 
    double? supGrocPrice; // для таблицы в GroceryDialog

    factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        supplierId: json["supplier_id"],
        supplierName: json["supplier_name"],
        contacts: json["contacts"],
        groceries: (json['groceries'] != null) ? List<Grocery>.from(json["groceries"].map((x) => Grocery.fromJson(x))) : [],
        supGrocPrice: json["sup_groc_price"],
    );

    Map<String, dynamic> toJson() => {
        "supplier_id": supplierId,
        "supplier_name": supplierName,
        "contacts": contacts,
        "groceries": List<dynamic>.from(groceries.map((x) => x.toJson())), // если мы решимся что-то 
                                          // отправить, то это что-то точно будет с ингредиентами
                                          // даже если пустыми...
    };

    Supplier copyWith({
      String? supplierName,
      int? supplierId,
      String? Function()? contacts,
      List<Grocery>? groceries,
      double? Function()? supGrocPrice
    }) {
      return Supplier(
        supplierName: supplierName ?? this.supplierName,
        supplierId: supplierId ?? this.supplierId,
        groceries: groceries ?? this.groceries,
        contacts: contacts != null ? contacts() : this.contacts,
        supGrocPrice: supGrocPrice != null ? supGrocPrice() : this.supGrocPrice,
      );
    }
}