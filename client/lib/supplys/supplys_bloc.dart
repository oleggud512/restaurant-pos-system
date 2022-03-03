import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../bloc_provider.dart';
import '../services/models.dart';
import '../services/repo.dart';
import 'supplys_states_events.dart';

class SupplysBloc extends Bloc {

  StreamController<SupplyEvent> _eventCont = BehaviorSubject<SupplyEvent>();
  Stream<SupplyEvent> get _outEvent => _eventCont.stream;
  Sink<SupplyEvent> get inEvent => _eventCont.sink;

  StreamController<SupplyState> _stateCont = BehaviorSubject<SupplyState>();
  Stream<SupplyState> get outState => _stateCont.stream;
  Sink<SupplyState> get _inState => _stateCont.sink;

  FilterSortData? fsd;
  late List<Supply> supplys;
  Repo repo;

  SupplysBloc(this.repo) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(SupplyLoadEvent());
  }

  _handleEvent(dynamic event) async {
    switch (event.runtimeType) {
      case SupplyLoadEvent:
        _inState.add(SupplyLoadingState());
        if (fsd == null || (fsd!.fPriceFrom <= fsd!.fPriceTo 
            && fsd!.fDateFrom.compareTo(fsd!.fDateTo) <= 0)) {
          fsd ??= await repo.getFilterSortData();
          supplys = await repo.getSupplys(fsd: fsd);
        }
        _inState.add(SupplyLoadedState());
        break;
      case SupplySortCollumnChangedEvent:
        fsd?.sortCollumn = event.sortCollumn;
        _inState.add(SupplyLoadedState());
        break;
      case SupplySortDirectionChangedEvent:
        fsd?.sortDirection = event.sortDirection;
        _inState.add(SupplyLoadedState());
        break;
      case SupplyFromPriceChangedEvent:
        fsd?.fPriceFrom = (event.fromPrice.isNotEmpty)?double.parse(event.fromPrice):0.0;
        break;
      case SupplyToPriceChangedEvent:
        fsd?.fPriceTo = (event.toPrice.isNotEmpty)?double.parse(event.toPrice):0.0;
        break;
      case SupplyFromDateChangedEvent:
        fsd?.fDateFrom = event.fromDate;
        _inState.add(SupplyLoadedState());
        break;
      case SupplyToDateChangedEvent:
        fsd?.fDateTo = event.toDate;
        _inState.add(SupplyLoadedState());
        break;
      default:
    }
  }

  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}