import 'package:equatable/equatable.dart';

sealed class CheckoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CheckoutCheckoutEvent extends CheckoutEvent {
  CheckoutCheckoutEvent({required this.onSuccess});
  final void Function() onSuccess;

  @override
  List<Object?> get props => [
    onSuccess,
  ];
}

final class CheckoutAmountChangedEvent extends CheckoutEvent {
  CheckoutAmountChangedEvent(this.amount);
  final double amount;

  @override
  List<Object?> get props => [
    amount,
  ];
}