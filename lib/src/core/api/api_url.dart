class ApiUrl {
  const ApiUrl._();

  static const baseUrl = "http://192.168.1.35:8001/api/v1/"; // TEST
  // static const baseUrl = "https://backend.inorotech.in/api/v1/"; // LIVE

  static const privacy_url = "https://theperpetuity.com/privacy-policy";

  static const terms_condition_url =
      "https://theperpetuity.com/terms-and-conditions";

  static const refund_url = "https://theperpetuity.com/refund-policy";

  static const login = "technician/login";

  static const upcomingAmcVisits = "dashboard/upcoming-amc-visits";

  static const profileDetails = "technician/profile";

  static const customerDropdown = "technician/dropdowns/customers";

  static const siteDropdown = "technician/dropdowns/sites";

  static const technicians = "technician/dropdowns/technicians";

  static const activeTechniciansServiceCalls =
      "technician/service-calls/technicians/dropdown";

  static const commissioningWork = "technician/commissioning-works";

  static const commissioningWorkCreate = "technician/commissioning-work/create";

  static const commissioningWorkUpdate = "technician/commissioning-works";

  static const commissioningWorkDelete = "technician/commissioning-works";

  static const serviceCallsAssigned =
      "technician/service-calls/assign-technicians";

  static const String assignTechnicianServiceCalls =
      'technician/service-calls/assign-technicians';
  static const String closeOverCall =
      'technician/service-calls/close-over-call';
  static const String serviceCallReportStep1 =
      'technician/service-call-report-step1';
  static const String serviceCallReportStep1AutoFill =
      'technician/service-call-report-step1/';
  static const String serviceCallReportStep2 =
      'technician/service-call-report-step2';
  static const String serviceCallReportStep2AutoFill =
      'technician/service-call-report-step2/';
  static const String serviceCallReportStep3 =
      'technician/service-call-report-step3';
  static const String serviceCallReportStep3AutoFill =
      'technician/service-call-report-step3/';
  static const String serviceCallReportStep4 =
      'technician/service-call-report-step4';
  static const String serviceCallReportStep4AutoFill =
      'technician/service-call-report-step4/';
  static const String serviceCallReportStep5 =
      'technician/service-call-report-step5';
  static const String serviceCallReportStep5AutoFill =
      'technician/service-call-report-step5/';
  static const String serviceCallReportStep6 =
      'technician/service-call-report-step6';
  static const String serviceCallReportStep6AutoFill =
      'technician/service-call-report-step6/';
  static const String assignedServiceCallTechnicians =
      'technician/service-call-report/';

  static const serviceCallsPending = "/api/v1/technician/service-calls/pending";

  static const createNewCustomer = "dealer/customers/";

  static const technicianCreateCustomer = "technician/customers";

  static const commissioningWorkReportStep1AutoFill =
      "technician/commissioning-report/step1";

  static const commissioningWorkReportStep2AutoFill =
      "technician/commissioning-report/step2";

  static const commissioningWorkReportStep3AutoFill =
      "technician/commissioning-report/step3";

  static const commissioningWorkReportStep4AutoFill =
      "technician/commissioning-report/step4";

  static const commissioningWorkReportStep5AutoFill =
      "technician/commissioning-report/step5";

  static const commissioningWorkReportStep6AutoFill =
      "technician/commissioning-report/step6";

  static const commissioningWorkReportStep1 =
      "technician/commissioning-report/step1";

  static const commissioningWorkReportStep2 =
      "technician/commissioning-report/step2";

  static const commissioningWorkReportStep3 =
      "technician/commissioning-report/step3";

  static const commissioningWorkReportStep4 =
      "technician/commissioning-report/step4";

  static const commissioningWorkReportStep5 =
      "technician/commissioning-report/step5";

  static const commissioningWorkReportStep6 =
      "technician/commissioning-report/step6";

  static const commissioningWorkReportTechnicians =
      "technician/commissioning-report";

  static const commissioningReportHistory =
      "technician/commissioning-reports/history";

  static const commissioningReportDetails = "technician/commissioning-report";

  static const serviceCallCheckFeedback = "technician/service-call-report";

  static const serviceCallReportHistory = "technician/service-call-reports/history";
}
