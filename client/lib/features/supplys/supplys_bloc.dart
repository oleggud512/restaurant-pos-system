
import 'package:client/services/entities/filter_sort_supplys_data.dart';
import 'package:client/services/entities/supply.dart';
import 'package:client/utils/logger.dart';

import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';
import 'supplys_states_events.dart';

class SupplysBloc extends Bloc<SupplyEvent, SupplyState> {

  FilterSortSupplysData? fsd;
  late List<Supply> supplys;
  Repo repo;

  SupplysBloc(this.repo) : super(SupplyLoadingState());

  @override
  void handleEvent(SupplyEvent event) async {
    switch (event) {
      case SupplyLoadEvent():
        emit(SupplyLoadingState());
        if (fsd == null || (fsd!.fPriceFrom <= fsd!.fPriceTo 
            && fsd!.fDateFrom.compareTo(fsd!.fDateTo) <= 0)) {
          fsd ??= await repo.getFilterSortData();
          supplys = await repo.getSupplys(fsd: fsd);
        }
        emit(SupplyLoadedState());
        break;
      case SupplySortCollumnChangedEvent():
        fsd?.sortCollumn = event.sortCollumn;
        emit(SupplyLoadedState());
        break;
      case SupplySortDirectionChangedEvent():
        fsd?.sortDirection = event.sortDirection;
        emit(SupplyLoadedState());
        break;
      case SupplyFromPriceChangedEvent():
        fsd?.fPriceFrom = (event.fromPrice.isNotEmpty)?double.parse(event.fromPrice):0.0;
        break;
      case SupplyToPriceChangedEvent():
        fsd?.fPriceTo = (event.toPrice.isNotEmpty)?double.parse(event.toPrice):0.0;
        break;
      case SupplyFromDateChangedEvent():
        fsd?.fDateFrom = event.fromDate;
        emit(SupplyLoadedState());
        break;
      case SupplyToDateChangedEvent():
        fsd?.fDateTo = event.toDate;
        emit(SupplyLoadedState());
        break;
      default:
    }
  }
}