class OrdersPerPeriod {
    OrdersPerPeriod({
        required this.ordStartTime,
        required this.count,
    });

    DateTime ordStartTime;
    int count;

    factory OrdersPerPeriod.fromJson(Map<String, dynamic> json) => OrdersPerPeriod(
        ordStartTime: DateTime.parse(json["ord_start_time"]),
        count: json["count"],
    );
}