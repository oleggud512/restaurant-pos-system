class DishPerPeriod {
    DishPerPeriod({
        required this.dishId,
        required this.dishName,
        required this.count,
    });

    int dishId;
    String dishName;
    int count;

    factory DishPerPeriod.fromJson(Map<String, dynamic> json) => DishPerPeriod(
        dishId: json["dish_id"],
        dishName: json["dish_name"],
        count: json["count"],
    );
}