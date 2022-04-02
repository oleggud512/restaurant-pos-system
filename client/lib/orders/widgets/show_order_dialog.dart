import 'package:flutter/material.dart';

import '../../services/models.dart';


class OrderDialog extends StatelessWidget {
  OrderDialog({Key? key, required this.order}) : super(key: key);

  Order order;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400, 
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('заказ №' + order.ordId.toString() + ' ' + 
                  order.ordDate.toString().substring(0, 10) + '   ' + order.totalPrice.toString() + ' грн.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                ),
                Text('официант: ' + order.empName! + ' (${order.empId}) '),
                Text('заказано в: ${order.ordStartTime}'),
                Text("оплачено в: ${order.ordEndTime}, ${order.moneyFromCustomer} грн."),
                Text('сдача: ${order.change} ${order.isEnd ? "" : "(не оплачено)"}'),
                Text('состав: '),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < order.listOrders.length; i++) Text(order.listOrders[i].dish.dishName + ': ' + order.listOrders[i].count.toString() + " шт. " + order.listOrders[i].price.toString() + ' грн.')
                    ],
                  )
                ),
                Text('комментарий: '),
                Text(order.comm)
              ],
            ),
          ),
        )
      )
    );
  }
}