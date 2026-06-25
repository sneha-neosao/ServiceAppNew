import 'package:equatable/equatable.dart';

abstract class CustomerAmcVisitsEvent extends Equatable {
  const CustomerAmcVisitsEvent();

  @override
  List<Object?> get props => [];
}

class GetCustomerAmcVisitsEvent extends CustomerAmcVisitsEvent {
  final String customerId;
  final int page;
  final int pageSize;

  const GetCustomerAmcVisitsEvent({
    required this.customerId,
    this.page = 1,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [customerId, page, pageSize];
}
