part of 'customer_bloc.dart';

/// Event for authentication related information.

sealed class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

/// Event for Customer.

class CustomerGetEvent extends CustomerEvent {
  final int page;
  final int pageSize;
  final String search;

  const CustomerGetEvent({
    this.page = 1,
    this.pageSize = 100,
    this.search = '',
  });

  @override
  List<Object?> get props => [page, pageSize, search];
}
