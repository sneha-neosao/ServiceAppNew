import 'package:equatable/equatable.dart';

abstract class FcmRegisterEvent extends Equatable {
  const FcmRegisterEvent();

  @override
  List<Object> get props => [];
}

class FcmRegisterTriggerEvent extends FcmRegisterEvent {
  final String fcmToken;

  const FcmRegisterTriggerEvent({required this.fcmToken});

  @override
  List<Object> get props => [fcmToken];
}
