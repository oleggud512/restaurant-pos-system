import 'package:equatable/equatable.dart';

class DishGrocery extends Equatable{
  const DishGrocery({
      required this.grocId,
      required this.grocName,
      this.grocCount = 0,
  });

  final int grocId;
  final String grocName;
  final double grocCount;

  @override
  String toString() {
    return '$runtimeType${toJson()}';
  }

  DishGrocery copyWith({
    int? grocId,
    String? grocName,
    double? grocCount,
  }) => DishGrocery(
    grocId: grocId ?? this.grocId,
    grocName: grocName ?? this.grocName,
    grocCount: grocCount ?? this.grocCount,
  );

  factory DishGrocery.fromJson(Map<String, dynamic> json) => DishGrocery(
      grocId: json["groc_id"],
      grocName: json["groc_name"],
      grocCount: json["groc_count"],
  );

  Map<String, dynamic> toJson() => {
      "groc_id": grocId,
      "groc_name": grocName,
      "groc_count": grocCount,
  };
  
  @override
  List<Object?> get props => [
    grocId,
    grocName,
    grocCount
  ];
}