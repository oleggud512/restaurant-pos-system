import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../../bloc_provider.dart';
import '../../services/models.dart';
import '../../services/repo.dart';
import 'add_supply_events_states.dart';

class AddSupplyBloc extends Bloc {

  StreamController<AddSupplyEvent> _eventCont = BehaviorSubject<AddSupplyEvent>();
  Stream<AddSupplyEvent> get _outEvent => _eventCont.stream;
  Sink<AddSupplyEvent> get inEvent => _eventCont.sink;

  StreamController<AddSupplyState> _stateCont = BehaviorSubject<AddSupplyState>();
  Stream<AddSupplyState> get outState => _stateCont.stream;
  Sink<AddSupplyState> get _inState => _stateCont.sink;

  Repo repo;
  Supplier? supplier;
  late List<Supplier> suppliers;
  Supply supply = Supply.empty();

  double summ = 0;

  AddSupplyBloc(this.repo) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(AddSupplyLoadEvent());
  }

  _handleEvent(dynamic event) async {
    switch (event.runtimeType) {
      case AddSupplyLoadEvent:
        _inState.add(AddSupplyLoadingState());
        suppliers = await repo.getSuppliers();
        _inState.add(AddSupplyLoadedState(suppliers));
        break;
      
      case AddSupplySupplierSelectedEvent:
        supply = Supply.empty();
        
        supplier = event.supplier;
        if (event.supplier != null) {
          supply.supplierId = event.supplier.supplierId;
        } else {
          supply.supplierId = null;
        }
        _inState.add(AddSupplyLoadedState(suppliers));
        break;
      
      case AddSupplyNewCount:
        supply.groceries[event.index].grocCount = event.newCount;
        _countSumm();
        _inState.add(AddSupplyLoadedState(suppliers));
        break;

      case AddSupplyAddGrocToSupply:
        if (supply.groceries.where((element) => element.grocId == event.grocery.grocId).toList().isEmpty) {
          supply.groceries.add(
            SupplyGrocery.empty()
              ..grocId = event.grocery.grocId
              ..grocName = event.grocery.grocName
              ..supGrocPrice = event.grocery.supGrocPrice
          );
        }
        _inState.add(AddSupplyLoadedState(suppliers));
        break;
      
      case AddSupplyRemoveGrocFromSupply:
        supply.groceries.removeWhere((element) => element.grocId == event.grocId);
        _inState.add(AddSupplyLoadedState(suppliers));
        break;
      default:
    }
  }

  _countSumm() {
    summ = 0;
    for (var element in supply.groceries) {summ += element.supGrocPrice! * element.grocCount!;}
  }

  @override 
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }

}