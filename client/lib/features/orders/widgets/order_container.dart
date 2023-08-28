import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/services/entities/order.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';



class OrderContainer extends StatelessWidget {
  const OrderContainer({
    Key? key, 
    required this.order, 
    required this.onTap,
    required this.onDelete,
    required this.onPay
  }) : super(key: key);

  final void Function() onTap;
  final void Function() onDelete;
  final void Function() onPay;
  final Order order;

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 25, 
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Constants.grey,
                  alignment: Alignment.center,
                  child: Text(order.ordId.toString())
                )
              ),
              Expanded(
                flex: 15,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(order.listOrders.map<String>((e) => e.dish.dishName).toList().join(', '), 
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ),
              if (!order.isEnd) Expanded(
                flex: 2,
                child: Padding(padding: const EdgeInsets.all(3), child: ElevatedButton(
                  onPressed: onPay,
                  child: Text(l.pay),
                ))
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: onDelete,
                  child: Container(
                    alignment: Alignment.center,
                    color: Constants.grey,
                    child: const Icon(Icons.delete, size: 24),
                  ),
                )
              )
            ]
          )
        ),
      )
    );
  }
}