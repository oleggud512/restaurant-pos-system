import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/services/entities/order.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../utils/sizes.dart';



class OrderContainer extends StatelessWidget {
  const OrderContainer({
    Key? key, 
    required this.order, 
    required this.onTap,
    required this.onDelete,
    required this.onCheckout
  }) : super(key: key);

  final void Function() onTap;
  final void Function() onDelete;
  final void Function() onCheckout;
  final Order order;

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(p8),
          child: IntrinsicHeight(
            child: Row(
              children: [
                w4gap,
                Text(order.ordId.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const VerticalDivider(width: p24),
                Text(order.listOrders.map<String>((e) => e.dish.dishName).toList().join(', '),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
                const Spacer(),
                if (!order.isEnd) ...[FilledButton(
                  onPressed: onCheckout,
                  child: Text(l.pay),
                ), w8gap],
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
                w4gap
              ]
            ),
          ),
        ),
      )
    );
  }
}