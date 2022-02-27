import 'package:client/supplys/add_supply/add_supply.dart';
import 'package:flutter/material.dart';
import 'package:client/supplys/supplys_bloc.dart';
import 'package:client/supplys/supplys_states_events.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../bloc_provider.dart';
import '../services/models.dart';
import '../services/repo.dart';


class SupplysPage extends StatefulWidget {
  SupplysPage({Key? key}) : super(key: key);

  @override
  State<SupplysPage> createState() => _SupplysPageState();
}

class _SupplysPageState extends State<SupplysPage> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SupplysBloc>(context);
    return BlocProvider<SupplysBloc>(
      blocBuilder: () => SupplysBloc(Provider.of<Repo>(context)),
      blocDispose: (SupplysBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          
          return Scaffold(
            appBar: AppBar(title: const Center(
              child: Text("supplys")), 
              leading: BackButton(
                onPressed: () => Navigator.pop(context)
              )
            ),
            body: Container(
              padding: const EdgeInsets.all(10),
              child: StreamBuilder(
                stream: bloc.outState,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var state = snapshot.data;
                  if (state is SupplyLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SupplyLoadedState) {
                    return ListView(
                      children: [
                        for (int i = 0; i < bloc.supplys.length; i++) InkWell(
                          onTap: () {
                    
                          },
                          child: Text(
                            bloc.supplys[i].supplyId.toString() + " " + 
                            bloc.supplys[i].supplierName + " " + 
                            dateToString(bloc.supplys[i].supplyDate) + " " + 
                            bloc.supplys[i].summ.toString()
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => AddSupplyDialog()
                            );
                            bloc.inEvent.add(SupplyLoadEvent());
                          },
                          child: const Text("add supply")
                        )
                      ],
                    );
                  }
                  return const Center(child: Text("wrong"),);
                },
              ),
            ),
            endDrawer: SortFilterDrawer(), 
          );
        }
      )
    );  
  }
}

class SortFilterDrawer extends StatefulWidget {
  SortFilterDrawer({Key? key}) : super(key: key);

  @override
  State<SortFilterDrawer> createState() => _SortFilterDrawerState();
}

class _SortFilterDrawerState extends State<SortFilterDrawer> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SupplysBloc>(context);
    return Drawer(child: Container());
  }
}
