import 'package:client/services/entities/grocery/grocery.dart';
import 'package:client/services/entities/grocery/mini_grocery.dart';

import '../../../utils/bloc_provider.dart';
import '../../../services/repo.dart';
import 'sup_states_events.dart';


class SupBloc extends Bloc<SupEvent, SupState> {

  Repo repo;

  SupBloc(this.repo, int supplierId, List<Grocery> groceries) 
    : super(SupState(
      isLoading: true, 
      supplierId: supplierId, 
      groceries: groceries
    ));
  
  @override
  void handleEvent(SupEvent event) async {
    switch (event) {

      case SupLoadEvent():
        emit(state.startLoading());
        final supplier = await repo.getSupplier(state.supplierId);
        emit(state.stopLoading().copyWith(supplier: supplier));
        break;
      
      case SupDeleteGroceryEvent():
        // TODO: (7) loading with delay
        final supplier = state.supplier!.copyWith(groceries: 
          [...state.supplier!.groceries]..removeWhere(
            (groc) => groc.grocId == event.grocId
          )
        );
        await repo.updateSupplier(supplier);
        emit(state.copyWith(supplier: supplier));
        break;
      
      case SupShowAddGroceryFormEvent(): // ElevatedButton
        emit(state.copyWith(isShowAddGrocForm: true));       // взаимозаменяемы
        break;
      case SupHideAddGroceryFormEvent(): // ElevatedButton
        emit(state.copyWith(
          grocToAdd: const MiniGrocery(), 
          isShowAddGrocForm: false
        ));
        break;
        
      case SupAddGroceryEvent():
        // TODO: (7) create show loading screen only with some delay
        // if the grocery that we are trying to add is already exist AND
        if (state.grocToAdd.grocId == null || state.grocToAdd.supGrocPrice == null) return;
        // is NOT supplied by the current supplier...
        if (state.supplier!.groceries.map((groc) => groc.grocId).contains(state.grocToAdd.grocId!)) return;

        // ... then we update it's price
        final groc = state.groceries.firstWhere((groc) => groc.grocId == state.grocToAdd.grocId)
          ..supGrocPrice = state.grocToAdd.supGrocPrice;
        final supplier = state.supplier!.copyWith(groceries: [...state.supplier!.groceries, groc]);

        await repo.updateSupplier(supplier);
        
        emit(state.copyWith(
          grocToAdd: const MiniGrocery(), 
          isShowAddGrocForm: false,
          supplier: supplier,
        ));
        break;
      
      case ToAddGrocIdChanged():
        emit(state.copyWith(
          grocToAdd: state.grocToAdd.copyWith(
            grocId: () => event.grocId,
          )
        ));
        break;
      case ToAddGrocCountChanged():
        emit(state.copyWith(
          grocToAdd: state.grocToAdd.copyWith(
            supGrocPrice: () => event.supGrocPrice
          )
        ));
        break;
      
      // case SupCommitEvent:
      //   _inState.add(SupLoadingState());
      //   await repo.updateSupplier(supplier);
      //   break;
      default:
    }
  }
}