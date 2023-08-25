import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/l10n/localizations_context_ext.dart';
import 'package:client/services/models.dart';
import 'package:client/features/stats/stats_bloc.dart';
import 'package:client/features/stats/stats_states_events.dart';
import 'package:client/features/stats/widgets/dpp_filter/dpp_filter.dart';
import 'package:client/features/stats/widgets/chart_controls.dart';
import 'package:client/features/home/toggle_drawer_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';


import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';
import 'widgets/opp_filter/opp_filter.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  int dppColumnWidth = 60;

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print('_StatsPageState initialized');
    super.initState();
  }

  Future<void> onChangeDppFilter(BuildContext context) async {
    final bloc = BlocProvider.of<DashboardBloc>(context);

    final reload = await showDialog<bool>(
      context: context,
      builder: (context) => DishPerPeriodFilterDialog(fs: bloc.fsStats!)
    );

    if (reload != true) return;
    print('RELOAD RELOAD reload');
    bloc.add(DashboardLoadEvent());
  }

  Future<void> onChangeOppFilter(BuildContext context) async {
    final bloc = BlocProvider.of<DashboardBloc>(context);

    final reload = await showDialog<bool>(
      context: context,
      builder: (context) => OrdPerPeriodFilterDialog(fs: bloc.fsStats!)
    );

    if (reload != true) return;
    print('RELOAD RELOAD');
    bloc.add(DashboardLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    print('StatsPage built');
    return BlocProvider<DashboardBloc>(
      create: (_) => DashboardBloc(Provider.of<Repo>(context, listen: false))
        ..add(DashboardLoadEvent()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (BuildContext context, state) {
          final l = context.ll!;
          final bloc = context.readBloc<DashboardBloc>();
          if (state is DashboardLoadingState) {
            return Scaffold(
              appBar: AppBar(
                leading: const ToggleDrawerButton(),
              ),
              body: const Center(child: CircularProgressIndicator())
            );
          } else if (state is DashboardLoadedState) {
            return Scaffold(
              key: key,
              appBar: AppBar(
                leading: const ToggleDrawerButton(),
                title: Center(child: Text(l.stats))
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: buildOppFilter(context, bloc)
                    ),
                    Expanded(
                      child: buildDppFilter(context, bloc),
                    )
                  ],
                ),
              )
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget buildOppFilter(BuildContext context, DashboardBloc bloc) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChartControls(
          onInfoPressed: () { }, 
          onFilterPressed: () => onChangeOppFilter(context)
        ),
        Expanded(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              visibleMaximum: 8,
              visibleMinimum: 0  
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true
            ),
            
            series: <ChartSeries<OrdPerPeriod, String>>[
              ColumnSeries(
                dataSource: bloc.sdata.ordPerPeriod, 
                xValueMapper: (OrdPerPeriod opp, _) => opp.ordStartTime.toString().substring(0, 10), 
                yValueMapper: (OrdPerPeriod opp, _) => opp.count
              )
            ]
          ),
        ),
        Text(
          '${l.date}: ${bloc.fsStats!.dishFrom.toIso8601String().substring(0, 10)} - ${bloc.fsStats!.dishTo.toIso8601String().substring(0, 10)}, ${l.group}: ${l.grouping(bloc.fsStats!.group.toLowerCase())}',
          style: TextStyle(color: Colors.grey[600])
        )
      ],
    );
  }

  Widget buildDppFilter(BuildContext context, DashboardBloc bloc) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChartControls(
          onInfoPressed: () { }, 
          onFilterPressed: () => onChangeDppFilter(context)
        ),
        Expanded(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              visibleMaximum: 8,
              visibleMinimum: 0
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              // Templating the tooltip
              builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                return Text('${data.dishName}', style: const TextStyle(color: Colors.white));
              }
            ),
            series: <ChartSeries<DishPerPeriod, int>>[
                ColumnSeries<DishPerPeriod, int>(
                  dataSource: bloc.sdata.dishPerPeriod,
                  xValueMapper: (DishPerPeriod data, _) => data.dishId,
                  yValueMapper: (DishPerPeriod data, _) => data.count
                )
            ]
          )
        ),
        Text('${l.date}: ${bloc.fsStats!.dishFrom.toIso8601String().substring(0, 10)} - ${bloc.fsStats!.dishTo.toIso8601String().substring(0, 10)}', style: TextStyle(color: Colors.grey[600])),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < bloc.sdata.empWorked.length; i++) ...[
                  Text(bloc.sdata.empWorked[i].empName),
                  SfRangeSlider(
                    enableTooltip: true,
                    min: 0,
                    max: bloc.sdata.empWorked[i].hoursPerMonth,
                    values: SfRangeValues(0.0, bloc.sdata.empWorked[i].worked.toDouble()),
                    // interval: 20,
                    // showTicks: true,
                    showLabels: true,
                    onChanged: (SfRangeValues value) {
                      
                    },
                  ),
                ],
              ],
            )
          )
        )
      ],
    );
  }
}