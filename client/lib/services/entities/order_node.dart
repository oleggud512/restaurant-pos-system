import 'package:client/services/entities/dish.dart';

class OrderNode {
  Dish dish;
  int count;
  double price;

  OrderNode({
    required this.dish,
    required this.count,
    required this.price
  });

  factory OrderNode.toAdd(Dish dish, int count) => OrderNode(
    count: count,
    dish: dish,
    price: count * dish.dishPrice!
  );

  factory OrderNode.fromJson(Map<String, dynamic> json) => OrderNode(
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

  void increment() {
    count += 1;
    price += dish.dishPrice!;
  }

  void decrement() {
    count -= 1;
    price -= dish.dishPrice!;
  }

}