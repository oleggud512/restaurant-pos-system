import 'package:equatable/equatable.dart';


class EmployeeEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class EmployeeLoadEvent extends EmployeeEvent { }

class EmployeeReloadDiary extends EmployeeEvent { }

///////////////////////////////////////////////////////////////////////////////

class EmployeeState extends Equatable {

  @override
  List<Object?> get props => [];
}

class EmployeeLoadingState extends EmployeeState { }

class EmployeeLoadedState extends EmployeeState { }