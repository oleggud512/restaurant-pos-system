import 'package:client/stats.dart/stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:syncfusion_flutter_charts/sparkcharts.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:charts_flutter/flutter.dart';

import '../bloc_provider.dart';
import '../services/repo.dart';


class StatsPage extends StatefulWidget {
  StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatsBloc>(
      blocBuilder: () => StatsBloc(Provider.of<Repo>(context, listen: false)),
      blocDispose: (StatsBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          var bloc = BlocProvider.of<StatsBloc>(context);
          return Scaffold(
            appBar: AppBar(),
            // body: BarChart(
              
            // )
          );
        },
      ),
    );
  }
}