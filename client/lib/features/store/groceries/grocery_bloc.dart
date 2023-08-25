
import 'package:client/services/repo.dart';

import '../../../utils/bloc_provider.dart';
import '../../../services/models.dart';
import 'grocery_states_events.dart';


class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {

  int id;
  Repo repo;
  bool isEdit = false;
  late Grocery grocery;

  GroceryBloc(this.repo, this.id) : super(GrocLoadingState());

  @override
  void handleEvent(GroceryEvent event) async {
    switch (event) {
      case GrocLoadEvent():
        emit(GrocLoadingState());
        grocery = await repo.getGrocery(id);
        emit(GrocLoadedState(grocery)); 
        break;
      case GrocEditEvent():
        isEdit = true;
        emit(GrocEditState(grocery));
        break;
      case GrocSaveEvent():
        emit(GrocLoadingState());
        await repo.updateGrocery(grocery);
        isEdit = false;
        emit(GrocLoadedState(grocery));
        break;
      case GrocMeasureChanged():
        grocery.grocMeasure = event.newMeasure;
        emit((isEdit) ? GrocEditState(grocery) : GrocLoadedState(grocery));
        break;
      case GrocNameChanged():
        grocery.grocName = event.newName;
        break;
      case GrocCountChanged():
        grocery.avaCount = event.newCount;
        break;
      default:
    }
  }
}