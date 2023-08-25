
import '../../../utils/bloc_provider.dart';
import '../../../services/models.dart';
import '../../../services/repo.dart';
import 'add_supply_events_states.dart';

class AddSupplyBloc extends Bloc<AddSupplyEvent, AddSupplyState> {

  Repo repo;
  Supplier? supplier;
  late List<Supplier> suppliers;
  Supply supply = Supply.empty();

  AddSupplyBloc(this.repo) : super(AddSupplyLoadingState());

  @override
  void handleEvent(dynamic event) async {
    switch (event) {
      case AddSupplyLoadEvent():
        suppliers = await repo.getSuppliers();
        emit(AddSupplyLoadedState(suppliers));
        break;
      
      case AddSupplySupplierSelectedEvent():
        supply = Supply.empty();
        supplier = event.supplier;
        supply.supplierId = event.supplier?.supplierId;
        emit(AddSupplyLoadedState(suppliers));
        break;
      
      case AddSupplyNewCount():
        supply.groceries[event.index].grocCount = event.newCount;
        _countSumm();
        emit(AddSupplyLoadedState(suppliers));
        break;

      case AddSupplyAddGrocToSupply():
        if (supply.groceries.where((element) => element.grocId == event.grocery.grocId).toList().isEmpty) {
          supply.groceries.add(
            SupplyGrocery.empty()
              ..grocId = event.grocery.grocId
              ..grocName = event.grocery.grocName
              ..supGrocPrice = event.grocery.supGrocPrice
          );
        }
        emit(AddSupplyLoadedState(suppliers));
        break;
      
      case AddSupplyRemoveGrocFromSupply():
        supply.groceries.removeWhere((element) => element.grocId == event.grocId);
        emit(AddSupplyLoadedState(suppliers));
        break;
      default:
    }
  }

  _countSumm() {
    supply.summ = 0;
    for (var element in supply.groceries) {supply.summ += element.supGrocPrice! * element.grocCount!;}
  }

}