
import 'package:client/services/entities/diary.dart';
import 'package:client/services/entities/employee.dart';
import 'package:client/services/entities/filter_sort_employee_data.dart';
import 'package:client/services/entities/role.dart';

import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';
import 'employees_states_events.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {

  Repo repo;
  late List<Role> roles;
  late List<Employee> employees;
  FilterSortEmployeeData? fsEmp;
  late List<Diary> diary;
  String like = '';

  List<Employee> get filteredEmployees => employees.where((e) => e.empId.toString().contains(like) || 
    e.empFname.toLowerCase().contains(like) || 
    e.empLname.toLowerCase().contains(like)).toList();

  EmployeeBloc(this.repo) : super(EmployeeLoadingState());

  @override
  void handleEvent(EmployeeEvent event) async {
    if (event is EmployeeLoadEvent) {
      emit(EmployeeLoadingState());
      final data = await repo.getRolesEmployees(fsEmp: fsEmp);
      roles = data['roles'];
      employees = data['employees'];
      fsEmp ??= data['filter_sort_data'];
      diary = data['diary'];
      emit(EmployeeLoadedState());
    } 
    else if (event is EmployeeReloadDiary) {
      emit(EmployeeLoadingState());
      diary = await repo.getDiary();
      emit(EmployeeLoadedState());
    }
    else if (event is EmployeeFilterGenderEvent) {
      event.newVal
          ? fsEmp!.gender += event.gender
          : fsEmp!.gender = fsEmp!.gender.replaceAll(event.gender, '');
      emit(EmployeeLoadedState());
    }
    else if (event case EmployeeRoleSelectedEvent(:final index, :final newVal)) {
      roles[index] = roles[index].copyWith(selected: newVal);
      event.newVal
          ? fsEmp!.roles.add(roles[event.index].roleId!)
          : fsEmp!.roles.removeWhere((e) => e == roles[event.index].roleId);
      emit(EmployeeLoadedState()); 
    }
    else if (event is EmployeeLikeChangedEvent) {
      like = event.newVal.toLowerCase();
      emit(EmployeeLoadedState());
    }
  }

}