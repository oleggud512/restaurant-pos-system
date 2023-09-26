import 'package:client/features/orders/checkout/checkout_events.dart';
import 'package:client/services/entities/order.dart';
import 'package:client/utils/bloc_provider.dart';

import '../../../services/repo.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc(this.repo, this.order) : super(CheckoutState(order: order));

  final Repo repo;
  final Order order;

  @override
  Future<void> handleEvent(CheckoutEvent event) async {
    switch (event) {
      case CheckoutAmountChangedEvent(:final amount):
        emit(state.copyWith(
          order: order.copyWith(
            moneyFromCustomer: () => amount,
          )
        ));
        break;
      case CheckoutCheckoutEvent(:final onSuccess):
        await repo.payOrder(state.order);
        onSuccess();
        break;
    }
  }

}