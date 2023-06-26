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

  final StreamController<StoreEvent> _eventCont = BehaviorSubject<StoreEvent>();
  Stream<StoreEvent> get _outEvent => _eventCont.stream; // ивенты слушает блок
  Sink<StoreEvent> get inEvent => _eventCont.sink;  // ивенты приходят В блок из вне


  final StreamController<StoreState> _stateCont = BehaviorSubject<StoreState>();
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

  Sorting grocSortNow = Sorting.desc;

  StoreBloc(this.repo) {
    _eventCont.stream.listen((event) {_handleEvent(event);});
    inEvent.add(StoreLoadEvent());
  }
  
  _handleEvent(dynamic event) async {
    switch (event.runtimeType) {

      case StoreLoadEvent:
        _inState.add(StoreLoadingState());
        suppliers = await repo.getSuppliers();
        groceries = await repo.getGroceries();
        _inState.add(StoreLoadedState(suppliers, groceries)); 
        break;

      case StoreReloadGroceriesEvent:
        _inState.add(StoreGroceriesLoadingState());
        groceries = await repo.getGroceries(like: event.like);
        _inState.add(StoreLoadedState(suppliers, groceries));
        break;
      
      case StoreSortGrocEvent:
        grocSortNow = event.direction;
        groceries.sort((a, b) {
          if (grocSortNow == Sorting.desc) {
            if (a.avaCount == b.avaCount) {
              return 0;
            } else if (a.avaCount > b.avaCount) {
              return -1;
            } else if (a.avaCount < b.avaCount) {
              return 1;
            }
          } else if (grocSortNow == Sorting.asc) {
            if (a.avaCount == b.avaCount) {
              return 0;
            } else if (a.avaCount < b.avaCount) {
              return -1;
            } else if (a.avaCount > b.avaCount) {
              return 1;
            }
          } return 0; // never occures
        });
        _inState.add(StoreLoadedState(suppliers, groceries));
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _eventCont.close();
    _stateCont.close();
  }
}