import 'dart:convert';

import 'package:equatable/equatable.dart';

String diaryToJson(List<Diary> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Diary extends Equatable {
    const Diary({
        required this.dId,
        required this.date,
        required this.empId,
        required this.startTime,
        required this.endTime,
        required this.gone,
        required this.empName
    });

    final int dId;
    final DateTime date;
    final int empId;
    final String startTime;
    final String endTime;
    final bool gone;
    final String empName;

    factory Diary.fromJson(Map<String, dynamic> json) {
        return Diary(
            dId: json["d_id"],
            date: DateTime.parse(json["date_"]),
            empId: json["emp_id"],
            startTime: json["start_time"],
            endTime: json["end_time"],
            gone: json["gone"],
            empName: json['emp_name']
        );
    }

    Map<String, dynamic> toJson() => {
        "d_id": dId,
        "date_": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "emp_id": empId,
        "start_time": startTime,
        "end_time": endTime,
        "gone": gone,
    };

  @override
  List<Object?> get props => [
      dId,
      date,
      empId,
      startTime,
      endTime,
      gone,
      empName
  ];
}