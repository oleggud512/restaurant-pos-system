import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/models.dart';
import '../../services/repo.dart';


class PayOrderDialog extends StatefulWidget {
  PayOrderDialog({Key? key, required this.order}) : super(key: key);

  Order order;

  @override
  State<PayOrderDialog> createState() => _PayOrderDialogState();
}

class _PayOrderDialogState extends State<PayOrderDialog> {
  @override
  Widget build(BuildContext context) {
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
              Text('сдача: ' + widget.order.change.toString()),
              ElevatedButton(
                child: Text('pay'),
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