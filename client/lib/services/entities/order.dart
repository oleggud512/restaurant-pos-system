import 'dart:convert';

import 'package:client/services/entities/order_node.dart';

List<Order> orderListFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
    Order({
        required this.ordId,
        required this.ordDate,
        required this.ordStartTime,
        required this.ordEndTime,
        required this.moneyFromCustomer,
        required this.totalPrice,
        required this.empId,
        this.empName,
        required this.comm,
        required this.isEnd,
        required this.listOrders
    });
    int? ordId;
    DateTime ordDate;
    DateTime ordStartTime;
    DateTime ordEndTime;
    double moneyFromCustomer;
    double totalPrice;
    int empId;
    String? empName;
    String comm;
    bool isEnd;
    List<OrderNode> listOrders;

    factory Order.init(int empId) {
      return Order(
        ordId: null,
        ordDate: DateTime.now(),
        ordStartTime: DateTime.now(),
        ordEndTime: DateTime.now(),
        moneyFromCustomer: 0,
        totalPrice: 0,
        empId: empId,
        comm: '',
        isEnd: false,
        listOrders: []
      );
    } 

    factory Order.fromJson(Map<String, dynamic> json) {
      print(json);
      return Order(
        ordId: json['ord_id'],
        ordDate: DateTime.parse(json["ord_date"]),
        ordStartTime: DateTime.parse(json["ord_start_time"]),
        ordEndTime: DateTime.parse(json["ord_end_time"]),
        moneyFromCustomer: json["money_from_customer"].toDouble(),
        totalPrice: json['total_price'],
        empId: json["emp_id"],
        empName: json['emp_name'],
        comm: json["comm"],
        isEnd: json['is_end'] == 1 ? true : false,
        listOrders: List<OrderNode>.from(json['list_orders'].map((e) => OrderNode.fromJson(e)))
    );}

    Map<String, dynamic> toJson() => {
        "emp_id": empId,
        "comm": comm,
        "is_end": isEnd ? 1 : 0,
        "list_orders" : List<Map<String, dynamic>>.from(listOrders.map((e) => e.toJson()))
    };

    void refreshTotalPrice() => (listOrders.isNotEmpty) ? 
      totalPrice = listOrders.map<double>((e) => e.price).reduce((value, element) => value + element) : 
      totalPrice = 0;

    bool get payable => moneyFromCustomer >= totalPrice;
    bool get addable => empId != 0;
    double get change => moneyFromCustomer - totalPrice;
}