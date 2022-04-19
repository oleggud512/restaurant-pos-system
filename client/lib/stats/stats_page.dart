import 'package:client/l10nn/app_localizations.dart';
import 'package:client/services/models.dart';
import 'package:client/stats/stats_bloc.dart';
import 'package:client/stats/stats_states_events.dart';
import 'package:client/stats/widgets/dpp_filter/dpp_filter.dart';
import 'package:client/stats/widgets/info_filter.dart';
import 'package:client/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';


import '../bloc_provider.dart';
import '../services/repo.dart';
import 'widgets/opp_filter/opp_filter.dart';


class StatsPage extends StatefulWidget {
  StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  int dppColumnWidth = 60;

  late TooltipBehavior dppTooltipBh;

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    dppTooltipBh = TooltipBehavior(
      enable: true,
      // Templating the tooltip
      builder: (dynamic data, dynamic point, dynamic series,
      int pointIndex, int seriesIndex) {
        return Text('${data.dishName}', style: const TextStyle(color: Colors.white));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatsBloc>(
      blocBuilder: () => StatsBloc(Provider.of<Repo>(context, listen: false)),
      blocDispose: (StatsBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          AppLocalizations l = AppLocalizations.of(context)!;
          var bloc = BlocProvider.of<StatsBloc>(context);
          return StreamBuilder(
            stream: bloc.outState,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var state = snapshot.data;
              if (state is StatsLoadingState) {
                return Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator())
                );
              } else if (state is StatsLoadedState) {
                return Scaffold(
                  key: key,
                  drawer: NavigationDrawer(),
                  appBar: AppBar(
                    title: Center(child: Text(l.stats))
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InfoFilter(
                                onInfo: () {

                                }, 
                                onFilter: () async {
                                  bool? reload = await showDialog(
                                    context: context,
                                    builder: (context) => OrdPerPeriodFilterDialog(fs: bloc.fsStats!)
                                  );
                                  if (!(reload == false || reload == null)) {
                                    bloc.inEvent.add(StatsLoadEvent());
                                  }
                                }
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
                          )
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InfoFilter(
                                onInfo: () {

                                }, 
                                onFilter: () async {
                                  bool? reload = await showDialog(
                                    context: context,
                                    builder: (context) => DishPerPeriodFilterDialog(fs: bloc.fsStats!)
                                  );
                                  if (!(reload == false || reload == null)) {
                                    bloc.inEvent.add(StatsLoadEvent());
                                  }
                                }
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
                                  tooltipBehavior: dppTooltipBh,
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
                          ),
                        )
                      ],
                    ),
                  )
                );
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}