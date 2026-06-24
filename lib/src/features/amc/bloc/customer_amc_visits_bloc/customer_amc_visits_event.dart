import 'package:equatable/equatable.dart';

abstract class CustomerAmcVisitsEvent extends Equatable {
  const CustomerAmcVisitsEvent();

  @override
  List<Object?> get props => [];
}

class GetCustomerAmcVisitsEvent extends CustomerAmcVisitsEvent {
  final String customerId;

  const GetCustomerAmcVisitsEvent(this.customerId);

  @override
  List<Object?> get props => [customerId];
}
