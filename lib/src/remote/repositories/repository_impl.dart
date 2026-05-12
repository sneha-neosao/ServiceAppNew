import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import 'package:service_app/src/features/login/domain/usecase/login_usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';
import '../../configs/injector/injector.dart';
import '../../core/api/api_exception.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/failure_converter.dart';
import '../datasource/auth_remote_datasource.dart';

/// Abstract Repository interface defining all data operations for the app

abstract class Repository {

  Future<Either<Failure, LoginResponse>> login(LoginParams params);

}

class AuthRepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const AuthRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginParams params) {
    return _networkInfo.check<LoginResponse>(
      connected: () async {
        try {

          final respData = await _remoteDataSource.login(params);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }

          // Save session directly
          await SessionManager.saveUserSession(respData);

          // Retrieve later
          final savedSession = await SessionManager.getUserSession();
          if (savedSession != null) {
            print(savedSession.technician.name);
            print(savedSession.dealer.name);
          }

          return Right(respData);

        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch(e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));// rethrow as-is
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

}
