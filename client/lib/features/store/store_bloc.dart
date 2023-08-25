import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';
import '../../services/models.dart';
import 'store_states_events.dart';


class StoreBloc extends Bloc<StoreEvent, StoreState> {

  Repo repo;
  List<Supplier> suppliers = [];
  List<Grocery> groceries = [];

  Sorting grocSortNow = Sorting.desc;

  StoreBloc(this.repo) : super(StoreLoadingState());
  
  @override
  void handleEvent(StoreEvent event) async {
    switch (event) {

      case StoreLoadEvent():
        emit(StoreLoadingState());
        suppliers = await repo.getSuppliers();
        groceries = await repo.getGroceries();
        emit(StoreLoadedState(suppliers, groceries)); 
        break;

      case StoreReloadGroceriesEvent():
        emit(StoreGroceriesLoadingState());
        groceries = await repo.getGroceries(like: event.like);
        emit(StoreLoadedState(suppliers, groceries));
        break;
      
      case StoreSortGrocEvent():
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
        emit(StoreLoadedState(suppliers, groceries));
        break;
      default:
        break;
    }
  }
}