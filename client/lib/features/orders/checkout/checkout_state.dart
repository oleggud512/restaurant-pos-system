import 'package:equatable/equatable.dart';

import '../../../services/entities/order.dart';

class CheckoutState extends Equatable {
  const CheckoutState({
    required this.order
  });

  final Order order;

  CheckoutState copyWith({
    Order? order,
  }) {
    return CheckoutState(
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [
    order
  ];
}