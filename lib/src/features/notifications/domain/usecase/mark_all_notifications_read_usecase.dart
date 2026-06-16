import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/notifications_model/mark_all_read_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class MarkAllNotificationsReadUseCase
    implements UseCase<MarkAllReadResponse, NoParams> {
  final Repository _repository;

  const MarkAllNotificationsReadUseCase(this._repository);

  @override
  Future<Either<Failure, MarkAllReadResponse>> call(NoParams params) async {
    return await _repository.markAllNotificationsRead();
  }
}
