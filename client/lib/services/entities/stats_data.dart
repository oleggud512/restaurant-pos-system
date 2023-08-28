import 'package:client/services/entities/dish_per_period.dart';
import 'package:client/services/entities/emp_worked.dart';
import 'package:client/services/entities/orders_per_period.dart';

StatsData statsDataFromMap(Map<String, dynamic> map) => StatsData.fromJson(map);

class StatsData {
    StatsData({
        required this.ordPerPeriod,
        required this.dishPerPeriod,
        required this.empWorked,
    });

    List<OrdersPerPeriod> ordPerPeriod;
    List<DishPerPeriod> dishPerPeriod;
    List<EmpWorked> empWorked;

    factory StatsData.fromJson(Map<String, dynamic> json) => StatsData(
        ordPerPeriod: List<OrdersPerPeriod>.from(json["ord_per_period"].map((x) => OrdersPerPeriod.fromJson(x))),
        dishPerPeriod: List<DishPerPeriod>.from(json["dish_per_period"].map((x) => DishPerPeriod.fromJson(x))),
        empWorked: List<EmpWorked>.from(json["emp_worked"].map((x) => EmpWorked.fromJson(x))),
    );
}