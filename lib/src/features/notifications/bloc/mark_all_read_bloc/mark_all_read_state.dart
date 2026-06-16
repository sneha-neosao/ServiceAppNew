part of 'mark_all_read_bloc.dart';

abstract class MarkAllReadState extends Equatable {
  const MarkAllReadState();

  @override
  List<Object?> get props => [];
}

class MarkAllReadInitial extends MarkAllReadState {}

class MarkAllReadLoading extends MarkAllReadState {}

class MarkAllReadSuccess extends MarkAllReadState {
  final MarkAllReadResponse response;

  const MarkAllReadSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class MarkAllReadError extends MarkAllReadState {
  final String message;

  const MarkAllReadError({required this.message});

  @override
  List<Object?> get props => [message];
}
