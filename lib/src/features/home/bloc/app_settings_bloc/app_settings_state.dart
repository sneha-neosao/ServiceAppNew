import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/auth_model/app_settings_response.dart';

abstract class AppSettingsState extends Equatable {
  const AppSettingsState();

  @override
  List<Object> get props => [];
}

class AppSettingsInitial extends AppSettingsState {}

class AppSettingsLoading extends AppSettingsState {}

class AppSettingsSuccess extends AppSettingsState {
  final AppSettingsResponse data;

  const AppSettingsSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class AppSettingsFailure extends AppSettingsState {
  final String message;

  const AppSettingsFailure(this.message);

  @override
  List<Object> get props => [message];
}
