import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/notifications_model/notifications_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class GetNotificationsUseCase
    implements UseCase<NotificationsResponse, GetNotificationsParams> {
  final Repository _repository;

  const GetNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationsResponse>> call(
    GetNotificationsParams params,
  ) async {
    return await _repository.getNotifications(
      page: params.page,
      customerName: params.customerName,
      siteName: params.siteName,
      date: params.date,
    );
  }
}

class GetNotificationsParams extends Equatable {
  final int page;
  final String? customerName;
  final String? siteName;
  final String? date;

  const GetNotificationsParams({
    required this.page,
    this.customerName,
    this.siteName,
    this.date,
  });

  @override
  List<Object?> get props => [page, customerName, siteName, date];
}
