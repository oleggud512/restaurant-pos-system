import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/features/supplys/show_supply/show_supply.dart';
import 'package:flutter/material.dart';
import 'package:client/features/supplys/supplys_bloc.dart';
import 'package:client/features/supplys/supplys_states_events.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../utils/bloc_provider.dart';
import '../../services/models.dart';
import '../../services/repo.dart';
import '../home/toggle_drawer_button.dart';
import 'filter_sort_drawer/filter_sort_drawer.dart';
import 'widgets/supply_container.dart';


class SupplysPage extends StatefulWidget {
  const SupplysPage({Key? key}) : super(key: key);

  @override
  State<SupplysPage> createState() => _SupplysPageState();
}

class _SupplysPageState extends State<SupplysPage> {
  late AppLocalizations l;
  DataView view = DataView.grid;

  GlobalKey<ScaffoldState> scgl = GlobalKey<ScaffoldState>();

  Future<void> onSupplyContainerTap(BuildContext context, Supply supply) async {
    bool? reload = await showDialog(
      context: context,
      builder: (context) {
        return ShowSupplyDialog(supply: supply);
      }
    );
    if (reload != true && !mounted) return;
    context.readBloc<SupplysBloc>().add(SupplyLoadEvent());
  }


  @override
  Widget build(BuildContext context) {
    l = AppLocalizations.of(context)!;
    return BlocProvider<SupplysBloc>(
      create: (context) => SupplysBloc(context.read<Repo>())
        ..add(SupplyLoadEvent()),
      child: BlocBuilder<SupplysBloc, SupplyState>(
        builder: (context, state) {
          final bloc = context.readBloc<SupplysBloc>();
          return switch (state) {
            SupplyLoadingState() => Scaffold(
              appBar: AppBar(leading: const ToggleDrawerButton(),),
              body: const Center(child: CircularProgressIndicator())
            ),
            SupplyLoadedState() => Scaffold(
              key: scgl,
              appBar: buildAppBar(),
              body: Container(
                padding: const EdgeInsets.all(10),
                child: switch ((view, 
                  children: bloc.supplys.map<Widget>((sup) => SupplyContainer(
                    supply: sup, 
                    view: view,
                    onTap: () => onSupplyContainerTap(context, sup)
                  )).toList()..add(
                    AddSupplyContainer(bloc: bloc, view: view)
                  )
                )) {
                  (DataView.list, children: final ch) => ListView(
                    children: ch,
                  ),
                  (DataView.grid, children: final ch) => ResponsiveGridList(
                    desiredItemWidth: 250,
                    children: ch,
                  )
                },
              ),
              endDrawer: const SortFilterDrawer(), 
            ),
            _ => Container()
          };
        }
      )
    );  
  }


  AppBar buildAppBar() {
    return AppBar(
      title: Center(child: Text(l.supply('2'))), 
      leading: const ToggleDrawerButton(),
      actions: [
        switch (view) {
          DataView.list => IconButton(
            icon: const Icon(Icons.view_module_rounded),
            onPressed: () {
              setState(() {
                view = DataView.grid;
              });
            }
          ),
          DataView.grid => IconButton(
            icon: const Icon(Icons.view_headline_rounded),
            onPressed: () {
              setState(() {
                view = DataView.list;
              });
            }
          )
        },
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          onPressed: () => scgl.currentState!.openEndDrawer(),
        ),
      ]
    );
  }
}

