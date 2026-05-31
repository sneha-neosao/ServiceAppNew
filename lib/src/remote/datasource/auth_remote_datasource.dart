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

sealed class RemoteDataSource {

  Future<LoginResponse> login(LoginParams params);

  Future<ProfileDetailsResponse> profileDetails(String token);

  Future<CustomerResponse> customers(String token);

  Future<SiteResponse> sites(SitesParams params,String token);

  Future<TechnicianResponse> technician(String token);

  Future<CommissioningWorkListResponse> commissioningWorkList(String token);

  Future<UpcomingAmcVisitsResponse> upcomingAmc(UpcomingAmcParams params,String token);

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
