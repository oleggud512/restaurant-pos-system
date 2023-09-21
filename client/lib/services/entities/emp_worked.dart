class EmpWorked {
    EmpWorked({
        required this.empId,
        required this.empName,
        required this.worked,
        required this.hoursPerMonth,
    });

    int empId;
    String empName;
    int worked;
    int hoursPerMonth;

    factory EmpWorked.fromJson(Map<String, dynamic> json) => EmpWorked(
        empId: json["emp_id"],
        empName: json["emp_name"],
        // TODO: WHY IS THIS STRING????
        worked: json["worked"],
        // TODO: BUT THIS IS NOT???
        hoursPerMonth: json["hours_per_month"],
    );
}