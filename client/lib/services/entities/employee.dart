import 'dart:convert';

List<Employee> employeeListFromJson(String str) => List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
    Employee({
        required this.empId,
        required this.roleId,
        required this.isWaiter,
        required this.empFname,
        required this.empLname,
        required this.birthday,
        required this.phone,
        required this.email,
        required this.gender,
        required this.hoursPerMonth,
    });

    int? empId;
    int roleId;
    bool isWaiter;
    String empFname;
    String empLname;
    DateTime birthday;
    String phone;
    String email;
    String gender;
    int hoursPerMonth;

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        empId: json['emp_id'],
        roleId: json["role_id"],
        isWaiter: json['is_waiter'] == 1 ? true : false,
        empFname: json["emp_fname"],
        empLname: json["emp_lname"],
        birthday: DateTime.parse(json["birthday"]),
        phone: json["phone"],
        email: json["email"],
        gender: json["gender"],
        hoursPerMonth: json["hours_per_month"],
    );

    factory Employee.init() => Employee(
        empId: null,
        roleId: 0,
        isWaiter: false,
        empFname: '',
        empLname: '',
        birthday: DateTime.parse('2000-01-01'),
        phone: '',
        email: '',
        gender: 'm',
        hoursPerMonth: 0,
    );

    Map<String, dynamic> toJson() => {
        "emp_id": empId,
        "is_waiter": isWaiter ? 1 : 0,
        "role_id": roleId,
        "emp_fname": empFname,
        "emp_lname": empLname,
        "birthday": "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "phone": phone,
        "email": email,
        "gender": gender,
        "hours_per_month": hoursPerMonth,
    };

    bool get saveable => roleId != 0 && empFname.isNotEmpty && empLname.isNotEmpty;
}