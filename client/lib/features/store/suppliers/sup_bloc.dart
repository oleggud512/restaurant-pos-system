import '../../../utils/bloc_provider.dart';
import '../../../services/models.dart';
import '../../../services/repo.dart';
import 'sup_states_events.dart';


class SupBloc extends Bloc<SupEvent, SupState> {

  Repo repo;
  int supplierId;
  late Supplier supplier;
  bool showAddGrocForm = false;
  List<Grocery> groceries;

  MiniGroc toAddGroc = MiniGroc.empty();

  SupBloc(this.repo, this.supplierId, this.groceries) : super(SupLoadingState());
  
  @override
  void handleEvent(SupEvent event) async {
    switch (event) {

      case SupLoadEvent():
        emit(SupLoadingState());
        supplier = await repo.getSupplier(supplierId);
        emit(SupLoadedState());
        break;
      
      case SupDeleteGroceryEvent():
        emit(SupLoadingState());
        supplier.groceries!.removeWhere((element) => element.grocId == event.grocId);
        await repo.updateSupplier(supplier);
        emit(SupLoadedState());
        break;
      
      case SupShowAddGroceryFormEvent(): // ElevatedButton
        showAddGrocForm = true;
        emit(SupLoadedState());       // в3аимозаменяемы
        break;
      case SupHideAddGroceryFormEvent(): // ElevatedButton
        showAddGrocForm = false;
        toAddGroc = MiniGroc.empty();
        emit(SupLoadedState());
        break;
        
      case SupAddGroceryEvent():
        emit(SupLoadingState());
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
        
        emit(SupLoadedState());
        break;
      
      case ToAddGrocIdChanged():
        toAddGroc.grocId = event.grocId;
        emit(SupLoadedState());
        break;
      case ToAddGrocCountChanged():
        toAddGroc.supGrocPrice = event.supGrocPrice;
        emit(SupLoadedState());
        break;
      
      // case SupCommitEvent:
      //   _inState.add(SupLoadingState());
      //   await repo.updateSupplier(supplier);
      //   break;
      default:
    }
  }
}