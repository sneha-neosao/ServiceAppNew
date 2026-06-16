import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/notifications_model/unread_count_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class GetUnreadNotificationCountUseCase
    implements UseCase<UnreadCountResponse, NoParams> {
  final Repository _repository;

  const GetUnreadNotificationCountUseCase(this._repository);

  @override
  Future<Either<Failure, UnreadCountResponse>> call(NoParams params) async {
    return await _repository.getUnreadNotificationCount();
  }
}
