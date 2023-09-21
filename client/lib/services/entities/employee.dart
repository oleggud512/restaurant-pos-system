import 'dart:convert';

import 'package:equatable/equatable.dart';

List<Employee> employeeListFromJson(String str) => List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee extends Equatable {
    static final minBirthday = DateTime.parse('2000-01-01');

    Employee({
        this.empId,
        this.roleId = 0,
        this.isWaiter = false,
        this.empFname = '',
        this.empLname = '',
        DateTime? birthday,
        this.phone = '',
        this.email = '',
        this.gender = 'm',
        this.hoursPerMonth = 0,
    }) : birthday = birthday ?? minBirthday;

    final int? empId;
    final int roleId;
    final bool isWaiter;
    final String empFname;
    final String empLname;
    final DateTime birthday;
    final String phone;
    final String email;
    final String gender;
    final int hoursPerMonth;

    factory Employee.fromJson(Map<String, dynamic> json) {
        final empId = json['emp_id'];
        if (empId == null) throw 'EMP ID IS NULL...';
        print(json['birthday']);
        return Employee(
            empId: json['emp_id'],
            roleId: json["role_id"],
            isWaiter: json['is_waiter'],
            empFname: json["emp_fname"],
            empLname: json["emp_lname"],
            birthday: DateTime.parse(json["birthday"]),
            phone: json["phone"],
            email: json["email"],
            gender: json["gender"],
            hoursPerMonth: json["hours_per_month"],
        );
    }

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

    bool get isSaveable => roleId != 0 && empFname.isNotEmpty;

    Employee copyWith({
        int? roleId,
        bool? isWaiter,
        String? empFname,
        String? empLname,
        DateTime? birthday,
        String? phone,
        String? email,
        String? gender,
        int? hoursPerMonth
    }) => Employee(
        empId: empId,
        roleId: roleId ?? this.roleId,
        isWaiter: isWaiter ?? this.isWaiter,
        empFname: empFname ?? this.empFname,
        empLname: empLname ?? this.empLname,
        birthday: birthday ?? this.birthday,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        gender: gender ?? this.gender,
        hoursPerMonth: hoursPerMonth ?? this.hoursPerMonth,
    );

    @override
    List<Object?> get props => [
        roleId,
        isWaiter,
        empFname,
        empLname,
        birthday,
        phone,
        email,
        gender,
        hoursPerMonth
    ];
}