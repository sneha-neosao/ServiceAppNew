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
import 'package:service_app/src/remote/models/service_calls_model/assigned_service_calls_response.dart';
import 'package:service_app/src/remote/models/service_calls_model/pending_serbice_calls_response.dart';
import 'package:service_app/src/remote/models/active_technicians_service_calls_model/active_technicians_service_calls_reponse.dart';
import 'package:service_app/src/remote/models/assign_technician_service_call_model/assign_technician_service_calls_response.dart';
import 'package:service_app/src/remote/models/close_over_call_model/close_over_call_response.dart';
import 'package:service_app/src/remote/models/servicecall_report_step1_model/servicecall_report_step1_response.dart';
import 'package:service_app/src/remote/models/servicecall_report_step2_model/servicecall_report_step2_response.dart';
import 'package:service_app/src/remote/models/servicecall_report_step3_model/servicecall_report_step3_response.dart';
import 'package:service_app/src/remote/models/servicecall_report_step4_model/servicecall_report_step4_response.dart' hide SavedDescription;
import 'package:service_app/src/remote/models/servicecall_report_step5_model/servicecall_report_step5_response.dart' hide SavedChecklist;
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step1_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step2_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step3_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/assigned_service_calls_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/pending_service_calls_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/assign_technician_service_calls_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/close_over_call_usecase.dart';
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
import '../models/commissioning_report_step4_autofill_model/commissioning_report_step4_autofill_response.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step4_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step4_usecase.dart';
import '../models/commissioning_report_step5_autofill_model/commissioning_report_step5_autofill_response.dart'
    hide SavedDescription;
import '../../features/my_commissioning/domain/usecase/commissioning_step5_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step6_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step6_autofill_usecase.dart';
import '../models/commissioning_report_step6_autofill_model/commissioning_report_step6_autofill_response.dart';
import '../../features/my_commissioning/domain/usecase/assigned_technician_representative_usecase.dart';
import '../models/assigned_technician_representative_model/assigned_technician_representative_response.dart';
import '../models/commissioning_work_create_model/commissioning_work_create_response.dart';
import '../models/commissioning_report_history_model/commissioning_report_history_response.dart';
import '../models/commissioning_report_history_model/commissioning_report_details_response.dart';
import '../models/commissioning_work_model/commissioning_work_details_response.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_create_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_update_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_report_history_usecase.dart';

sealed class RemoteDataSource {
  Future<LoginResponse> login(LoginParams params);

  Future<ProfileDetailsResponse> profileDetails(String token);

  Future<CustomerResponse> customers(String token);

  Future<SiteResponse> sites(SitesParams params, String token);

  Future<TechnicianResponse> technician(String token);

  Future<CommissioningWorkListResponse> commissioningWorkList(String token);

  Future<UpcomingAmcVisitsResponse> upcomingAmc(
    UpcomingAmcParams params,
    String token,
  );

  Future<CommissioningReportStep1AutoFillResponse>
  commissioningReportStep1Autofill(
    CommissioningStep1AutofillParams params,
    String token,
  );

  Future<CommissioningStep1Response> commissioningReportStep1(
    CommissioningStep1Params params,
    String token,
  );

  Future<CommissioningStep2Response> commissioningReportStep2(
    CommissioningStep2Params params,
    String token,
  );

  Future<CommissioningReportStep2AutoFillResponse>
  commissioningReportStep2Autofill(
    CommissioningStep2AutofillParams params,
    String token,
  );

  Future<CommissioningStep3Response> commissioningReportStep3(
    CommissioningStep3Params params,
    String token,
  );

  Future<CommissioningStep3Response> commissioningReportStep3Autofill(
    CommissioningStep3AutofillParams params,
    String token,
  );

  Future<CommissioningReportStep4AutoFillResponse>
  commissioningReportStep4Autofill(String id, String token);

  Future<CommissioningReportStep4AutoFillResponse> commissioningReportStep4(
    CommissioningStep4Params params,
    String token,
  );

  Future<CommissioningReportStep5AutoFillResponse>
  commissioningReportStep5Autofill(String id);

  Future<CommissioningReportStep5AutoFillResponse> commissioningReportStep5(
    CommissioningStep5Params params,
  );

  Future<CommissioningReportStep6AutoFillResponse>
  commissioningReportStep6Autofill(String id);

  Future<CommissioningReportStep6AutoFillResponse> commissioningReportStep6(
    CommissioningStep6Params params,
  );

  Future<AssignedTechnicianResponse> assignedTechnicianRepresentative(
    String id,
  );

  Future<CommissioningWorkCreateResponse> commissioningWorkCreate(
    CommissioningWorkCreateParams params,
    String token,
  );

  Future<CommissioningWorkCreateResponse> commissioningWorkUpdate(
    CommissioningWorkUpdateParams params,
    String workId,
    String token,
  );

  Future<String> commissioningWorkDelete(
    String workId,
    String token,
  );

  Future<CommissioningReportHistoryResponse> commissioningReportHistory(
    CommissioningReportHistoryParams params,
    String token,
  );

  Future<CommissioningDetailsResponse> commissioningReportDetails(
    String reportId,
    String token,
  );

  Future<CommissioningWorkDetailsResponse> commissioningWorkDetails(
    String workId,
    String token,
  );

  Future<void> logout();
  
  Future<AssignedServiceCallsResponse> assignedServiceCalls(
    AssignedServiceCallsParams params,
    String token,
  );

  Future<PendingServiceCallsResponse> pendingServiceCalls(
    PendingServiceCallsParams params,
    String token,
  );

  Future<ActiveTechniciansServiceCallsResponse> activeTechniciansServiceCalls(
    String token,
  );

  Future<AssignTechnicianServiceCallsResponse> assignTechnicianServiceCalls(
    AssignTechnicianServiceCallsParams params,
    String token,
  );

  Future<CloseOverCallResponse> closeOverCall(
    CloseOverCallParams params,
    String token,
  );

  Future<ServiceCallStep1Response> serviceCallReportStep1(
      ServiceCallReportStep1Params params, String token);

  Future<ServiceCallStep1Response> serviceCallReportStep1AutoFill(
      String complaintId, String token);

  Future<ServiceCallStep2Response> serviceCallReportStep2(
      ServiceCallReportStep2Params params, String token);

  Future<ServiceCallStep2Response> serviceCallReportStep2AutoFill(
      String complaintId, String token);

  Future<ServiceCallStep3Response> serviceCallReportStep3(
      ServiceCallReportStep3Params params, String token);

  Future<ServiceCallStep3Response> serviceCallReportStep3AutoFill(
      String reportId, String token);

  Future<ServiceCallStep4Response> serviceCallReportStep4AutoFill(
      String reportId, String token);

  Future<ServiceCallStep4Response> serviceCallReportStep4(
      String reportId, List<Map<String, dynamic>> descriptions, String token);

  Future<ServiceCallStep5Response> serviceCallReportStep5(
      String reportId,
      bool isMechanicalChecklistNa,
      bool isPipelineChecklistNa,
      bool isElectricalChecklistNa,
      List<Map<String, dynamic>> checklistItems,
      String token);

  Future<ServiceCallStep5Response> serviceCallReportStep5AutoFill(
      String reportId, String token);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiHelper _helper;

  /// Helper for normal API requests
  // final ApiHelper _superAdminHelper; /// Helper for super-admin or special API requests

  const RemoteDataSourceImpl(this._helper /* this._superAdminHelper*/);

  @override
  Future<LoginResponse> login(LoginParams params) async {
    try {
      var data = {"phone": params.phone, "password": params.password};

      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.login,
        data: data,
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
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
  Future<SiteResponse> sites(SitesParams params, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.siteDropdown}?customer_id=${params.customer_id}",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
  Future<CommissioningWorkListResponse> commissioningWorkList(
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.commissioningWork,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
  Future<UpcomingAmcVisitsResponse> upcomingAmc(
    UpcomingAmcParams params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.upcomingAmcVisits,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
  Future<CommissioningReportStep1AutoFillResponse>
  commissioningReportStep1Autofill(
    CommissioningStep1AutofillParams params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url:
            "${ApiUrl.commissioningWorkReportStep1AutoFill}/${params.commissioning_report_id}",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = CommissioningReportStep1AutoFillResponse.fromJson(
        response,
      );
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
  Future<CommissioningStep1Response> commissioningReportStep1(
    CommissioningStep1Params params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.commissioningWorkReportStep1,
        data: {
          "commissioning_work_id": params.commissioningWorkId,
          "technician_ids": params.technicianIds,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
  Future<CommissioningStep2Response> commissioningReportStep2(
    CommissioningStep2Params params,
    String token,
  ) async {
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
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
  Future<CommissioningReportStep2AutoFillResponse>
  commissioningReportStep2Autofill(
    CommissioningStep2AutofillParams params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url:
            "${ApiUrl.commissioningWorkReportStep2AutoFill}/${params.commissioning_report_id}",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = CommissioningReportStep2AutoFillResponse.fromJson(
        response,
      );
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
  Future<CommissioningStep3Response> commissioningReportStep3(
    CommissioningStep3Params params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.commissioningWorkReportStep3,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          "id": params.id,
          "is_technical_na": params.isTechnicalNa,
          "technical_details": params.isTechnicalNa
              ? {}
              : params.technicalDetails?.toJson() ?? {},
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
  Future<CommissioningStep3Response> commissioningReportStep3Autofill(
    CommissioningStep3AutofillParams params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.commissioningWorkReportStep3AutoFill}/${params.id}",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
  Future<CommissioningReportStep4AutoFillResponse>
  commissioningReportStep4Autofill(String id, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.commissioningWorkReportStep4AutoFill}/$id",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final respData = CommissioningReportStep4AutoFillResponse.fromJson(
        response,
      );
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
  Future<CommissioningReportStep4AutoFillResponse> commissioningReportStep4(
    CommissioningStep4Params params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.commissioningWorkReportStep4AutoFill,
        data: {
          "id": params.id,
          "descriptions": params.descriptions
              .map((SavedDescription e) => e.toJson())
              .toList(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final respData = CommissioningReportStep4AutoFillResponse.fromJson(
        response,
      );
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

  @override
  Future<CommissioningReportStep5AutoFillResponse>
  commissioningReportStep5Autofill(String id) async {
    try {
      final response = await _helper.execute(
        url: '${ApiUrl.commissioningWorkReportStep5AutoFill}/$id',
        method: Method.get,
      );

      final respData = CommissioningReportStep5AutoFillResponse.fromJson(
        response,
      );
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
  Future<CommissioningReportStep5AutoFillResponse> commissioningReportStep5(
    CommissioningStep5Params params,
  ) async {
    try {
      final payload = {
        "id": params.id,
        "is_mechanical_checklist_na": params.isMechanicalChecklistNa,
        "is_pipeline_checklist_na": params.isPipelineChecklistNa,
        "is_electrical_checklist_na": params.isElectricalChecklistNa,
        "checklist_items": params.checklistItems
            .map((e) => e.toJson())
            .toList(),
      };

      final response = await _helper.execute(
        url: ApiUrl.commissioningWorkReportStep5,
        method: Method.post,
        data: payload,
      );

      final respData = CommissioningReportStep5AutoFillResponse.fromJson(
        response,
      );
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
  Future<CommissioningReportStep6AutoFillResponse>
  commissioningReportStep6Autofill(String id) async {
    try {
      final response = await _helper.execute(
        url: "${ApiUrl.commissioningWorkReportStep6AutoFill}/$id",
        method: Method.get,
      );

      final respData = CommissioningReportStep6AutoFillResponse.fromJson(
        response,
      );
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
  Future<CommissioningReportStep6AutoFillResponse> commissioningReportStep6(
    CommissioningStep6Params params,
  ) async {
    try {
      final Map<String, dynamic> map = {
        "id": params.id,
        "technician_remarks": params.technicianRemarks,
        "customer_remarks": params.customerRemarks,
        "technician_representative": params.technicianRepresentative,
        "customer_representative_name": params.customerRepresentativeName,
      };

      if (params.technicianSignaturePath != null &&
          params.technicianSignaturePath!.isNotEmpty) {
        map["technician_signature"] = await MultipartFile.fromFile(
          params.technicianSignaturePath!,
          filename: params.technicianSignaturePath!.split('/').last,
        );
      }

      if (params.customerSignaturePath != null &&
          params.customerSignaturePath!.isNotEmpty) {
        map["customer_signature"] = await MultipartFile.fromFile(
          params.customerSignaturePath!,
          filename: params.customerSignaturePath!.split('/').last,
        );
      }

      if (params.workPhotosPaths.isNotEmpty) {
        final List<MultipartFile> files = [];
        for (final path in params.workPhotosPaths) {
          if (path.isNotEmpty) {
            files.add(
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
              ),
            );
          }
        }
        map["work_photos"] = files;
      }

      final formData = FormData.fromMap(map);

      final response = await _helper.execute(
        url: ApiUrl.commissioningWorkReportStep6,
        method: Method.post,
        data: formData,
      );

      final respData = CommissioningReportStep6AutoFillResponse.fromJson(
        response,
      );
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
  Future<AssignedTechnicianResponse> assignedTechnicianRepresentative(
    String id,
  ) async {
    try {
      final response = await _helper.execute(
        url: "${ApiUrl.commissioningWorkReportTechnicians}/$id/technicians",
        method: Method.get,
      );

      final respData = AssignedTechnicianResponse.fromJson(response);
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
  Future<CommissioningWorkCreateResponse> commissioningWorkCreate(
    CommissioningWorkCreateParams params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.commissioningWorkCreate,
        data: params.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = CommissioningWorkCreateResponse.fromJson(response);
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
  Future<CommissioningWorkCreateResponse> commissioningWorkUpdate(
    CommissioningWorkUpdateParams params,
    String workId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.put,
        url: "${ApiUrl.commissioningWork}/$workId/update",
        data: params.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = CommissioningWorkCreateResponse.fromJson(response);
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
  Future<String> commissioningWorkDelete(
    String workId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.delete,
        url: "${ApiUrl.commissioningWork}/$workId/delete",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response['message'] ?? 'Successfully deleted';
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
  Future<CommissioningReportHistoryResponse> commissioningReportHistory(
    CommissioningReportHistoryParams params,
    String token,
  ) async {
    try {
      final Map<String, String> queryParams = {};
      if (params.customerId != null) {
        queryParams['customer_id'] = params.customerId!;
      }
      if (params.siteId != null) {
        queryParams['site_id'] = params.siteId!;
      }
      if (params.date != null) {
        queryParams['date'] = params.date!;
      }
      if (params.startDate != null) {
        queryParams['start_date'] = params.startDate!;
      }
      if (params.endDate != null) {
        queryParams['end_date'] = params.endDate!;
      }
      if (params.search != null) {
        queryParams['search'] = params.search!;
      }
      if (params.ordering != null) {
        queryParams['ordering'] = params.ordering!;
      }
      if (params.page != null) {
        queryParams['page'] = params.page.toString();
      }
      if (params.pageSize != null) {
        queryParams['page_size'] = params.pageSize.toString();
      }

      String queryString = '';
      if (queryParams.isNotEmpty) {
        queryString = '?' +
            queryParams.entries
                .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
                .join('&');
      }

      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.commissioningReportHistory}$queryString",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = CommissioningReportHistoryResponse.fromJson(response);
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
  Future<CommissioningDetailsResponse> commissioningReportDetails(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.commissioningReportDetails}/$reportId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = CommissioningDetailsResponse.fromJson(response);
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
  Future<CommissioningWorkDetailsResponse> commissioningWorkDetails(
    String workId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.commissioningWork}/$workId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = CommissioningWorkDetailsResponse.fromJson(response);
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
  Future<AssignedServiceCallsResponse> assignedServiceCalls(
    AssignedServiceCallsParams params,
    String token,
  ) async {
    try {
      final queryParams = params.toMap();
      final uri = Uri(path: "technician/service-calls/assigned", queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())));
      final response = await _helper.execute(
        method: Method.get,
        url: uri.toString(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return AssignedServiceCallsResponse.fromJson(response);
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<PendingServiceCallsResponse> pendingServiceCalls(
    PendingServiceCallsParams params,
    String token,
  ) async {
    try {
      final queryParams = params.toMap();
      final uri = Uri(path: "technician/service-calls/pending", queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())));
      final response = await _helper.execute(
        method: Method.get,
        url: uri.toString(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return PendingServiceCallsResponse.fromJson(response);
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<ActiveTechniciansServiceCallsResponse> activeTechniciansServiceCalls(
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.activeTechniciansServiceCalls,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ActiveTechniciansServiceCallsResponse.fromJson(response);
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
  Future<AssignTechnicianServiceCallsResponse> assignTechnicianServiceCalls(
    AssignTechnicianServiceCallsParams params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.serviceCallsAssigned,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: params.toMap(),
      );

      final respData = AssignTechnicianServiceCallsResponse.fromJson(response);
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
  Future<CloseOverCallResponse> closeOverCall(
    CloseOverCallParams params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.closeOverCall,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: params.toMap(),
      );

      final respData = CloseOverCallResponse.fromJson(response);
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
  Future<ServiceCallStep1Response> serviceCallReportStep1(
      ServiceCallReportStep1Params params, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.serviceCallReportStep1,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: params.toJson(),
      );

      final respData = ServiceCallStep1Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<ServiceCallStep1Response> serviceCallReportStep1AutoFill(
      String complaintId, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.serviceCallReportStep1AutoFill}$complaintId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceCallStep1Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<ServiceCallStep2Response> serviceCallReportStep2AutoFill(
      String complaintId, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.serviceCallReportStep2AutoFill}$complaintId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceCallStep2Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<ServiceCallStep2Response> serviceCallReportStep2(
      ServiceCallReportStep2Params params, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.serviceCallReportStep2,
        data: params.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceCallStep2Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<ServiceCallStep3Response> serviceCallReportStep3(
      ServiceCallReportStep3Params params, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.serviceCallReportStep3,
        data: params.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceCallStep3Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<ServiceCallStep3Response> serviceCallReportStep3AutoFill(
      String reportId, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.serviceCallReportStep3AutoFill}$reportId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceCallStep3Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<ServiceCallStep4Response> serviceCallReportStep4AutoFill(
      String reportId, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.serviceCallReportStep4AutoFill}$reportId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceCallStep4Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }
  @override
  Future<ServiceCallStep4Response> serviceCallReportStep4(
      String reportId, List<Map<String, dynamic>> descriptions, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.serviceCallReportStep4,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          "id": reportId,
          "descriptions": descriptions,
        },
      );

      final respData = ServiceCallStep4Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<ServiceCallStep5Response> serviceCallReportStep5(
      String reportId,
      bool isMechanicalChecklistNa,
      bool isPipelineChecklistNa,
      bool isElectricalChecklistNa,
      List<Map<String, dynamic>> checklistItems,
      String token) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.serviceCallReportStep5,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          "id": reportId,
          "is_mechanical_checklist_na": isMechanicalChecklistNa,
          "is_pipeline_checklist_na": isPipelineChecklistNa,
          "is_electrical_checklist_na": isElectricalChecklistNa,
          "checklist_items": checklistItems,
        },
      );

      final respData = ServiceCallStep5Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<ServiceCallStep5Response> serviceCallReportStep5AutoFill(
      String reportId, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.serviceCallReportStep5AutoFill}$reportId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      final respData = ServiceCallStep5Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        throw e;
      }
      throw ServerException();
    }
  }
}
