part of 'customer_bloc.dart';

sealed class CustomerState extends Equatable {
  const CustomerState();
  @override
  List<Object?> get props => [];
}

class CustomerInitialState extends CustomerState {}

/// States like loading, success and failure representing customers fetching.

class CustomerLoadingState extends CustomerState {}

class CustomerSuccessState extends CustomerState {
  final CustomerResponse data;

  const CustomerSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CustomerFailureState extends CustomerState {
  final String message;

  const CustomerFailureState(this.message);

  @override
  List<Object?> get props => [message];
}