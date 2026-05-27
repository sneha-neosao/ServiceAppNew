import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/features/login/domain/usecase/login_usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';
import 'package:service_app/src/remote/models/profile_details_model/profile_details_model.dart';
import '../../configs/injector/injector.dart';
import '../../core/api/api_exception.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/failure_converter.dart';
import '../datasource/auth_remote_datasource.dart';

/// Abstract Repository interface defining all data operations for the app

abstract class Repository {

  Future<Either<Failure, LoginResponse>> login(LoginParams params);

  Future<Either<Failure, ProfileDetailsResponse>> profile_details(NoParams params);

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

          // Save full session object
          await SessionManager.saveUserSession(respData);

          // Save tokens to their dedicated keys so ApiInterceptor can read them
          if (respData.accessToken != null) {
            await SessionManager.saveSessionId(respData.accessToken!);
          }
          if (respData.refreshToken != null) {
            await SessionManager.saveRefreshToken(respData.refreshToken!);
          }

          // Retrieve later
          final savedSession = await SessionManager.getUserSession();
          if (savedSession != null) {
            print(savedSession.technician?.name);
            print(savedSession.dealer?.name);
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

  @override
  Future<Either<Failure, ProfileDetailsResponse>> profile_details(NoParams params) {
    return _networkInfo.check<ProfileDetailsResponse>(
      connected: () async {
        try {

          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.profileDetails(token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }

          // Save session directly
          // await SessionManager.saveUserSession(respData);
          //
          // // Retrieve later
          // final savedSession = await SessionManager.getUserSession();
          // if (savedSession != null) {
          //   print(savedSession.technician?.name);
          //   print(savedSession.dealer?.name);
          // }

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
