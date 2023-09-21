import 'dart:ffi';
import 'dart:io';

import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/features/menu/add_dish/prime_cost_details/prime_cost_details_dialog.dart';
import 'package:client/features/menu/widgets/text_editor.dart';
import 'package:client/l10n/localizations_context_ext.dart';
import 'package:client/services/entities/dish_group.dart';
import 'package:client/utils/extensions/string.dart';
import 'package:client/utils/sizes.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../services/entities/dish.dart';
import '../../../services/entities/grocery/dish_grocery.dart';
import '../../../utils/bloc_provider.dart';
import '../../../services/repo.dart';
import '../../../utils/constants.dart';
import '../../../utils/logger.dart';
import 'add_dish_bloc.dart';
import 'add_dish_events.dart';
import 'add_dish_page_mode.dart';
import 'add_dish_state.dart';


class EditDishRouteArgs extends Equatable {
  final Dish dish;

  const EditDishRouteArgs({required this.dish});

  @override
  List<Object?> get props => [
    dish
  ];
}


class AddDishPage extends StatefulWidget {
  const AddDishPage({Key? key, this.mode = AddDishPageMode.add, this.dishToEdit}) : super(key: key);

  final AddDishPageMode mode;
  final Dish? dishToEdit;

  @override
  State<AddDishPage> createState() => _AddDishPageState();
}

class _AddDishPageState extends State<AddDishPage> {
  late AppLocalizations l;


  Future<void> chooseImage(AddDishBloc bloc) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) { return; }
    File file = File(result.files.single.path!);
    bloc.add(AddDishUpdateDishPhotoEvent(file));
  }


  void deleteImage(AddDishBloc bloc) {
    bloc.add(AddDishDeleteDishPhotoEvent());
  }

  onSubmit(BuildContext context, AddDishBloc bloc) async {
    if (!bloc.state.dish.isSaveable) return;
    bloc.add(AddDishSubmitEvent(
      onSuccess: () {
        if (mounted) Navigator.pop(context);
      }
    ));
  }


  @override
  Widget build(BuildContext context) {
    l = context.ll!;
    return BlocProvider<AddDishBloc>(
      create: (_) => AddDishBloc(context.read<Repo>(),
        mode: widget.mode,
        dish: widget.dishToEdit
      )..add(AddDishLoadEvent()),
      child: BlocBuilder<AddDishBloc, AddDishState>(
        builder: (context, state) {
          final bloc = context.readBloc<AddDishBloc>();
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(state.dish.dishName.isEmpty 
                ? 'New dish'.hc 
                : state.dish.dishName
              ),
            ),
            body: buildLayout(bloc, state),
            bottomNavigationBar: buildBottomBar(context, bloc, state)
          );
        }
      ),
    );
  }

  // display prime cost and submit button
  Widget buildBottomBar(BuildContext context, AddDishBloc bloc, AddDishState state) {
    return BottomAppBar(
      child: Row(
        children: [
          TextButton(
            child: Text('Prime cost: ${state.primeCostData.total}'),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return PrimeCostDetailsDialog(dish: state.dish);
                }
              );
            },
          ),
          const Spacer(),
          FilledButton(
            onPressed: () => onSubmit(context, bloc),
            child: Text(state.isAddDish
                ? 'ADD DISH'
                : 'SAVE DISH',
            ),
          ),
        ]
      )
    );
  }

  Widget buildLayout(AddDishBloc bloc, AddDishState state) {
    return Row(
      children: [
        Expanded(
          child: buildFirstColumn(bloc, state)
          // child: Container(color: Colors.red)
        ),
        w8gap,
        Expanded(
          child: buildSecondColumn(bloc, state)
          // child: Container(color: Colors.red)
        ),
        w8gap,
        Expanded(
          child: buildThirdColumn(bloc, state)
          // child: Container(color: Colors.red)
        ),
      ]
    );
  }

  Widget buildDishPhoto(AddDishBloc bloc, AddDishState state) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: p184,
          ),
          child: state.dishPhoto != null
              ? Image.file(state.dishPhoto!)
              : Image.asset(Constants.dishPlaceholderAsset),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.white.withOpacity(0.3),
              onTap: () => chooseImage(bloc)
            ),
          )
        ),
        if (state.dishPhoto != null) Positioned(
          bottom: p8,
          right: p8,
          child: FloatingActionButton.small(
              onPressed: () => deleteImage(bloc),
              child: Icon(Icons.close, color: Theme.of(context).colorScheme.error)
          ),
        )
      ],
    );
  }

  /// dish image, dish name, dish price, dish prime cost
  Widget buildFirstColumn(AddDishBloc bloc, AddDishState state) {
    return ListView(
      controller: ScrollController(),
      padding: const EdgeInsets.all(p8),
      children: [
        buildDishPhoto(bloc, state),
        h16gap,
        TextFormField(
          initialValue: state.dish.dishName,
          decoration: InputDecoration(
            helperText: l.dish_name,
          ),
          onChanged: (String newVal) {
            bloc.add(AddDishNameChangedEvent(newVal));
          }
        ),
        h8gap,
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: state.dish.dishGrId,
                items: [
                  DropdownMenuItem(value: 0, child: Text('No group'.hc)),
                  ...state.dishGroups.map((gr) => DropdownMenuItem<int>(
                    value: gr.groupId,
                    child: Text(gr.groupName)
                  )).toList()
                ],
                onChanged: (v) => bloc.add(AddDishGroupChangedEvent(v!)),
                decoration: InputDecoration(
                  helperText: 'Group'.hc
                ),
              ),
            ),
            w8gap,
            SizedBox(
              width: p80,
              child: TextFormField(
                initialValue: state.dish.dishPrice.toString(),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                decoration: InputDecoration(
                  helperText: l.price,
                ),
                onChanged: (String newVal) {
                  bloc.add(AddDishPriceChangedEvent(newVal));
                }
              ),
            )
          ],
        ),
      ]
    );
  }

  /// build list of currently selected dish groceries.
  /// you can remove grocery from the list or change it's count
  Widget buildSecondColumn(AddDishBloc bloc, AddDishState state) {
    return ListView(
      children: [
        ...state.dish.dishGroceries
            .map((groc) => buildMenuGrocery(groc, bloc))
            .toList()
      ],
    );
  }

  Widget buildRemoveButton({required VoidCallback onTap}) {
    const radius = BorderRadius.all(Radius.circular(p8));
    return SizedBox(
      height: p24,
      width: p24,
      child: Material(
        color: Theme.of(context).primaryColor,
        elevation: 1,
        borderRadius: radius,
        child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Icon(Icons.close,
                size: p16,
                color: Theme.of(context).colorScheme.errorContainer
            )
        ),
      ),
    );
  }

  Widget buildMenuGrocery(DishGrocery groc, AddDishBloc bloc) {
    return Row(
      children: [
        buildRemoveButton(
            onTap: () {
              bloc.add(AddDishRemoveDishGroceryEvent(groc.grocId));
            }
        ),
        Expanded(
            flex: 3,
            child: Center(child: Text(groc.grocName))
        ),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: p56,
            ),
            padding: const EdgeInsets.all(p8),
            child: TextFormField(
              initialValue: groc.grocCount.toString(),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
              ],
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: p8
                ),
                labelText: l.measure_short('gram'),
              ),
              onChanged: (newVal) {
                bloc.add(AddDishDishGrocCountChangedEvent(groc.grocId, newVal));
              },
            ),
          ),
        )
      ],
    );
  }

  // description, available groceries
  Widget buildThirdColumn(AddDishBloc bloc, AddDishState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: p8, right: p8, top: p8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: l.name,
              border: const OutlineInputBorder()
            ),
            onChanged: (newVal) {
              bloc.add(AddDishFindGroceryEvent(newVal)); // поиск / фильтрация
            }
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: state.groceries?.map((groc) => InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: Text(groc.grocName)
                  ),
                  onTap: () {
                    bloc.add(AddDishAddGroceryEvent(groc));
                  }
                )).toList() ?? [],
              )
            ),
          ),
          Expanded(
            child: TextEditor(
              text: state.dish.dishDescr, 
              isEdit: true, 
              onChanged: (newVal) => bloc.add(AddDishDishDescriptionChangedEvent(newVal)),
            )
          ),
        ],
      ),
    );
  }

}
