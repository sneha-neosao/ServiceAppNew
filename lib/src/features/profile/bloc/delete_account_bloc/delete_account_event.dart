import 'package:equatable/equatable.dart';

abstract class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object> get props => [];
}

class DeleteAccountSubmittedEvent extends DeleteAccountEvent {
  const DeleteAccountSubmittedEvent();
}
