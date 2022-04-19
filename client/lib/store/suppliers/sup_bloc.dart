import '../../bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import '../../services/models.dart';
import '../../services/repo.dart';
import 'sup_states_events.dart';
import 'dart:async';


class SupBloc extends Bloc {

  StreamController<SupEvent> _eventCont = BehaviorSubject<SupEvent>();
  Stream<SupEvent> get _outEvent => _eventCont.stream;
  Sink<SupEvent> get inEvent => _eventCont.sink;

  StreamController<SupState> _stateCont = BehaviorSubject<SupState>();
  Stream<SupState> get outState => _stateCont.stream;
  Sink<SupState> get _inState => _stateCont.sink;

  Repo repo;
  int supplierId;
  late Supplier supplier;
  bool showAddGrocForm = false;
  List<Grocery> groceries;

  MiniGroc toAddGroc = MiniGroc.empty();

  SupBloc(this.repo, this.supplierId, this.groceries) {
    _outEvent.listen((event) {_handleEvent(event);});
    inEvent.add(SupLoadEvent());
  }
  
  void _handleEvent(dynamic event) async {
    switch (event.runtimeType) {

      case SupLoadEvent:
        _inState.add(SupLoadingState());
        supplier = await repo.getSupplier(supplierId);
        _inState.add(SupLoadedState());
        break;
      
      case SupDeleteGroceryEvent:
        _inState.add(SupLoadingState());
        supplier.groceries!.removeWhere((element) => element.grocId == event.grocId);
        await repo.updateSupplier(supplier);
        _inState.add(SupLoadedState());
        break;
      
      case SupShowAddGroceryFormEvent: // ElevatedButton
        showAddGrocForm = true;
        _inState.add(SupLoadedState());       // в3аимозаменяемы
        break;
      case SupHideAddGroceryFormEvent: // ElevatedButton
        showAddGrocForm = false;
        toAddGroc = MiniGroc.empty();
        _inState.add(SupLoadedState());
        break;
        
      case SupAddGroceryEvent:
        _inState.add(SupLoadingState());
        if (toAddGroc.grocId != null && toAddGroc.supGrocPrice != null && 
              !supplier.groceries!.map((e) => e.grocId).contains(toAddGroc.grocId)) {
          var groc = groceries.firstWhere((element) => element.grocId == toAddGroc.grocId)
            ..supGrocPrice = toAddGroc.supGrocPrice;
          supplier.groceries!.add(groc);
          await repo.updateSupplier(supplier);
          // print("YYYYEEEEEESSSSWS");
          toAddGroc = MiniGroc.empty();
          showAddGrocForm = false;
        }
        
        _inState.add(SupLoadedState());
        break;
      
      case ToAddGrocIdChanged:
        toAddGroc.grocId = event.grocId;
        _inState.add(SupLoadedState());
        break;
      case ToAddGrocCountChanged:
        toAddGroc.supGrocPrice = event.supGrocPrice;
        _inState.add(SupLoadedState());
        break;
      
      // case SupCommitEvent:
      //   _inState.add(SupLoadingState());
      //   await repo.updateSupplier(supplier);
      //   break;
      default:
    }
  }

  @override
  void dispose() {
    _eventCont.close();
    _stateCont.close();
  }
}