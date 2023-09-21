
import 'package:client/services/entities/filter_sort_stats_data.dart';
import 'package:client/services/entities/stats_data.dart';

import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';
import 'stats_states_events.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  Repo repo;
  FilterSortStatsData? fsStats;
  late StatsData sdata;

  DashboardBloc(this.repo) : super(DashboardLoadingState());

  @override
  void handleEvent(DashboardEvent event) async {
    if (event is DashboardLoadEvent) {
      emit(DashboardLoadingState());
      final data = await repo.getStats(fsStats: fsStats);
      fsStats ??= data['filter_sort_stats'];
      sdata = data['stats_data'];
      emit(DashboardLoadedState());
    }
  }
}