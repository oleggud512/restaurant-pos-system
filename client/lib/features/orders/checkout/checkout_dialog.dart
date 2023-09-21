import 'package:client/features/orders/checkout/checkout_bloc.dart';
import 'package:client/features/orders/checkout/checkout_event.dart';
import 'package:client/utils/dialog_widget.dart';
import 'package:client/utils/extensions/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.g.dart';
import '../../../services/entities/order.dart';
import '../../../services/repo.dart';
import '../../../utils/bloc_provider.dart';
import '../../../utils/sizes.dart';
import '../orders_bloc.dart';
import '../orders_states_events.dart';
import 'checkout_state.dart';

class CheckoutDialog extends StatefulWidget with DialogWidget<void> {
  const CheckoutDialog({super.key, required this.order});

  final Order order;

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => CheckoutBloc(context.read<Repo>(), widget.order),
      child: Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: p400,
          ),
          child: BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              final bloc = context.readBloc<CheckoutBloc>();
              return Padding(
                padding: const EdgeInsets.all(p24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onChanged: (newV) {
                        bloc.add(CheckoutAmountChangedEvent(newV.isEmpty
                            ? 0
                            : double.parse(newV))
                        );
                      }
                    ),
                    Text('${l.rest}: ${state.order.change}'),
                    FilledButton(
                      onPressed: () {
                        bloc.add(CheckoutCheckoutEvent(onSuccess: () {
                          if (mounted) Navigator.of(context).pop();
                        }));
                      },
                      child: Text('PAY'.hc),
                    )
                  ]
                )
              );
            }
          )
        )
      ),
    );
  }
}
