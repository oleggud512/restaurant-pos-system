import 'package:equatable/equatable.dart';

class MiniGrocery extends Equatable {
  final double? supGrocPrice;
  final int? grocId;
  final String grocName;
  final String grocMeasure;
  final int avaCount;

  const MiniGrocery({
    this.supGrocPrice,
    this.grocId,
    this.grocName = '',
    this.grocMeasure = 'gram',
    this.avaCount = 0
  });

  Map<String, dynamic> toJson() => {
    "groc_name" : grocName,
    "groc_measure" : grocMeasure,
    "ava_count" : avaCount,
    if (grocId != null) "groc_id": grocId,
    if (supGrocPrice != null) "sup_groc_price": supGrocPrice
  };

  MiniGrocery copyWith({
    double? Function()? supGrocPrice,
    int? Function()? grocId,
    String? grocName,
    String? grocMeasure, 
    int? avaCount
  }) => MiniGrocery(
    supGrocPrice: supGrocPrice != null ? supGrocPrice() : this.supGrocPrice,
    grocId: grocId != null ? grocId() : this.grocId,
    grocName: grocName ?? this.grocName,
    grocMeasure: grocMeasure ?? this.grocMeasure,
    avaCount: avaCount ?? this.avaCount,
  );
  
  @override
  List<Object?> get props => [
    grocId, 
    grocName, 
    grocMeasure,
    avaCount,
    supGrocPrice, 
  ];
}