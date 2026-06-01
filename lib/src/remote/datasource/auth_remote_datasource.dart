import 'package:dio/dio.dart';
import 'package:service_app/src/features/common/domain/usecase/sites_usecase.dart';
import 'package:service_app/src/features/home/domain/usecase/upcoming_amc_usecase.dart';
import 'package:service_app/src/features/login/domain/usecase/login_usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';
import 'package:service_app/src/remote/models/commissioning_work_model/commissioning_work_list_response.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';
import 'package:service_app/src/remote/models/profile_details_model/profile_details_model.dart';
import 'package:service_app/src/remote/models/sites_model/sites_response.dart';
import 'package:service_app/src/remote/models/technician_model/technician_response.dart';
import 'package:service_app/src/remote/models/upcoming_amc_model/upcoming_amc_response.dart';
import '../../configs/injector/injector.dart';
import '../../core/api/api_exception.dart';
import '../../core/api/api_helper.dart';
import '../../core/api/api_url.dart';
import '../../core/constants/error_message.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step1_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step1_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step2_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step2_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step3_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step3_usecase.dart';
import '../models/commissioning_report_step1_model/commissioning_report_step1_autofill_response.dart';
import '../models/commissioning_report_step1_model/commissioning_report_step1_response.dart';
import '../models/commissioning_report_step2_autofill_model/commissioning_report_step2_autofill_response.dart';
import '../models/commissioning_report_step2_autofill_model/commissioning_report_step2_response.dart';
import '../models/commissioning_report_step3_autofill_model/commissioning_report_step3_autofill_response.dart';

sealed class RemoteDataSource {

  Future<LoginResponse> login(LoginParams params);

  Future<ProfileDetailsResponse> profileDetails(String token);

  Future<CustomerResponse> customers(String token);

  Future<SiteResponse> sites(SitesParams params,String token);

  Future<TechnicianResponse> technician(String token);

  Future<CommissioningWorkListResponse> commissioningWorkList(String token);

  Future<UpcomingAmcVisitsResponse> upcomingAmc(UpcomingAmcParams params,String token);

  Future<CommissioningReportStep1AutoFillResponse> commissioningReportStep1Autofill(CommissioningStep1AutofillParams params,String token);

  Future<CommissioningStep1Response> commissioningReportStep1(CommissioningStep1Params params,String token);

  Future<CommissioningStep2Response> commissioningReportStep2(CommissioningStep2Params params,String token);

  Future<CommissioningReportStep2AutoFillResponse> commissioningReportStep2Autofill(CommissioningStep2AutofillParams params,String token);

  Future<CommissioningStep3Response> commissioningReportStep3(CommissioningStep3Params params,String token);

  Future<CommissioningStep3Response> commissioningReportStep3Autofill(CommissioningStep3AutofillParams params,String token);

  Future<void> logout();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiHelper _helper;

  /// Helper for normal API requests
  // final ApiHelper _superAdminHelper; /// Helper for super-admin or special API requests

  const RemoteDataSourceImpl(this._helper /* this._superAdminHelper*/);

  @override
  Future<LoginResponse> login(LoginParams params) async {
    try {

      var data = {
        "phone": params.phone,
        "password": params.password
      };

      final response = await _helper.execute(
          method: Method.post,
          url: ApiUrl.login,
          data: data
      );

      final respData = LoginResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
      // throw here i want to pass same exception which is send by catch();
    }
  }

  @override
  Future<ProfileDetailsResponse> profileDetails(String token) async {
    try {

      final response = await _helper.execute(
          method: Method.get,
          url: ApiUrl.profileDetails,
          options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = ProfileDetailsResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
      // throw here i want to pass same exception which is send by catch();
    }
  }

  @override
  Future<CustomerResponse> customers(String token) async {
    try {

      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.customerDropdown,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = CustomerResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
      // throw here i want to pass same exception which is send by catch();
    }
  }

  @override
  Future<SiteResponse> sites(SitesParams params,String token) async {
    try {

      final response = await _helper.execute(
        method: Method.get,
        url: "$ApiUrl.siteDropdown?customer_id=${params.customer_id}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = SiteResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
      // throw here i want to pass same exception which is send by catch();
    }
  }

  @override
  Future<TechnicianResponse> technician(String token) async {
    try {

      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.technicians,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = TechnicianResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
      // throw here i want to pass same exception which is send by catch();
    }
  }

  @override
  Future<CommissioningWorkListResponse> commissioningWorkList(String token) async {
    try {

      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.commissioningWork,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = CommissioningWorkListResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
      // throw here i want to pass same exception which is send by catch();
    }
  }

  @override
  Future<UpcomingAmcVisitsResponse> upcomingAmc(UpcomingAmcParams params,String token) async {
    try {

      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.upcomingAmcVisits,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = UpcomingAmcVisitsResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
      // throw here i want to pass same exception which is send by catch();
    }
  }

  @override
  Future<CommissioningReportStep1AutoFillResponse> commissioningReportStep1Autofill(CommissioningStep1AutofillParams params,String token) async {
    try {

      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.commissioningWorkReportStep1AutoFill}/${params.commissioning_report_id}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = CommissioningReportStep1AutoFillResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
      // throw here i want to pass same exception which is send by catch();
    }
  }

  @override
  Future<CommissioningStep1Response> commissioningReportStep1(CommissioningStep1Params params,String token) async {
    try {

      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.commissioningWorkReportStep1,
        data: {
          "commissioning_work_id": params.commissioningWorkId,
          "technician_ids": params.technicianIds,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = CommissioningStep1Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
      // throw here i want to pass same exception which is send by catch();
    }
  }

  @override
  Future<CommissioningStep2Response> commissioningReportStep2(CommissioningStep2Params params,String token) async {
    try {

      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.commissioningWorkReportStep2,
        data: {
          "id": params.id,
          "warranty_period_years": params.warrantyPeriodYears,
          "member_presents_customer_side": params.memberPresentsCustomerSide,
          "agenda": params.agenda,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = CommissioningStep2Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
      // throw here i want to pass same exception which is send by catch();
    }
  }

  @override
  Future<CommissioningReportStep2AutoFillResponse> commissioningReportStep2Autofill(CommissioningStep2AutofillParams params,String token) async {
    try {

      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.commissioningWorkReportStep2AutoFill}/${params.commissioning_report_id}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = CommissioningReportStep2AutoFillResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
      // throw here i want to pass same exception which is send by catch();
    }
  }

  @override
  Future<CommissioningStep3Response> commissioningReportStep3(CommissioningStep3Params params, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.commissioningWorkReportStep3,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "id": params.id,
          "is_technical_na": params.isTechnicalNa,
          "technical_details": params.isTechnicalNa ? {} : params.technicalDetails?.toJson() ?? {},
        },
      );
      final respData = CommissioningStep3Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
    }
  }

  @override
  Future<CommissioningStep3Response> commissioningReportStep3Autofill(CommissioningStep3AutofillParams params, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.commissioningWorkReportStep3AutoFill}/${params.id}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final respData = CommissioningStep3Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e; // rethrow as-is
      }
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }
}
