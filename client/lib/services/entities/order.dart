import 'dart:convert';

import 'package:client/services/entities/order_node.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../utils/logger.dart';

List<Order> orderListFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order extends Equatable {

    Order({
        this.ordId,
        DateTime? ordDate,
        DateTime? ordStartTime,
        DateTime? ordEndTime,
        this.moneyFromCustomer,
        this.totalPrice = 0,
        this.empId,
        this.empName,
        this.comm = '',
        this.isEnd = false,
        this.listOrders = const []
    }) : ordDate = ordDate ?? DateTime.now(),
        ordStartTime = ordStartTime ?? DateTime.now(),
        ordEndTime = ordEndTime ?? DateTime.now();


    final int? empId;
    final String comm;
    final bool isEnd;
    final List<OrderNode> listOrders;

    final int? ordId;
    final DateTime ordDate;
    final DateTime ordStartTime;
    final DateTime? ordEndTime;
    final double? moneyFromCustomer;
    final double totalPrice;
    final String? empName;


    factory Order.fromJson(Map<String, dynamic> json) {
      final endTimeStr = json["ord_end_time"];
      final totalPrice = json['total_price'];
      return Order(
        ordId: json['ord_id'],
        ordDate: DateTime.parse(json["ord_date"]),
        ordStartTime: DateTime.parse(json['ord_start_time']),
        ordEndTime: endTimeStr != null ? DateTime.parse(endTimeStr) : null,
        moneyFromCustomer: json["money_from_customer"],
        totalPrice: json['total_price'],
        empId: json["emp_id"],
        empName: json['emp_name'],
        comm: json["comm"],
        isEnd: json['is_end'] == 1
            ? true
            : false,
        listOrders: List.from(json['list_orders'])
            .map((e) => OrderNode.fromJson(e))
            .toList(),
      );
    }


    Map<String, dynamic> toJson() => {
      "emp_id": empId,
      "comm": comm,
      "is_end": isEnd ? 1 : 0,
      "list_orders" : listOrders.map((e) => e.toJson()).toList()
    };


    Order copyWith({
        DateTime? ordDate,
        DateTime? ordStartTime,
        DateTime? Function()? ordEndTime,
        double? Function()? moneyFromCustomer,
        double? totalPrice,
        int? Function()? empId,
        String? Function()? empName,
        String? comm,
        bool? isEnd,
        List<OrderNode>? listOrders
    }) {
        return Order(
            ordId: ordId,
            ordDate: ordDate ?? this.ordDate,
            ordStartTime: ordStartTime ?? this.ordStartTime,
            ordEndTime: ordEndTime != null ? ordEndTime() : this.ordEndTime,
            moneyFromCustomer: moneyFromCustomer != null
                ? moneyFromCustomer()
                : this.moneyFromCustomer,
            totalPrice: totalPrice ?? this.totalPrice,
            empId: empId != null ? empId() : this.empId,
            empName: empName != null ? empName() : this.empName,
            comm: comm ?? this.comm,
            isEnd: isEnd ?? this.isEnd,
            listOrders: listOrders ?? this.listOrders,
        );
    }

    Order refreshTotalPrice() {
        if (listOrders.isEmpty) return copyWith(totalPrice: 0);
        return copyWith(
            totalPrice: listOrders
                .map<double>((e) => e.price)
                .reduce((p, n) => p + n)
        );
    }

    // TODO: what?
    double get currentTotalPrice => listOrders
        .map<double>((e) => e.price)
        .reduce((p, n) => p + n);

    bool get isPayable => (moneyFromCustomer ?? 0) >= totalPrice;
    bool get canAddOrder => empId != 0;
    double get change => (moneyFromCustomer ?? 0) - totalPrice;


    @override
    List<Object?> get props => [
      ordId,
      ordDate,
      ordStartTime,
      ordEndTime,
      moneyFromCustomer,
      totalPrice,
      empId,
      empName,
      comm,
      isEnd,
      listOrders
    ];
}