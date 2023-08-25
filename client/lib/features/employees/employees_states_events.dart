import 'package:equatable/equatable.dart';


class EmployeeEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class EmployeeLoadEvent extends EmployeeEvent { }

class EmployeeReloadDiary extends EmployeeEvent { }

class EmployeeFilterGenderEvent extends EmployeeEvent {
  EmployeeFilterGenderEvent(this.newVal, this.gender);
  final bool newVal;
  final String gender;
}

class EmployeeRoleSelectedEvent extends EmployeeEvent {
  EmployeeRoleSelectedEvent(this.index, this.newVal);
  final int index;
  final bool newVal;
}

class EmployeeLikeChangedEvent extends EmployeeEvent {
  EmployeeLikeChangedEvent(this.newVal);
  final String newVal;
}

///////////////////////////////////////////////////////////////////////////////

class EmployeeState extends Equatable {

  @override
  List<Object?> get props => [];
}

class EmployeeLoadingState extends EmployeeState { }

class EmployeeLoadedState extends EmployeeState { }