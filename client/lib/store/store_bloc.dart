import 'dart:async';

// import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc_provider.dart';
import '../services/repo.dart';
import '../services/models.dart';
import 'store_states_events.dart';

// class StoreBloc extends Bloc<StoreEvent, StoreState> {
//   final Repo repo;

//   StoreBloc(this.repo) : super(StoreLoadingState()) {
//     on<StoreLoadEvent>((event, emit) async {
//       emit(StoreLoadingState());
//       final suppliers = await repo.getSuppliers();
//       emit(StoreLoadedState(suppliers));
//     });
//   }

// }

class StoreBloc extends Bloc {

  StreamController<StoreEvent> _eventCont = BehaviorSubject<StoreEvent>();
  Stream<StoreEvent> get _outEvent => _eventCont.stream; // ивенты слушает блок
  Sink<StoreEvent> get inEvent => _eventCont.sink;  // ивенты приходят В блок из вне


  StreamController<StoreState> _stateCont = BehaviorSubject<StoreState>();
  Stream<StoreState> get outState => _stateCont.stream; // состояния слушают снаружи
  Sink<StoreState> get _inState => _stateCont.sink; // состояния поступают из блока

  // StreamController<StoreState> _suppliersCont = BehaviorSubject<StoreState>();
  // Stream<StoreState> get outSuppliersState => _stateCont.stream; 
  // Sink<StoreState> get _inSuppliersState => _stateCont.sink;

  // StreamController<StoreState> _groceriesCont = BehaviorSubject<StoreState>();
  // Stream<StoreState> get outGroceriesState => _stateCont.stream; 
  // Sink<StoreState> get _inGroceriesState => _stateCont.sink;
  final String aa = "moomomomomommmmooooommommommomomoooooomm";
  Repo repo;
  List<Supplier> suppliers = [];
  List<Grocery> groceries = [];
  // bool groceriesSortDesc = true;

  StoreBloc(this.repo) {
    _eventCont.stream.listen((event) {_handleEvent(event);});
    inEvent.add(StoreLoadEvent());
  }
  
  _handleEvent(dynamic event) async {
    switch (event.runtimeType) {

      case StoreLoadEvent:
        print("StoreLoadEvent");
        _inState.add(StoreLoadingState());
        suppliers = await repo.getSuppliers();
        groceries = await repo.getGroceries();
        _inState.add(StoreLoadedState(suppliers, groceries)); 
        print(outState.last);
        print(outState.first);
        break;

      case StoreReloadGroceriesEvent:
        print("StoreReloadGroceriesEvent");
        _inState.add(StoreGroceriesLoadingState());
        groceries = await repo.getGroceries(like: event.like);
        _inState.add(StoreLoadedState(suppliers, groceries));
        break;
      
      default:
        print("error with event");
        break;
    }
  }

  @override
  void dispose() {
    print("DISPOSE FROM StoreBloc");
    _eventCont.close();
    _stateCont.close();
  }
}