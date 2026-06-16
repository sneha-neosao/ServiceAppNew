import 'package:dio/dio.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_history_response.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_pdf_response.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step1_response.dart';
import 'package:service_app/src/domain/usecases/amc_report/get_amc_report_step1_autofill_usecase.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_visit_complete_response.dart';
import 'package:service_app/src/domain/usecases/amc_report/post_amc_report_step2_usecase.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step2_response.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step3_response.dart';
import 'package:service_app/src/domain/usecases/amc_report/post_amc_report_step3_usecase.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_assigned_technicians_response.dart';
import 'package:service_app/src/domain/usecases/amc_report/post_amc_report_step1_usecase.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import 'package:service_app/src/features/common/domain/usecase/sites_usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/customer_usecase.dart';
import 'package:service_app/src/features/home/domain/usecase/upcoming_amc_usecase.dart';
import 'package:service_app/src/features/login/domain/usecase/login_usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';
import 'package:service_app/src/remote/models/auth_model/app_settings_response.dart';
import 'package:service_app/src/remote/models/auth_model/fcm_register_response.dart';
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
import 'package:service_app/src/remote/models/assigned_servicecall_technician_model/assigned_servicecall_technician_response.dart';
import 'package:service_app/src/remote/models/close_over_call_model/close_over_call_response.dart';
import 'package:service_app/src/remote/models/servicecall_report_step1_model/servicecall_report_step1_response.dart';
import 'package:service_app/src/remote/models/servicecall_report_step2_model/servicecall_report_step2_response.dart';
import 'package:service_app/src/remote/models/servicecall_report_step3_model/servicecall_report_step3_response.dart';
import 'package:service_app/src/remote/models/servicecall_report_step4_model/servicecall_report_step4_response.dart'
    hide SavedDescription;
import 'package:service_app/src/remote/models/servicecall_report_step5_model/servicecall_report_step5_response.dart'
    hide SavedChecklist;
import 'package:service_app/src/remote/models/servicecall_report_step6_model/servicecall_report_step6_response.dart';
import 'package:service_app/src/remote/models/servicecall_report_step6_autofill_model/servicecall_report_step6_autofill_response.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step1_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step2_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step3_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step6_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/assigned_service_calls_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/pending_service_calls_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/assign_technician_service_calls_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/close_over_call_usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step1_model/service_work_report_step1_response.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step1_usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step2_model/service_work_report_step2_response.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step2_usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step3_model/service_work_report_step3_response.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step3_usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step4_model/service_work_report_step4_response.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step4_usecase.dart';
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
import '../models/commissioning_report_history_model/commissioning_report_pdf_response.dart';
import '../models/commissioning_work_model/commissioning_work_details_response.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_create_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_update_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_report_history_usecase.dart';
import '../models/create_new_customer_model/create_new_customer_response.dart';
import '../../features/common/domain/usecase/create_new_customer_usecase.dart';
import '../models/create_new_site_model/create_new_site_response.dart';
import '../../features/common/domain/usecase/create_new_site_usecase.dart';
import '../models/feedback_model/feedback_response.dart';
import '../models/servicecalls_report_history_model/servicecalls_report_history_response.dart';
import '../models/amc_visit_model/amc_visit_list_response.dart';
import '../models/amc_visit_model/amc_visit_reports_response.dart';
import '../models/delete_account_model/delete_account_response.dart';
import '../models/service_calls_details_model/service_calls_details_response.dart';
import '../models/amc_report_model/delete_amc_report_response.dart';
import '../models/delete_service_work_report_model/delete_service_work_report_response.dart';
import '../models/notifications_model/notifications_response.dart';

sealed class RemoteDataSource {
  Future<LoginResponse> login(LoginParams params);

  Future<ProfileDetailsResponse> profileDetails(String token);

  Future<CustomerResponse> customers(CustomerParams params, String token);

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

  Future<String> commissioningWorkDelete(String workId, String token);

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

  Future<AmcReportStep1Response> amcReportStep1(
    PostAmcReportStep1Params params,
    String token,
  );

  Future<AmcReportStep2Response> amcReportStep2(
    PostAmcReportStep2Params params,
    String token,
  );

  Future<AmcReportStep3Response> amcReportStep3(
    PostAmcReportStep3Params params,
    String token,
  );

  Future<AmcHistoryResponse> amcReportsHistory(
    String token,
  );

  Future<AmcReportStep1Response> amcReportStep1AutoFill(
    String reportId,
    String token,
  );

  Future<AmcReportStep2Response> amcReportStep2AutoFill(
    String reportId,
    String token,
  );

  Future<AmcAssignedTechniciansResponse> amcReportAssignedTechnicians(
    String reportId,
    String token,
  );

  Future<void> logout();

  Future<FcmRegisterResponse> fcmRegister(String fcmToken, String token);

  Future<AppSettingsResponse> getAppSettings(String token);

  Future<DeleteAccountResponse> deleteAccount(String token);

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
    ServiceCallReportStep1Params params,
    String token,
  );

  Future<ServiceWorkReportStep1Response> serviceWorkReportStep1(
    ServiceWorkReportStep1Params params,
    String token,
  );

  Future<ServiceWorkReportStep2Response> serviceWorkReportStep2(
    ServiceWorkReportStep2Params params,
    String token,
  );

  Future<ServiceWorkReportStep2Response> serviceWorkReportStep2AutoFill(
    String reportId,
    String token,
  );

  Future<ServiceWorkReportStep3Response> serviceWorkReportStep3(
    ServiceWorkReportStep3Params params,
    String token,
  );

  Future<ServiceWorkReportStep4Response> serviceWorkReportStep4(
    ServiceWorkReportStep4Params params,
    String token,
  );

  Future<AssignedTechnicianResponse> serviceWorkReportTechnicians(
    String reportId,
    String token,
  );

  Future<ServiceWorkReportStep3Response> serviceWorkReportStep3AutoFill(
    String reportId,
    String token,
  );

  Future<ServiceWorkReportStep4Response> serviceWorkReportStep4AutoFill(
    String reportId,
    String token,
  );

  Future<ServiceWorkReportStep1Response> serviceWorkReportStep1AutoFill(
    String complaintId,
    String token,
  );

  Future<ServiceCallStep1Response> serviceCallReportStep1AutoFill(
    String complaintId,
    String token,
  );

  Future<ServiceCallStep2Response> serviceCallReportStep2(
    ServiceCallReportStep2Params params,
    String token,
  );

  Future<ServiceCallStep2Response> serviceCallReportStep2AutoFill(
    String complaintId,
    String token,
  );

  Future<ServiceCallStep3Response> serviceCallReportStep3(
    ServiceCallReportStep3Params params,
    String token,
  );

  Future<ServiceCallStep3Response> serviceCallReportStep3AutoFill(
    String reportId,
    String token,
  );

  Future<ServiceCallStep4Response> serviceCallReportStep4AutoFill(
    String reportId,
    String token,
  );

  Future<ServiceCallStep4Response> serviceCallReportStep4(
    String reportId,
    List<Map<String, dynamic>> descriptions,
    String token,
  );

  Future<ServiceCallStep5Response> serviceCallReportStep5(
    String reportId,
    bool isMechanicalChecklistNa,
    bool isPipelineChecklistNa,
    bool isElectricalChecklistNa,
    List<Map<String, dynamic>> checklistItems,
    String token,
  );

  Future<ServiceCallStep5Response> serviceCallReportStep5AutoFill(
    String reportId,
    String token,
  );

  Future<AssignedServiceCallTechnicianResponse> assignedServiceCallTechnicians(
    String reportId,
    String token,
  );

  Future<ServiceCallStep6Response> serviceCallReportStep6(
    ServiceCallReportStep6Params params,
    String token,
  );

  Future<ServiceCallReportStep6AutoFillResponse> serviceCallReportStep6AutoFill(
    String reportId,
    String token,
  );

  Future<AddCustomerResponse> createNewCustomer(
    CreateNewCustomerParams params,
    String token,
  );

  Future<AddSiteResponse> createNewSite(
    CreateNewSiteParams params,
    String token,
  );

  Future<FeedbackResponse> getCommissioningReportFeedback(
    String reportId,
    String token,
  );

  Future<CommissioningReportPdfResponse> getCommissioningReportPdf(
    String reportId,
    String token,
  );

  Future<AmcReportPdfResponse> getAmcReportPdf(
    String reportId,
    String token,
  );

  Future<FeedbackResponse> getAmcCheckFeedback(
    String amcVisitId,
    String token,
  );

  Future<FeedbackResponse> getServiceCallReportFeedback(
    String reportId,
    String token,
  );

  Future<ServiceCallReportResponse> getServiceCallsReportHistory(String token);

  Future<CommissioningReportPdfResponse> getServiceCallReportPdf(
    String reportId,
    String token,
  );

  Future<AmcVisitsListResponse> technicianAmcs(String token);

  Future<AmcVisitReportsResponse> amcVisitReports(String visitId, String token);

  Future<ServiceCallDetailsResponse> serviceCallDetails(
    String id,
    String token,
  );

  Future<AmcVisitCompleteResponse> postAmcVisitComplete(
    String visitId,
    String token,
  );

  Future<DeleteAmcReportResponse> deleteAmcReport(
    String reportId,
    String token,
  );

  Future<DeleteServiceWorkReportResponse> deleteServiceWorkReport(
    String reportId,
    String token,
  );

  Future<NotificationsResponse> getNotifications({
    required int page,
    required String token,
    String? customerName,
    String? siteName,
    String? date,
  });
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
  Future<FcmRegisterResponse> fcmRegister(String fcmToken, String token) async {
    try {
      var data = {"fcm_token": fcmToken};

      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.fcmRegister,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = FcmRegisterResponse.fromJson(response);
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
  Future<AppSettingsResponse> getAppSettings(String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.appSettings,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AppSettingsResponse.fromJson(response);
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
  Future<CustomerResponse> customers(
    CustomerParams params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url:
            '${ApiUrl.customerDropdown}?page=${params.page}&page_size=${params.pageSize}&search=${params.search}',
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
        url:
            "${ApiUrl.siteDropdown}?customer_id=${params.customer_id}&page=${params.page}&page_size=${params.pageSize}&search=${params.search}",
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
      String url = '${ApiUrl.upcomingAmcVisits}?filter=${params.filter.toLowerCase()}';
      if (params.pending != null && params.pending!.isNotEmpty) {
        url += '&pending=${params.pending}';
      }

      print("🚀🚀🚀 API CALL: $url 🚀🚀🚀");

      final response = await _helper.execute(
        method: Method.get,
        url: url,
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
  Future<DeleteAccountResponse> deleteAccount(String token) async {
    try {
      final response = await _helper.execute(
        url: ApiUrl.technicianDeleteAccount,
        method: Method.delete,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final respData = DeleteAccountResponse.fromJson(response);
      if (respData.status == 200) {
        return respData;
      } else {
        throw ApiException(respData.message);
      }
    } on DioException catch (e) {
      logger.e(e.toString());
      if (e.response != null && e.response?.data != null) {
        if (e.response?.data is Map<String, dynamic>) {
          if (e.response?.data['message'] != null) {
            throw ApiException(e.response?.data['message']);
          }
        }
      }
      throw ServerException();
    } catch (e) {
      logger.e(e);
      if (e is ApiException) {
        throw e;
      }
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
      final session = await SessionManager.getUserSession();
      final Map<String, dynamic> map = {
        "id": params.id,
        "technician_remarks": params.technicianRemarks,
        "customer_remarks": params.customerRemarks,
        "technician_representative": params.technicianRepresentative,
        "customer_representative_name": params.customerRepresentativeName,
        "technician_id": session?.technician?.id ?? session?.dealer?.id ?? "",
      };

      print("=== Step 6 API Payload ===");
      print("Parameters: $map");
      print("Technician Signature Path: ${params.technicianSignaturePath}");
      print("Customer Signature Path: ${params.customerSignaturePath}");
      print("Work Photos Paths: ${params.workPhotosPaths}");
      print("==========================");

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
  Future<AmcReportStep1Response> amcReportStep1(
    PostAmcReportStep1Params params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.amcReportStep1,
        data: params.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AmcReportStep1Response.fromJson(response);
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
  Future<AmcReportStep2Response> amcReportStep2(
    PostAmcReportStep2Params params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.amcReportStep2,
        data: params.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AmcReportStep2Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<AmcReportStep3Response> amcReportStep3(
    PostAmcReportStep3Params params,
    String token,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        "id": params.id,
        "technician_remarks": params.technicianRemarks,
        "customer_remarks": params.customerRemarks,
        "technician_representative": params.technicianRepresentative,
        "customer_representative_name": params.customerRepresentativeName,
      });

      for (var photo in params.workPhotos) {
        if (photo.path.isNotEmpty) {
          formData.files.add(MapEntry(
            "work_photos",
            await MultipartFile.fromFile(photo.path, filename: photo.path.split('/').last),
          ));
        }
      }

      if (params.technicianSignature != null && params.technicianSignature!.path.isNotEmpty) {
        formData.files.add(MapEntry(
          "technician_signature",
          await MultipartFile.fromFile(params.technicianSignature!.path, filename: params.technicianSignature!.path.split('/').last),
        ));
      }

      if (params.customerSignature != null && params.customerSignature!.path.isNotEmpty) {
        formData.files.add(MapEntry(
          "customer_signature",
          await MultipartFile.fromFile(params.customerSignature!.path, filename: params.customerSignature!.path.split('/').last),
        ));
      }

      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.amcReportStep3,
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        }),
      );

      final respData = AmcReportStep3Response.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<AmcHistoryResponse> amcReportsHistory(String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.amcReportsHistory,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final respData = AmcHistoryResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<AmcReportStep1Response> amcReportStep1AutoFill(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.amcReportStep1AutoFill}$reportId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AmcReportStep1Response.fromJson(response);
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
  Future<AmcReportStep2Response> amcReportStep2AutoFill(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.amcReportStep2AutoFill}$reportId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AmcReportStep2Response.fromJson(response);
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
  Future<AmcAssignedTechniciansResponse> amcReportAssignedTechnicians(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.amcReportAssignedTechnicians}$reportId/technicians',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AmcAssignedTechniciansResponse.fromJson(response);
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
  Future<String> commissioningWorkDelete(String workId, String token) async {
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
        queryString =
            '?' +
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
      final uri = Uri(
        path: "technician/service-calls/assigned",
        queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())),
      );
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
      final uri = Uri(
        path: "technician/service-calls/pending",
        queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())),
      );
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
    ServiceCallReportStep1Params params,
    String token,
  ) async {
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
  Future<ServiceWorkReportStep1Response> serviceWorkReportStep1(
    ServiceWorkReportStep1Params params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.serviceWorkReportStep1,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: params.toJson(),
      );

      final respData = ServiceWorkReportStep1Response.fromJson(response);
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
  Future<ServiceWorkReportStep2Response> serviceWorkReportStep2(
    ServiceWorkReportStep2Params params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.serviceWorkReportStep2,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: params.toJson(),
      );

      final respData = ServiceWorkReportStep2Response.fromJson(response);
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
  Future<ServiceWorkReportStep1Response> serviceWorkReportStep1AutoFill(
    String complaintId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.serviceWorkReportStep1AutoFill}$complaintId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceWorkReportStep1Response.fromJson(response);
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
  Future<ServiceWorkReportStep2Response> serviceWorkReportStep2AutoFill(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.serviceWorkReportStep2AutoFill}$reportId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceWorkReportStep2Response.fromJson(response);
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
  Future<ServiceWorkReportStep3Response> serviceWorkReportStep3(
    ServiceWorkReportStep3Params params,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.serviceWorkReportStep3,
        data: params.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceWorkReportStep3Response.fromJson(response);
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
  Future<AssignedTechnicianResponse> serviceWorkReportTechnicians(
      String reportId, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.serviceWorkReportTechnicians}$reportId/technicians',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final respData = AssignedTechnicianResponse.fromJson(response);

      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
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
  Future<ServiceWorkReportStep4Response> serviceWorkReportStep4(
    ServiceWorkReportStep4Params params,
    String token,
  ) async {
    try {
      final Map<String, dynamic> map = {
        "id": params.id,
        "customer_representative_name": params.customerRepresentativeName,
        "customer_remarks": params.customerRemarks,
        "technician_remarks": params.technicianRemarks,
        "technician_representative": params.technicianRepresentative,
        if (params.qrCodeUrl.isNotEmpty) "qr_code_url": params.qrCodeUrl,
      };

      if (params.technicianSignaturePath != null &&
          params.technicianSignaturePath!.isNotEmpty) {
        if (params.technicianSignaturePath!.startsWith('http')) {
          map["technician_signature"] = params.technicianSignaturePath!;
        } else {
          map["technician_signature"] = await MultipartFile.fromFile(
            params.technicianSignaturePath!,
            filename: params.technicianSignaturePath!.split('/').last,
          );
        }
      }

      if (params.customerSignaturePath != null &&
          params.customerSignaturePath!.isNotEmpty) {
        if (params.customerSignaturePath!.startsWith('http')) {
          map["customer_signature"] = params.customerSignaturePath!;
        } else {
          map["customer_signature"] = await MultipartFile.fromFile(
            params.customerSignaturePath!,
            filename: params.customerSignaturePath!.split('/').last,
          );
        }
      }

      if (params.workPhotosPaths.isNotEmpty) {
        final List<dynamic> files = [];
        for (final path in params.workPhotosPaths) {
          if (path.isNotEmpty) {
            if (path.startsWith('http')) {
              files.add(path);
            } else {
              files.add(
                await MultipartFile.fromFile(
                  path,
                  filename: path.split('/').last,
                ),
              );
            }
          }
        }
        map["work_photos"] = files;
      }

      final formData = FormData.fromMap(map);

      final response = await _helper.execute(
        url: ApiUrl.serviceWorkReportStep4,
        method: Method.post,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceWorkReportStep4Response.fromJson(response);
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
  Future<ServiceWorkReportStep3Response> serviceWorkReportStep3AutoFill(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.serviceWorkReportStep3AutoFill}$reportId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceWorkReportStep3Response.fromJson(response);
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
  Future<ServiceWorkReportStep4Response> serviceWorkReportStep4AutoFill(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.serviceWorkReportStep4AutoFill}$reportId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceWorkReportStep4Response.fromJson(response);

      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
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
  Future<ServiceCallStep1Response> serviceCallReportStep1AutoFill(
    String complaintId,
    String token,
  ) async {
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
    String complaintId,
    String token,
  ) async {
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
    ServiceCallReportStep2Params params,
    String token,
  ) async {
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
    ServiceCallReportStep3Params params,
    String token,
  ) async {
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
    String reportId,
    String token,
  ) async {
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
    String reportId,
    String token,
  ) async {
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
    String reportId,
    List<Map<String, dynamic>> descriptions,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.serviceCallReportStep4,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {"id": reportId, "descriptions": descriptions},
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
    String token,
  ) async {
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
    String reportId,
    String token,
  ) async {
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

  @override
  Future<AssignedServiceCallTechnicianResponse> assignedServiceCallTechnicians(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.assignedServiceCallTechnicians}$reportId/technicians",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AssignedServiceCallTechnicianResponse.fromJson(response);
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
  Future<ServiceCallStep6Response> serviceCallReportStep6(
    ServiceCallReportStep6Params params,
    String token,
  ) async {
    try {
      final session = await SessionManager.getUserSession();
      final Map<String, dynamic> map = {
        "id": params.id,
        "technician_remarks": params.technicianRemarks,
        "customer_remarks": params.customerRemarks,
        "technician_representative": params.technicianRepresentative,
        "customer_representative_name": params.customerRepresentativeName,
        "technician_id": session?.technician?.id ?? session?.dealer?.id ?? "",
      };

      print("=== Service Call Step 6 API Payload ===");
      print("Parameters: $map");
      print("Technician Signature Path: ${params.technicianSignaturePath}");
      print("Customer Signature Path: ${params.customerSignaturePath}");
      print("Work Photos Paths: ${params.workPhotosPaths}");
      print("==========================");

      if (params.technicianSignaturePath != null &&
          params.technicianSignaturePath!.isNotEmpty) {
        if (params.technicianSignaturePath!.startsWith('http')) {
          map["technician_signature"] = params.technicianSignaturePath!;
        } else {
          map["technician_signature"] = await MultipartFile.fromFile(
            params.technicianSignaturePath!,
            filename: params.technicianSignaturePath!.split('/').last,
          );
        }
      }

      if (params.customerSignaturePath != null &&
          params.customerSignaturePath!.isNotEmpty) {
        if (params.customerSignaturePath!.startsWith('http')) {
          map["customer_signature"] = params.customerSignaturePath!;
        } else {
          map["customer_signature"] = await MultipartFile.fromFile(
            params.customerSignaturePath!,
            filename: params.customerSignaturePath!.split('/').last,
          );
        }
      }

      if (params.workPhotosPaths.isNotEmpty) {
        final List<dynamic> files = [];
        for (final path in params.workPhotosPaths) {
          if (path.isNotEmpty) {
            if (path.startsWith('http')) {
              files.add(path);
            } else {
              files.add(
                await MultipartFile.fromFile(
                  path,
                  filename: path.split('/').last,
                ),
              );
            }
          }
        }
        map["work_photos"] = files;
      }

      final formData = FormData.fromMap(map);

      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.serviceCallReportStep6,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return ServiceCallStep6Response.fromJson(response);
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
  Future<ServiceCallReportStep6AutoFillResponse> serviceCallReportStep6AutoFill(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: "${ApiUrl.serviceCallReportStep6AutoFill}$reportId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return ServiceCallReportStep6AutoFillResponse.fromJson(response);
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
  Future<AddCustomerResponse> createNewCustomer(
    CreateNewCustomerParams params,
    String token,
  ) async {
    try {
      final payload = {
        "name": params.name,
        "merge_existing": params.mergeExisting,
        "sites": params.sites,
      };

      final response = await _helper.execute(
        url: ApiUrl.technicianCreateCustomer,
        method: Method.post,
        data: payload,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AddCustomerResponse.fromJson(response);
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
  Future<AddSiteResponse> createNewSite(
    CreateNewSiteParams params,
    String token,
  ) async {
    try {
      final payload = {
        "customer_id": params.customerId,
        "name": params.customerName,
        "sites": [
          {
            "name": params.siteName,
            "contacts": [
              {"mobile_num": "", "email": "", "receiveAlerts": true},
            ],
          },
        ],
      };

      final response = await _helper.execute(
        url: "${ApiUrl.technicianCreateCustomer}/${params.customerId}",
        method: Method.put,
        data: payload,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AddSiteResponse.fromJson(response);
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
  Future<FeedbackResponse> getCommissioningReportFeedback(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.commissioningReportDetails}/$reportId/check-feedback',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = FeedbackResponse.fromJson(response);
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
  Future<CommissioningReportPdfResponse> getCommissioningReportPdf(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.commissioningReportDetails}/$reportId/pdf',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = CommissioningReportPdfResponse.fromJson(response);
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
  Future<FeedbackResponse> getServiceCallReportFeedback(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.serviceCallCheckFeedback}/$reportId/check-feedback',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = FeedbackResponse.fromJson(response);
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
  Future<ServiceCallReportResponse> getServiceCallsReportHistory(
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.serviceCallReportHistory,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceCallReportResponse.fromJson(response);
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
  Future<CommissioningReportPdfResponse> getServiceCallReportPdf(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.serviceCallReport}/$reportId/pdf',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = CommissioningReportPdfResponse.fromJson(response);
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
  Future<AmcVisitsListResponse> technicianAmcs(String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.technicianAmcs,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AmcVisitsListResponse.fromJson(response);
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
  Future<AmcVisitReportsResponse> amcVisitReports(String visitId, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.amcVisitReports}$visitId/reports',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AmcVisitReportsResponse.fromJson(response);
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
  Future<ServiceCallDetailsResponse> serviceCallDetails(String id, String token) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.serviceCallDetails}$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = ServiceCallDetailsResponse.fromJson(response);
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
  Future<AmcReportPdfResponse> getAmcReportPdf(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: '${ApiUrl.amcReportDetails}/$reportId/pdf',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final respData = AmcReportPdfResponse.fromJson(response);
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
  Future<FeedbackResponse> getAmcCheckFeedback(
    String amcVisitId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: 'technician/amc-visit/$amcVisitId/check-feedback',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return FeedbackResponse.fromJson(response);
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      if (e.toString() == noElement) throw AuthException();
      if (e is ApiException) throw e;
      throw ServerException();
    }
  }

  @override
  Future<AmcVisitCompleteResponse> postAmcVisitComplete(
    String visitId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: 'technician/amcs/visit/$visitId/complete',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return AmcVisitCompleteResponse.fromJson(response);
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      if (e.toString() == noElement) throw AuthException();
      if (e is ApiException) throw e;
      throw ServerException();
    }
  }

  @override
  Future<DeleteAmcReportResponse> deleteAmcReport(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.delete,
        url: 'technician/amc-report/$reportId/delete',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return DeleteAmcReportResponse.fromJson(response);
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      if (e.toString() == noElement) throw AuthException();
      if (e is ApiException) throw e;
      throw ServerException();
    }
  }

  @override
  Future<DeleteServiceWorkReportResponse> deleteServiceWorkReport(
    String reportId,
    String token,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.delete,
        url: '${ApiUrl.deleteServiceWorkReport}$reportId/delete',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return DeleteServiceWorkReportResponse.fromJson(response);
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      if (e.toString() == noElement) throw AuthException();
      if (e is ApiException) throw e;
      throw ServerException();
    }
  }

  @override
  Future<NotificationsResponse> getNotifications({
    required int page,
    required String token,
    String? customerName,
    String? siteName,
    String? date,
  }) async {
    try {
      String params = '?page=$page&page_size=10';
      if (customerName != null && customerName.isNotEmpty) {
        params += '&customer_name=$customerName';
      }
      if (siteName != null && siteName.isNotEmpty) {
        params += '&site_name=$siteName';
      }
      if (date != null && date.isNotEmpty) {
        params += '&date=$date';
      }

      final response = await _helper.execute(
        method: Method.get,
        url: 'notifications$params',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return NotificationsResponse.fromJson(response);
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      if (e.toString() == noElement) throw AuthException();
      if (e is ApiException) throw e;
      throw ServerException();
    }
  }
}
