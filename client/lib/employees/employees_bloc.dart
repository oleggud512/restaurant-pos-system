import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../bloc_provider.dart';
import '../services/models.dart';
import '../services/repo.dart';
import 'employees_states_events.dart';

class EmployeeBloc extends Bloc {

  StreamController<EmployeeEvent> _eventCont = BehaviorSubject<EmployeeEvent>();
  Stream<EmployeeEvent> get _outEvent => _eventCont.stream;
  Sink<EmployeeEvent> get inEvent => _eventCont.sink;

  StreamController<EmployeeState> _stateCont = BehaviorSubject<EmployeeState>();
  Stream<EmployeeState> get outState => _stateCont.stream;
  Sink<EmployeeState> get _inState => _stateCont.sink;

  Repo repo;
  late List<Role> roles;
  late List<Employee> employees;
  late List<Diary> diary;

  EmployeeBloc(this.repo) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(EmployeeLoadEvent());
  }

  _handleEvent(dynamic event) async {
    if (event is EmployeeLoadEvent) {
      _inState.add(EmployeeLoadingState());
      var data = await repo.getRolesEmployees();
      roles = data['roles'];
      employees = data['employees'];
      diary = data['diary'];
      _inState.add(EmployeeLoadedState());
      
    } else if (event is EmployeeReloadDiary) {
      _inState.add(EmployeeLoadingState());
      diary = await repo.getDiary();
      _inState.add(EmployeeLoadedState());
    }
  }


  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}