import 'package:equatable/equatable.dart';

class PrimeCostData extends Equatable {
  final double total;
  final List<PrimeCostDataItem> items;

  const PrimeCostData({
    this.total = 0,
    this.items = const []
  });

  factory PrimeCostData.fromJson(Map<String, dynamic> json) {
    return PrimeCostData(
      total: json['total'],
      items: List<dynamic>.from(json['consist'])
        .map((i) => PrimeCostDataItem.fromJson(i))
        .toList()
    );
  }

  @override
  List<Object?> get props => [
    total,
    items
  ];
}

class PrimeCostDataItem extends Equatable {
  final int supplierId;
  final String supplierName;
  final int groceryId;
  final String groceryName;
  final double total;
  final double price;
  final double count;

  const PrimeCostDataItem({
    required this.supplierId,
    required this.supplierName,
    required this.groceryId,
    required this.groceryName,
    required this.total,
    required this.price,
    required this.count,
  });

  factory PrimeCostDataItem.fromJson(Map<String, dynamic> json) {
    return PrimeCostDataItem(
      supplierId: json['supplier_id'],
      supplierName: json['supplier_name'],
      groceryId: json['groc_id'],
      groceryName: json['groc_name'],
      total: json['groc_total'],
      price: json['min_price'],
      count: json['groc_count'],
    );
  }

  @override
  List<Object?> get props => [
    supplierId,
    supplierName,
    groceryId,
    groceryName,
    price,
    total,
    count
  ];
}