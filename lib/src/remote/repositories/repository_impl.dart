import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/sites_usecase.dart';
import 'package:service_app/src/features/home/domain/usecase/upcoming_amc_usecase.dart';
import 'package:service_app/src/features/login/domain/usecase/login_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step1_autofill_usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';
import 'package:service_app/src/remote/models/commissioning_report_step1_model/commissioning_report_step1_response.dart';
import 'package:service_app/src/remote/models/commissioning_report_step2_autofill_model/commissioning_report_step2_response.dart';
import 'package:service_app/src/remote/models/commissioning_work_model/commissioning_work_list_response.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';
import 'package:service_app/src/remote/models/profile_details_model/profile_details_model.dart';
import 'package:service_app/src/remote/models/sites_model/sites_response.dart';
import 'package:service_app/src/remote/models/technician_model/technician_response.dart';
import 'package:service_app/src/remote/models/upcoming_amc_model/upcoming_amc_response.dart';
import '../../configs/injector/injector.dart';
import '../../core/api/api_exception.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/failure_converter.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step1_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step2_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step2_usecase.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/commissioning_report_step1_model/commissioning_report_step1_autofill_response.dart';
import '../models/commissioning_report_step2_autofill_model/commissioning_report_step2_autofill_response.dart';
import '../models/commissioning_report_step3_autofill_model/commissioning_report_step3_autofill_response.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step3_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step3_usecase.dart';

/// Abstract Repository interface defining all data operations for the app

abstract class Repository {

  Future<Either<Failure, LoginResponse>> login(LoginParams params);

  Future<Either<Failure, ProfileDetailsResponse>> profile_details(NoParams params);

  Future<Either<Failure, CustomerResponse>> customers(NoParams params);

  Future<Either<Failure, SiteResponse>> sites(SitesParams params);

  Future<Either<Failure, TechnicianResponse>> technician(NoParams params);

  Future<Either<Failure, CommissioningWorkListResponse>> commissioning_work_list(NoParams params);

  Future<Either<Failure, UpcomingAmcVisitsResponse>> upcoming_amc(UpcomingAmcParams params);

  Future<Either<Failure, CommissioningReportStep1AutoFillResponse>> commissioning_report_step1_autofill(CommissioningStep1AutofillParams params);

  Future<Either<Failure, CommissioningStep1Response>> commissioning_report_step1(CommissioningStep1Params params);

  Future<Either<Failure, CommissioningStep2Response>> commissioning_report_step2(CommissioningStep2Params params);

  Future<Either<Failure, CommissioningReportStep2AutoFillResponse>> commissioning_report_step2_autofill(CommissioningStep2AutofillParams params);

  Future<Either<Failure, CommissioningStep3Response>> commissioning_report_step3(CommissioningStep3Params params);

  Future<Either<Failure, CommissioningStep3Response>> commissioning_report_step3_autofill(CommissioningStep3AutofillParams params);

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

  @override
  Future<Either<Failure, CustomerResponse>> customers(NoParams params) {
    return _networkInfo.check<CustomerResponse>(
      connected: () async {
        try {

          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.customers(token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
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
  Future<Either<Failure, SiteResponse>> sites(SitesParams params) {
    return _networkInfo.check<SiteResponse>(
      connected: () async {
        try {

          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.sites(params,token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
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
  Future<Either<Failure, TechnicianResponse>> technician(NoParams params) {
    return _networkInfo.check<TechnicianResponse>(
      connected: () async {
        try {

          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.technician(token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
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
  Future<Either<Failure, CommissioningWorkListResponse>> commissioning_work_list(NoParams params) {
    return _networkInfo.check<CommissioningWorkListResponse>(
      connected: () async {
        try {

          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.commissioningWorkList(token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
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
  Future<Either<Failure, UpcomingAmcVisitsResponse>> upcoming_amc(UpcomingAmcParams params) {
    return _networkInfo.check<UpcomingAmcVisitsResponse>(
      connected: () async {
        try {

          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.upcomingAmc(params,token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
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
  Future<Either<Failure, CommissioningReportStep1AutoFillResponse>> commissioning_report_step1_autofill(CommissioningStep1AutofillParams params) {
    return _networkInfo.check<CommissioningReportStep1AutoFillResponse>(
      connected: () async {
        try {

          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.commissioningReportStep1Autofill(params,token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
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
  Future<Either<Failure, CommissioningStep1Response>> commissioning_report_step1(CommissioningStep1Params params) {
    return _networkInfo.check<CommissioningStep1Response>(
      connected: () async {
        try {

          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.commissioningReportStep1(params,token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
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
  Future<Either<Failure, CommissioningStep2Response>> commissioning_report_step2(CommissioningStep2Params params) {
    return _networkInfo.check<CommissioningStep2Response>(
      connected: () async {
        try {

          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.commissioningReportStep2(params,token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
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
  Future<Either<Failure, CommissioningReportStep2AutoFillResponse>> commissioning_report_step2_autofill(CommissioningStep2AutofillParams params) {
    return _networkInfo.check<CommissioningReportStep2AutoFillResponse>(
      connected: () async {
        try {

          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.commissioningReportStep2Autofill(params,token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
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
  Future<Either<Failure, CommissioningStep3Response>> commissioning_report_step3(CommissioningStep3Params params) {
    return _networkInfo.check<CommissioningStep3Response>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final respData = await _remoteDataSource.commissioningReportStep3(params, token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }
          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch(e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
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
  Future<Either<Failure, CommissioningStep3Response>> commissioning_report_step3_autofill(CommissioningStep3AutofillParams params) {
    return _networkInfo.check<CommissioningStep3Response>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final respData = await _remoteDataSource.commissioningReportStep3Autofill(params, token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }
          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch(e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
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
