import 'package:client/services/entities/employee.dart';
import 'package:client/services/entities/role.dart';
import 'package:client/utils/bloc_provider.dart';
import 'package:client/features/employees/employees_bloc.dart';
import 'package:client/features/employees/employees_states_events.dart';
import 'package:client/features/employees/widgets/select_employee_dialog.dart';
import 'package:client/features/employees/widgets/diary_container.dart';
import 'package:client/features/employees/widgets/employee_container.dart';
import 'package:client/features/employees/widgets/employee_edit_dialog.dart';
import 'package:client/features/employees/widgets/role_edit_dialog.dart';
import 'package:client/features/employees/widgets/role_container.dart';
import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/utils/extensions/string.dart';
import 'package:client/utils/yes_no_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/repo.dart';
import '../home/toggle_drawer_button.dart';
import 'filter_sort_employee/filter_sort_employee.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  State<Employees> createState() => _EmployeesState();
}

enum EmployeesPage { employees, roles }

class _EmployeesState extends State<Employees> {

  EmployeesPage curPage = EmployeesPage.employees;
  int curI = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late AppLocalizations l;


  Future<void> addNewEmployee(BuildContext context, EmployeeBloc bloc) async {
    final employee = await EmployeeEditDialog(roles: bloc.roles).show(context);
    if (employee != null && employee.isSaveable && mounted) {
      // TODO: (6) hardcoded Repo usage.
      await context.read<Repo>().addEmployee(employee);
      bloc.add(EmployeeLoadEvent());
    }
  }


  Future<void> addNewRole(BuildContext context, EmployeeBloc bloc) async {
    final role = await const RoleEditDialog().show(context);
    if (role != null && mounted) {
      await context.read<Repo>().addRole(role);
      bloc.add(EmployeeLoadEvent());
    }
  }


  Future<void> addNewDiary(BuildContext context, EmployeeBloc bloc) async {
    final employee = await SelectEmployeeDialog(
        employees: bloc.employees
    ).show(context);
    if (employee != null && mounted) {
      await context.read<Repo>().diaryStart(employee.empId!);
      bloc.add(EmployeeLoadEvent());
    }
  }


  Future<void> onAddButtonPressed(BuildContext context, EmployeeBloc bloc) async {
    return switch (curI) {
      0 => addNewEmployee(context, bloc),
      1 => addNewRole(context, bloc),
      2 => addNewDiary(context, bloc),
      _ => throw 'invalid page index'
    };
  }


  Future<void> updateEmployee(
    Employee employeeToUpdate,
    EmployeeBloc bloc
  ) async {
    final updatedEmployee = await EmployeeEditDialog(
    roles: bloc.roles,
    employee: employeeToUpdate
    ).show(context);

    if (updatedEmployee == null) return;
    if (!updatedEmployee.isSaveable) return;
    if (!mounted) return;

    await context.read<Repo>().updateEmployee(updatedEmployee);
    // TODO: make updateEmployee return updatedEmployee,
    //  refresh only this employee using bloc
    bloc.add(EmployeeLoadEvent());
  }


  Future<void> updateRole(
      BuildContext context,
      Role role,
      EmployeeBloc bloc
      ) async {
    final updatedRole = await RoleEditDialog(role: role).show(context);

    if (updatedRole == null) return;
    if (!mounted) return;

    await context.read<Repo>().updateRole(updatedRole);
    bloc.add(EmployeeLoadEvent());
  }


  Future<void> deleteRole(
      BuildContext context,
      Role role,
      EmployeeBloc bloc
      ) async {
    final isSure = await YesNoDialog(
        message: 'Are you sure you want to delete this role? This action is irreversible'.hc
    ).show(context);

    if (isSure != true) return;
    if (!mounted) return;

    // TODO: why without this 'await' the whole server crushes???
    //  it's because flask's multithreading and mysql connection don't allow
    //  to reuse the same connection across multiple threads
    await context.read<Repo>().deleteRole(role.roleId!);
    bloc.add(EmployeeLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    l = AppLocalizations.of(context)!;
    return BlocProvider<EmployeeBloc>(
      create: (_) => EmployeeBloc(Provider.of<Repo>(context, listen: false))
        ..add(EmployeeLoadEvent()),
      child: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          final bloc = context.readBloc<EmployeeBloc>();

          if (state is EmployeeLoadingState) {
            return Scaffold(
              bottomNavigationBar: buildBNBar(), 
              appBar: AppBar(
                leading: const ToggleDrawerButton(),
              ), 
              body: const Center(child: CircularProgressIndicator())
            );
          }

          return switch (curI) {
            0 => buildEmployeePage(context, bloc, state),
            1 => buildRolesPage(context, bloc, state),
            2 => buildDiaryPage(context, bloc, state),
            _ => throw 'incorrect index'
          };
        }
      ),
    );
  }


  Widget buildEmployeePage(BuildContext context, EmployeeBloc bloc, EmployeeState state) {
    if (state is EmployeeLoadedState) {
      return Scaffold(
        key: scaffoldKey,
        endDrawer: const FilterSortEmployee(),
        bottomNavigationBar: buildBNBar(),
        appBar: buildAppBar(context, bloc),
        body: ListView(
          children: [
            // TODO: (7) wtf is happening here? Why? Fix it.
            for (int i = 0; i < bloc.employees.length; i++) if (bloc.filteredEmployees.contains(bloc.employees[i])) EmployeeContainer(
              employee: bloc.employees[i],
              role: bloc.roles.firstWhere((e) => e.roleId == bloc.employees[i].roleId),
              onTap: () => updateEmployee(bloc.employees[i], bloc),
            )
          ]
        )
      );
    }
    return const Material();
  }


  Widget buildRolesPage(BuildContext context, EmployeeBloc bloc, EmployeeState state) {
    if (state is EmployeeLoadedState) {
      return Scaffold(
        appBar: buildAppBar(context, bloc),
        body: ListView(
            children: [
              for (final role in bloc.roles) RoleContainer(
                role,
                onEditRole: () => updateRole(context, role, bloc),
                onDeleteRole: () => deleteRole(context, role, bloc),
              )
            ]
        ),
        bottomNavigationBar: buildBNBar(),
      );
    }
    return const Material();
  }


  Widget buildDiaryPage(BuildContext context, EmployeeBloc bloc, EmployeeState state) {
    return Scaffold(
      appBar: buildAppBar(context, bloc),
      bottomNavigationBar: buildBNBar(),
      body: ListView(
        children: [
          for (final diaryEntry in bloc.diary) DiaryContainer(
              diary: diaryEntry,
              onDelete: () async {
                await context.read<Repo>().deleteDiary(diaryEntry.dId);
                bloc.add(EmployeeReloadDiary());
              },
              onGone: () async {
                await context.read<Repo>().diaryGone(diaryEntry.empId);
                bloc.add(EmployeeReloadDiary());
              }
          )
        ],
      ),
    );
  }


  PreferredSizeWidget buildAppBar(BuildContext context, EmployeeBloc bloc) {
    return AppBar(
      leading: const ToggleDrawerButton(),
      title: Center(child: curI == 0 ? Text(l.employees) : curI == 1 ? Text(l.roles) : Text(l.diary)), 
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onAddButtonPressed(context, bloc)
        ),
        if (curI == 0) IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          onPressed: () {
            scaffoldKey.currentState?.openEndDrawer();
          },
        )
      ]
    );
  }

  Widget buildBNBar() {
    return BottomNavigationBar(
      currentIndex: curI,
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.people_alt_rounded), label: l.employees, tooltip: ''),
        BottomNavigationBarItem(icon: const Icon(Icons.content_paste_search_rounded), label: l.roles, tooltip: ''),
        BottomNavigationBarItem(icon: const Icon(Icons.note_rounded), label: l.diary, tooltip: '')
      ],
      onTap: (i) {
        setState(() {
          curI = i;
        });
      },
    );
  }
}
