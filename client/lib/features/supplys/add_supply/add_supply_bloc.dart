import 'package:client/services/entities/grocery/supply_grocery.dart';

import '../../../utils/bloc_provider.dart';
import '../../../services/repo.dart';
import 'add_supply_events_states.dart';

class AddSupplyBloc extends Bloc<AddSupplyEvent, AddSupplyState> {

  Repo repo;

  AddSupplyBloc(this.repo) : super(AddSupplyState(isLoading: true));

  @override
  void handleEvent(dynamic event) async {
    switch (event) {
      case AddSupplyLoadEvent():
        final suppliers = await repo.getSuppliers();
        emit(state.copyWith(
          isLoading: false,
          suppliers: suppliers
        ));
        break;
      
      case AddSupplySupplierSelectedEvent(
        supplier: final sup
      ):
        emit(state.copyWith(
          supplier: () => sup,
          supply: state.supply.copyWith(
            supplierId: () => sup?.supplierId
          )
        ));
        break;
      
      case AddSupplyNewCountEvent(
        groc: final groc, 
        newCount: final count
      ):
        final grocIndex = state.supply.groceries.indexOf(groc);
        final newGrocs = [...state.supply.groceries]
          ..[grocIndex] = groc.copyWith(grocCount: () => count);
        final newState = state.copyWith(
          supply: state.supply.copyWith(
            groceries: newGrocs
          )
        );
        // updateTotalSumm(newState);
        emit(newState);
        break;

      case AddSupplyAddGrocToSupply(
        grocery: final groc
      ):
        // if the grocery is already in the supply... break
        if (state.supply.groceries.where((g) => g.grocId == groc.grocId).toList().isNotEmpty) return;

        final newGrocs = [
          ...state.supply.groceries, 
          SupplyGrocery(
            grocId: groc.grocId, 
            grocName: groc.grocName,
            supGrocPrice: groc.supGrocPrice
          )
        ];
        emit(state.copyWith(
          supply: state.supply.copyWith(
            groceries: newGrocs
          )
        ));
        break;
      
      case AddSupplyRemoveGrocFromSupply(grocId: final id):
        emit(state.copyWith(
          supply: state.supply.copyWith(
            groceries: [...state.supply.groceries]
              ..removeWhere((g) => g.grocId == id)
          )
        ));
        break;
      default:
    }
  }

  // AddSupplyState updateTotalSumm(AddSupplyState state) {
  //   var summ = 0.0;
  //   for (var element in state.supply.groceries) {
  //     summ += element.supGrocPrice! * element.grocCount!;
  //   }
  //   return state.copyWith(
  //     supply: state.supply.copyWith(
  //       summ: summ
  //     )
  //   );
  // }

}