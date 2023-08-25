import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/models.dart';
import '../../../services/repo.dart';


class PayOrderDialog extends StatefulWidget {
  const PayOrderDialog({Key? key, required this.order}) : super(key: key);

  final Order order;

  @override
  State<PayOrderDialog> createState() => _PayOrderDialogState();
}

class _PayOrderDialogState extends State<PayOrderDialog> {
  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return Dialog(
      child: SizedBox(
        width: 250,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                onChanged: (newVal) {
                  setState(() {
                    widget.order.moneyFromCustomer = double.parse(newVal.isEmpty ? '0.0' : newVal);
                  });
                }
              ),
              Text('${l.rest}: ${widget.order.change}'),
              ElevatedButton(
                child: Text(l.pay),
                onPressed: () async {
                  if (widget.order.payable) {
                    await Provider.of<Repo>(context, listen: false).payOrder(widget.order);
                    Navigator.pop(context);
                  }
                }
              )
            ]
          )
        )
      )
    );
  }
}