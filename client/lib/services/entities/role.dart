import 'dart:convert';

import 'package:equatable/equatable.dart';

List<Role> roleListFromJson(String str) => List<Role>.from(json.decode(str).map((x) => Role.fromJson(x)));

String roleToJson(List<Role> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Role extends Equatable {

    Role({
        this.roleId,
        this.roleName = '',
        this.salaryPerHour = 0.0,
        this.selected = false
    });

    int? roleId;
    String roleName;
    double salaryPerHour;
    bool selected;

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        roleId: json["role_id"],
        roleName: json["role_name"],
        salaryPerHour: json["salary_per_hour"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "role_id": roleId,
        "role_name": roleName,
        "salary_per_hour": salaryPerHour,
    };

    bool get saveable => roleName.isNotEmpty;

    Role copyWith({
        String? roleName,
        double? salaryPerHour,
        bool? selected
    }) => Role(
        roleId: roleId,
        roleName: roleName ?? this.roleName,
        salaryPerHour: salaryPerHour ?? this.salaryPerHour,
        selected: selected ?? this.selected,
    );

    @override
    List<Object?> get props => [
        roleId,
        roleName,
        salaryPerHour,
        selected
    ];
}