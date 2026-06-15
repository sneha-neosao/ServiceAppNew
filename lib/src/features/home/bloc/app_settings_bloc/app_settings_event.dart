import 'package:equatable/equatable.dart';

abstract class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();

  @override
  List<Object> get props => [];
}

class GetAppSettingsEvent extends AppSettingsEvent {
  const GetAppSettingsEvent();
}
