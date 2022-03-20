import 'package:client/bloc_provider.dart';
import 'package:client/employees/employees_bloc.dart';
import 'package:client/employees/employees_states_events.dart';
import 'package:client/employees/widgets/role_edit_dialog.dart';
import 'package:client/employees/widgets/role_container.dart';
import 'package:client/services/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/repo.dart';

class Employees extends StatefulWidget {
  Employees({Key? key}) : super(key: key);

  @override
  State<Employees> createState() => _EmployeesState();
}

enum EmployeesPage { employees, roles }

class _EmployeesState extends State<Employees> {

   EmployeesPage curPage = EmployeesPage.employees;
   int curI = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeeBloc>(
      blocBuilder: () => EmployeeBloc(Provider.of<Repo>(context, listen: false)),
      blocDispose: (EmployeeBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          var bloc = BlocProvider.of<EmployeeBloc>(context);
          return StreamBuilder(
            stream: bloc.outState,
            builder: (context, snapshot) {
              var state = snapshot.data;
              if (state is EmployeeLoadingState) {
                return Scaffold(bottomNavigationBar: buildBNBar(),appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
              }
              
              if (curI == 0) {
                if (state is EmployeeLoadedState) {
                  return Scaffold(
                    bottomNavigationBar: buildBNBar(),
                    appBar: AppBar(), 
                    body: const Center(child: Text('EMPLOYEES'))
                  );
                }

              } else if (curI == 1) {
                if (state is EmployeeLoadedState) {
                  return Scaffold(
                    appBar: buildRolesAppBar(bloc),
                    body: ListView(
                      children: [
                        for (int i = 0; i < bloc.roles.length; i++) RoleContainer(
                          bloc.roles[i],
                          onTap: () async {
                            // диалог для просмотра / редактирования роли
                            await showDialog(
                              context: context, 
                              builder: (_) => RoleEditDialog(
                                title: Center(child: Text('update role')),
                                role: bloc.roles[i],
                                actions: [
                                  ElevatedButton(
                                    child: Text('delete'),
                                    onPressed: () async {
                                      await Provider.of<Repo>(context, listen: false).deleteRole(bloc.roles[i].roleId!);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text('save'),
                                    onPressed: () async {
                                      if (bloc.roles[i].saveable) {
                                        await Provider.of<Repo>(context, listen: false).updateRole(bloc.roles[i]);
                                        Navigator.pop(context);
                                      } 
                                    },
                                  ),
                                ],
                              )
                            );
                            bloc.inEvent.add(EmployeeLoadEvent());
                          },
                        )
                      ]
                    ),
                    bottomNavigationBar: buildBNBar(),
                  );
                }
              }
              return Container();
            }
          );
        }
      ),
    );
  }

  PreferredSizeWidget buildRolesAppBar(EmployeeBloc bloc) {
    Role role = Role.init();
    return AppBar(
      title: Center(child: Text("roles")), 
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            await showDialog(context: context, builder: (_) => RoleEditDialog(
              title: Center(child: Text('add role')),
              role: role,
              actions: [
                ElevatedButton(
                  child: Text('add'),
                  onPressed: () async {
                    if (role.saveable) {
                      await Provider.of<Repo>(context, listen: false).addRole(role);
                      Navigator.pop(context); 
                    }
                  },
                )
              ],
            ));
            bloc.inEvent.add(EmployeeLoadEvent());
          }
        )
      ]
    );
  }

  Widget buildBNBar() {
    return BottomNavigationBar(
      currentIndex: curI,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.people_alt_rounded), label: "employees", tooltip: ''),
        BottomNavigationBarItem(icon: Icon(Icons.content_paste_search_rounded), label: 'roles', tooltip: '')
      ],
      onTap: (i) {
        setState(() {
          curI = i;
        });
      },
    );
  }
}