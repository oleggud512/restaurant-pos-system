import 'dart:convert';

List<Diary> diaryListFromJson(String str) => List<Diary>.from(json.decode(str).map((x) => Diary.fromJson(x)));

String diaryToJson(List<Diary> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Diary {
    Diary({
        required this.dId,
        required this.date,
        required this.empId,
        required this.startTime,
        required this.endTime,
        required this.gone,
        required this.empName
    });

    int dId;
    DateTime date;
    int empId;
    String startTime;
    String endTime;
    bool gone;
    String empName;

    factory Diary.fromJson(Map<String, dynamic> json) => Diary(
        dId: json["d_id"],
        date: DateTime.parse(json["date_"]),
        empId: json["emp_id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        gone: json["gone"] == 1 ? true : false,
        empName: json['emp_name']
    );

    Map<String, dynamic> toJson() => {
        "d_id": dId,
        "date_": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "emp_id": empId,
        "start_time": startTime,
        "end_time": endTime,
        "gone": gone,
    };
}