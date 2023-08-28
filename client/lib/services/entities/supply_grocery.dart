class SupplyGrocery {
  SupplyGrocery({
      this.grocId,
      this.grocName,
      this.grocCount = 0,
      this.supGrocPrice = 0
  });

  final int? grocId;
  final String? grocName;
  final double? grocCount;
  final double? supGrocPrice;


  factory SupplyGrocery.empty() => SupplyGrocery(
    grocId: null,
    grocName: null,
    grocCount: 0,
    supGrocPrice: 0
  );

  factory SupplyGrocery.fromJson(Map<String, dynamic> json) {
    return SupplyGrocery(
        supGrocPrice: json["groc_price"],
        grocId: json["groc_id"],
        grocName: json["groc_name"],
        grocCount: json["groc_count"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
      "groc_id": grocId,
      "groc_count": grocCount!.toInt(),
  };

  SupplyGrocery copyWith({
    int? Function()? grocId,
    String? Function()? grocName,
    double? Function()? grocCount,
    double? Function()? supGrocPrice,
  }) {
    return SupplyGrocery(
      grocId: grocId != null ? grocId() : this.grocId,
      grocName: grocName != null ? grocName() : this.grocName,
      grocCount: grocCount != null ? grocCount() : this.grocCount,
      supGrocPrice: supGrocPrice != null ? supGrocPrice() : this.supGrocPrice,
    );
  }
}
