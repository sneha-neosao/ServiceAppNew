import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/sites_usecase.dart';
import 'package:service_app/src/features/home/domain/usecase/upcoming_amc_usecase.dart';
import 'package:service_app/src/features/login/domain/usecase/login_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_work_update_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/assigned_service_calls_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/pending_service_calls_usecase.dart';
import 'package:service_app/src/remote/models/service_calls_model/assigned_service_calls_response.dart';
import 'package:service_app/src/remote/models/service_calls_model/pending_serbice_calls_response.dart';
import 'package:service_app/src/remote/models/active_technicians_service_calls_model/active_technicians_service_calls_reponse.dart';
import 'package:service_app/src/remote/models/assign_technician_service_call_model/assign_technician_service_calls_response.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';
import 'package:service_app/src/remote/models/commissioning_report_step1_model/commissioning_report_step1_response.dart';
import 'package:service_app/src/remote/models/commissioning_report_step2_autofill_model/commissioning_report_step2_response.dart';
import 'package:service_app/src/remote/models/commissioning_work_model/commissioning_work_list_response.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';
import 'package:service_app/src/remote/models/profile_details_model/profile_details_model.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step1_autofill_usecase.dart';
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
import '../models/commissioning_report_step4_autofill_model/commissioning_report_step4_autofill_response.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step4_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step4_usecase.dart';
import '../models/commissioning_report_step5_autofill_model/commissioning_report_step5_autofill_response.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step5_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step5_usecase.dart';
import '../models/commissioning_report_step6_autofill_model/commissioning_report_step6_autofill_response.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step6_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step6_usecase.dart';
import '../../features/my_commissioning/domain/usecase/assigned_technician_representative_usecase.dart';
import '../models/assigned_technician_representative_model/assigned_technician_representative_response.dart';
import '../models/commissioning_work_create_model/commissioning_work_create_response.dart';
import '../models/commissioning_report_history_model/commissioning_report_history_response.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_create_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_report_history_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_report_details_usecase.dart';
import '../models/commissioning_report_history_model/commissioning_report_details_response.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_update_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_details_usecase.dart';
import '../models/commissioning_work_model/commissioning_work_details_response.dart';

import '../../features/service_calls/domain/usecase/assign_technician_service_calls_usecase.dart';

/// Abstract Repository interface defining all data operations for the app

abstract class Repository {
  Future<Either<Failure, LoginResponse>> login(LoginParams params);

  Future<Either<Failure, ProfileDetailsResponse>> profile_details(
    NoParams params,
  );

  Future<Either<Failure, CustomerResponse>> customers(NoParams params);

  Future<Either<Failure, SiteResponse>> sites(SitesParams params);

  Future<Either<Failure, TechnicianResponse>> technician(NoParams params);

  Future<Either<Failure, CommissioningWorkListResponse>>
  commissioning_work_list(NoParams params);

  Future<Either<Failure, UpcomingAmcVisitsResponse>> upcoming_amc(
    UpcomingAmcParams params,
  );

  Future<Either<Failure, CommissioningReportStep1AutoFillResponse>>
  commissioning_report_step1_autofill(CommissioningStep1AutofillParams params);

  Future<Either<Failure, CommissioningStep1Response>>
  commissioning_report_step1(CommissioningStep1Params params);

  Future<Either<Failure, CommissioningStep2Response>>
  commissioning_report_step2(CommissioningStep2Params params);

  Future<Either<Failure, CommissioningReportStep2AutoFillResponse>>
  commissioning_report_step2_autofill(CommissioningStep2AutofillParams params);

  Future<Either<Failure, CommissioningStep3Response>>
  commissioning_report_step3(CommissioningStep3Params params);

  Future<Either<Failure, CommissioningStep3Response>>
  commissioning_report_step3_autofill(CommissioningStep3AutofillParams params);

  Future<Either<Failure, CommissioningReportStep4AutoFillResponse>>
  commissioning_report_step4_autofill(CommissioningStep4AutofillParams params);

  Future<Either<Failure, CommissioningReportStep4AutoFillResponse>>
  commissioning_report_step4(CommissioningStep4Params params);

  Future<Either<Failure, CommissioningReportStep5AutoFillResponse>>
  commissioning_report_step5_autofill(CommissioningStep5AutofillParams params);

  Future<Either<Failure, CommissioningReportStep5AutoFillResponse>>
  commissioning_report_step5(CommissioningStep5Params params);

  Future<Either<Failure, CommissioningReportStep6AutoFillResponse>>
  commissioning_report_step6_autofill(CommissioningStep6AutofillParams params);

  Future<Either<Failure, CommissioningReportStep6AutoFillResponse>>
  commissioning_report_step6(CommissioningStep6Params params);

  Future<Either<Failure, AssignedTechnicianResponse>>
  assigned_technician_representative(
    AssignedTechnicianRepresentativeParams params,
  );

  Future<Either<Failure, CommissioningWorkCreateResponse>>
  commissioningWorkCreate(CommissioningWorkCreateParams params);

  Future<Either<Failure, CommissioningWorkCreateResponse>>
  commissioningWorkUpdate(CommissioningWorkUpdateParams params, String workId);

  Future<Either<Failure, String>>
  commissioningWorkDelete(String workId);

  Future<Either<Failure, CommissioningReportHistoryResponse>>
  commissioningReportHistory(CommissioningReportHistoryParams params);

  Future<Either<Failure, CommissioningDetailsResponse>>
  commissioningReportDetails(String reportId);

  Future<Either<Failure, CommissioningWorkDetailsResponse>>
  commissioningWorkDetails(String workId);

  Future<Either<Failure, AssignedServiceCallsResponse>> assignedServiceCalls(
      AssignedServiceCallsParams params);

  Future<Either<Failure, PendingServiceCallsResponse>> pendingServiceCalls(
      PendingServiceCallsParams params);

  Future<Either<Failure, ActiveTechniciansServiceCallsResponse>> activeTechniciansServiceCalls(NoParams params);

  Future<Either<Failure, AssignTechnicianServiceCallsResponse>> assignTechnicianServiceCalls(
      AssignTechnicianServiceCallsParams params);
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
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
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
  Future<Either<Failure, ProfileDetailsResponse>> profile_details(
    NoParams params,
  ) {
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
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
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
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
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

          final respData = await _remoteDataSource.sites(params, token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
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
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
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
  Future<Either<Failure, CommissioningWorkListResponse>>
  commissioning_work_list(NoParams params) {
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
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
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
  Future<Either<Failure, UpcomingAmcVisitsResponse>> upcoming_amc(
    UpcomingAmcParams params,
  ) {
    return _networkInfo.check<UpcomingAmcVisitsResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.upcomingAmc(params, token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
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
  Future<Either<Failure, CommissioningReportStep1AutoFillResponse>>
  commissioning_report_step1_autofill(CommissioningStep1AutofillParams params) {
    return _networkInfo.check<CommissioningReportStep1AutoFillResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource
              .commissioningReportStep1Autofill(params, token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
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
  Future<Either<Failure, CommissioningStep1Response>>
  commissioning_report_step1(CommissioningStep1Params params) {
    return _networkInfo.check<CommissioningStep1Response>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.commissioningReportStep1(
            params,
            token,
          );

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
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
  Future<Either<Failure, CommissioningStep2Response>>
  commissioning_report_step2(CommissioningStep2Params params) {
    return _networkInfo.check<CommissioningStep2Response>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource.commissioningReportStep2(
            params,
            token,
          );

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
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
  Future<Either<Failure, CommissioningReportStep2AutoFillResponse>>
  commissioning_report_step2_autofill(CommissioningStep2AutofillParams params) {
    return _networkInfo.check<CommissioningReportStep2AutoFillResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";

          final respData = await _remoteDataSource
              .commissioningReportStep2Autofill(params, token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
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
  Future<Either<Failure, CommissioningStep3Response>>
  commissioning_report_step3(CommissioningStep3Params params) {
    return _networkInfo.check<CommissioningStep3Response>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final respData = await _remoteDataSource.commissioningReportStep3(
            params,
            token,
          );

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }
          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
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
  Future<Either<Failure, CommissioningStep3Response>>
  commissioning_report_step3_autofill(CommissioningStep3AutofillParams params) {
    return _networkInfo.check<CommissioningStep3Response>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final respData = await _remoteDataSource
              .commissioningReportStep3Autofill(params, token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message!));
          }
          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
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
  Future<Either<Failure, CommissioningReportStep4AutoFillResponse>>
  commissioning_report_step4_autofill(CommissioningStep4AutofillParams params) {
    return _networkInfo.check<CommissioningReportStep4AutoFillResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final respData = await _remoteDataSource
              .commissioningReportStep4Autofill(params.id, token);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message));
          }
          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
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
  Future<Either<Failure, CommissioningReportStep4AutoFillResponse>>
  commissioning_report_step4(CommissioningStep4Params params) {
    return _networkInfo.check<CommissioningReportStep4AutoFillResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final respData = await _remoteDataSource.commissioningReportStep4(
            params,
            token,
          );

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message));
          }
          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
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
  Future<Either<Failure, CommissioningReportStep5AutoFillResponse>>
  commissioning_report_step5_autofill(CommissioningStep5AutofillParams params) {
    return _networkInfo.check<CommissioningReportStep5AutoFillResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource
              .commissioningReportStep5Autofill(params.id);

          if (respData.status != 200) {
            return Left(ServerFailure(respData.message));
          } else {
            return Right(respData);
          }
        } catch (e) {
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
  Future<Either<Failure, CommissioningReportStep5AutoFillResponse>>
  commissioning_report_step5(CommissioningStep5Params params) {
    return _networkInfo.check<CommissioningReportStep5AutoFillResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.commissioningReportStep5(
            params,
          );

          if (respData.status != 200) {
            return Left(ServerFailure(respData.message));
          } else {
            return Right(respData);
          }
        } catch (e) {
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
  Future<Either<Failure, CommissioningReportStep6AutoFillResponse>>
  commissioning_report_step6_autofill(CommissioningStep6AutofillParams params) {
    return _networkInfo.check<CommissioningReportStep6AutoFillResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource
              .commissioningReportStep6Autofill(params.id);

          if (respData.status != 200) {
            return Left(ServerFailure(respData.message));
          } else {
            return Right(respData);
          }
        } catch (e) {
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
  Future<Either<Failure, CommissioningReportStep6AutoFillResponse>>
  commissioning_report_step6(CommissioningStep6Params params) {
    return _networkInfo.check<CommissioningReportStep6AutoFillResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.commissioningReportStep6(
            params,
          );

          if (respData.status != 200) {
            return Left(ServerFailure(respData.message));
          } else {
            return Right(respData);
          }
        } catch (e) {
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
  Future<Either<Failure, AssignedTechnicianResponse>>
  assigned_technician_representative(
    AssignedTechnicianRepresentativeParams params,
  ) {
    return _networkInfo.check<AssignedTechnicianResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource
              .assignedTechnicianRepresentative(params.id);

          if (respData.status != 200) {
            return Left(ServerFailure(respData.message));
          } else {
            return Right(respData);
          }
        } catch (e) {
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
  Future<Either<Failure, CommissioningWorkCreateResponse>>
  commissioningWorkCreate(CommissioningWorkCreateParams params) {
    return _networkInfo.check<CommissioningWorkCreateResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final respData = await _remoteDataSource.commissioningWorkCreate(
            params,
            token,
          );

          if (respData.status != 200 && respData.status != 201) {
            return Left(ServerFailure(respData.message));
          } else {
            return Right(respData);
          }
        } catch (e) {
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
  Future<Either<Failure, CommissioningWorkCreateResponse>>
      commissioningWorkUpdate(CommissioningWorkUpdateParams params, String workId) {
    return _networkInfo.check<CommissioningWorkCreateResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final respData = await _remoteDataSource.commissioningWorkUpdate(
            params,
            workId,
            token,
          );

          if (respData.status != 200 && respData.status != 201) {
            return Left(ServerFailure(respData.message));
          } else {
            return Right(respData);
          }
        } catch (e) {
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
  Future<Either<Failure, String>>
      commissioningWorkDelete(String workId) {
    return _networkInfo.check<String>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final message = await _remoteDataSource.commissioningWorkDelete(
            workId,
            token,
          );
          return Right(message);
        } catch (e) {
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
  Future<Either<Failure, CommissioningReportHistoryResponse>>
      commissioningReportHistory(CommissioningReportHistoryParams params) {
    return _networkInfo.check<CommissioningReportHistoryResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final respData = await _remoteDataSource.commissioningReportHistory(
            params,
            token,
          );

          if (respData.status != 200 && respData.status != 201) {
            return Left(ServerFailure(respData.message));
          } else {
            return Right(respData);
          }
        } catch (e) {
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
  Future<Either<Failure, CommissioningDetailsResponse>>
      commissioningReportDetails(String reportId) {
    return _networkInfo.check<CommissioningDetailsResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final respData = await _remoteDataSource.commissioningReportDetails(
            reportId,
            token,
          );

          if (respData.status != 200 && respData.status != 201) {
            return Left(ServerFailure(respData.message ?? "Error"));
          } else {
            return Right(respData);
          }
        } catch (e) {
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
  Future<Either<Failure, CommissioningWorkDetailsResponse>>
      commissioningWorkDetails(String workId) {
    return _networkInfo.check<CommissioningWorkDetailsResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final respData = await _remoteDataSource.commissioningWorkDetails(
            workId,
            token,
          );

          if (respData.status != 200 && respData.status != 201) {
            return Left(ServerFailure(respData.message));
          } else {
            return Right(respData);
          }
        } catch (e) {
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
  Future<Either<Failure, AssignedServiceCallsResponse>> assignedServiceCalls(
      AssignedServiceCallsParams params) {
    return _networkInfo.check<AssignedServiceCallsResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final assignedServiceCallsResponse =
              await _remoteDataSource.assignedServiceCalls(
            params,
            token,
          );
          return Right(assignedServiceCallsResponse);
        } catch (e) {
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
  Future<Either<Failure, PendingServiceCallsResponse>> pendingServiceCalls(
      PendingServiceCallsParams params) {
    return _networkInfo.check<PendingServiceCallsResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final pendingServiceCallsResponse =
              await _remoteDataSource.pendingServiceCalls(
            params,
            token,
          );
          return Right(pendingServiceCallsResponse);
        } catch (e) {
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
  Future<Either<Failure, ActiveTechniciansServiceCallsResponse>> activeTechniciansServiceCalls(NoParams params) {
    return _networkInfo.check<ActiveTechniciansServiceCallsResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final response = await _remoteDataSource.activeTechniciansServiceCalls(token);
          
          if (response.status != 200) {
            return Left(CredentialFailure(response.message));
          }
          
          return Right(response);
        } catch (e) {
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
  Future<Either<Failure, AssignTechnicianServiceCallsResponse>> assignTechnicianServiceCalls(
      AssignTechnicianServiceCallsParams params) {
    return _networkInfo.check<AssignTechnicianServiceCallsResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          final response = await _remoteDataSource.assignTechnicianServiceCalls(params, token);
          
          if (response.status != 200) {
            return Left(CredentialFailure(response.message));
          }
          
          return Right(response);
        } catch (e) {
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
