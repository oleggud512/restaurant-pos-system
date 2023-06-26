import 'package:client/l10nn/app_localizations.dart';
import 'package:client/supplys/show_supply/show_supply.dart';
import 'package:flutter/material.dart';
import 'package:client/supplys/supplys_bloc.dart';
import 'package:client/supplys/supplys_states_events.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../bloc_provider.dart';
import '../services/models.dart';
import '../services/repo.dart';
import '../widgets/navigation_drawer.dart';
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
  @override
  Widget build(BuildContext context) {
    l = AppLocalizations.of(context)!;
    return BlocProvider<SupplysBloc>(
      blocBuilder: () => SupplysBloc(Provider.of<Repo>(context)),
      blocDispose: (SupplysBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          var bloc = BlocProvider.of<SupplysBloc>(context);
          return StreamBuilder(
            stream: bloc.outState,
            builder: (context, snapshot) {
              var state = snapshot.data;
              if (state is SupplyLoadingState) {
                return Scaffold(
                  appBar: AppBar(leading: const BackButton()),
                  body: const Center(child: CircularProgressIndicator())
                );
              } else if (state is SupplyLoadedState) {
                return Scaffold(
                  key: scgl,
                  drawer: const MyNavigationDrawer(),
                  appBar: buildAppBar(),
                  body: Container(
                    padding: const EdgeInsets.all(10),
                    child: (view == DataView.list) ? ListView(
                      children: [
                        for (int i = 0; i < bloc.supplys.length; i++) SupplyContainer(
                          supply: bloc.supplys[i], 
                          view: DataView.list,
                          onTap: () async {
                            bool reload = await showDialog(
                              context: context,
                              builder: (context) {
                                return ShowSupplyDialog(supply: bloc.supplys[i]);
                              }
                            );
                            if (reload) {
                              bloc.inEvent.add(SupplyLoadEvent());
                            }
                          }
                          
                        ),
                        AddSupplyContainer(bloc: bloc, view: DataView.list)
                      ],
                    ) : ResponsiveGridList(
                      desiredItemWidth: 250,
                      children: [
                        for (int i = 0; i < bloc.supplys.length; i++) SupplyContainer(
                          supply: bloc.supplys[i],
                          view: DataView.grid,
                          onTap: () async {
                            bool? reload = await showDialog(
                              context: context,
                              builder: (context) {
                                return ShowSupplyDialog(supply: bloc.supplys[i]);
                              }
                            );
                            if (reload != null && reload == true) {
                              bloc.inEvent.add(SupplyLoadEvent());
                            }
                          }
                        ),
                        AddSupplyContainer(bloc: bloc, view: DataView.grid)
                      ],
                    ),
                  ),
                  endDrawer: const SortFilterDrawer(), 
                );
              } return Container();
            }
          );
        }
      )
    );  
  }


  AppBar buildAppBar() {
    return AppBar(
      title: Center(child: Text(l.supply('2'))), 
      leading: IconButton(
        onPressed: () => scgl.currentState!.openDrawer(),
        icon: const Icon(Icons.menu)
      ),
      actions: [ 
        (view == DataView.list) ? IconButton(
          icon: const Icon(Icons.view_module_rounded),
          onPressed: () {
            setState(() {
              view = DataView.grid;
            });
          }
        ) : IconButton(
          icon: const Icon(Icons.view_headline_rounded),
          onPressed: () {
            setState(() {
              view = DataView.list;
            });
          }
        ),
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          onPressed: () {
            scgl.currentState!.openEndDrawer();
          },
        ),
      ]
    
    );
  }
}

