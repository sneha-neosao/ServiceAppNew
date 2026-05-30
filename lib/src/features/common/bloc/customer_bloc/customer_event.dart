part of 'customer_bloc.dart';

/// Event for authentication related information.

sealed class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

/// Event for Customer.

class CustomerGetEvent extends CustomerEvent {

  const CustomerGetEvent();

  @override
  List<Object?> get props => [];
}
