class DishGrocery {
    DishGrocery({
        required this.grocId,
        required this.grocName,
        required this.grocCount,
    });

    int grocId;
    String grocName;
    double grocCount;

    @override
    String toString() {
      return toJson().toString();
    }

    factory DishGrocery.initial(int grocId, String grocName) => DishGrocery(
      grocCount: 0,
      grocId: grocId,
      grocName: grocName,
    );

    factory DishGrocery.fromJson(Map<String, dynamic> json) => DishGrocery(
        grocId: json["groc_id"],
        grocName: json["groc_name"],
        grocCount: json["dc_count"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "groc_id": grocId,
        "groc_name": grocName,
        "groc_count": grocCount,
    };
}