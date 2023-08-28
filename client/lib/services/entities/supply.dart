
import 'dart:convert';

import 'package:client/services/entities/supply_grocery.dart';

Supply supplyFromJson(String str) => Supply.fromJson(json.decode(str));

List<Supply> listSupplyFromJson(String str){ return List<Supply>.from(jsonDecode(str).map((x) => Supply.fromJson(x)));}

String supplyToJson(Supply data) => json.encode(data.toJson());

String dateToString(DateTime date) => "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

class Supply {
    Supply({
        this.supplyId,
        this.supplierId,
        this.supplierName = '',
        this.summ,
        DateTime? supplyDate,
        this.groceries = const [],
    }) : supplyDate = supplyDate ?? DateTime.now();

    final int? supplyId; // это будет null при добавлении новой поставки
    final int? supplierId; // по вот этому будет проверяться можем ли мы добавить поставку или нет (если это будет null, то ничего у нас не выйдет)
    final double? summ; // from server only
    final String supplierName;
    final DateTime supplyDate;
    final List<SupplyGrocery> groceries; // по этому тоже проверяем на 
    
    factory Supply.fromJson(Map<String, dynamic> json) => Supply(
        supplyId: json["supply_id"],
        summ: json["summ"],
        supplierId: json["supplier_id"],
        supplierName: json["supplier_name"],
        supplyDate: DateTime.parse(json["supply_date"]),
        groceries: List<SupplyGrocery>.from(json["groceries"].map((x) => SupplyGrocery.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "supplier_id": supplierId,
        "supply_date": "${supplyDate.year.toString().padLeft(4, '0')}-${supplyDate.month.toString().padLeft(2, '0')}-${supplyDate.day.toString().padLeft(2, '0')}",
        "groceries": List<dynamic>.from(groceries.map((x) => x.toJson())),
    };

    Supply copyWith({
      int? Function()? supplyId,
      int? Function()? supplierId,
      String? supplierName,
      DateTime? supplyDate,
      List<SupplyGrocery>? groceries,
    }) {
      return Supply(
        supplyId: supplyId != null ? supplyId() : this.supplyId,
        supplierId: supplierId != null ? supplierId() : this.supplierId,
        supplierName: supplierName ?? this.supplierName,
        supplyDate: supplyDate ?? this.supplyDate,
        groceries: groceries ?? this.groceries,
        summ: summ
      );
    }
}