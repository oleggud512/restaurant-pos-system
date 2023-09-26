import 'package:client/services/entities/dish.dart';

class OrderItem {
  Dish dish;
  int count;
  double price;

  OrderItem({
    required this.dish,
    required this.count,
    required this.price
  });

  factory OrderItem.toAdd(Dish dish, int count) => OrderItem(
    count: count,
    dish: dish,
    price: count * dish.dishPrice!
  );

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    dish: Dish.fromJson(json['dish']),
    count: json['lord_count'],
    price: json['lord_price']
  );

  Map<String, dynamic> toJson() {
    return {
      "dish_id": dish.dishId,
      "count": count,
      "price": price
    };
  }

  // TODO: (2) make OrderItem immutable
  void increment() {
    count += 1;
    price += dish.dishPrice!;
  }

  void decrement() {
    count -= 1;
    price -= dish.dishPrice!;
  }

}