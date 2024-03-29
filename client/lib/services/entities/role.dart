import 'dart:convert';

List<Role> roleListFromJson(String str) => List<Role>.from(json.decode(str).map((x) => Role.fromJson(x)));

String roleToJson(List<Role> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Role {

    Role({
        required this.roleId,
        required this.roleName,
        required this.salaryPerHour,
    });

    int? roleId;
    String roleName;
    double salaryPerHour;
    bool selected = false;

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        roleId: json["role_id"],
        roleName: json["role_name"],
        salaryPerHour: json["salary_per_hour"].toDouble(),
    );

    factory Role.init() => Role(
      roleId: null,
      roleName: '',
      salaryPerHour: 0.0
    );

    Map<String, dynamic> toJson() => {
        "role_id": roleId,
        "role_name": roleName,
        "salary_per_hour": salaryPerHour,
    };

    bool get saveable => salaryPerHour > 0.0 && roleName.isNotEmpty;

}