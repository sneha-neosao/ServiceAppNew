class ApiUrl {
  const ApiUrl._();

  // static const baseUrl = "http://192.168.1.35:800/api/v1/"; // TEST
  static const baseUrl = "https://backend.inorotech.in/api/v1/"; // LIVE

  static const privacy_url = "https://theperpetuity.com/privacy-policy";

  static const terms_condition_url = "https://theperpetuity.com/terms-and-conditions";

  static const refund_url = "https://theperpetuity.com/refund-policy";

  static const login = "technician/login";

  static const upcomingAmcVisits = "dashboard/upcoming-amc-visits";

  static const profileDetails = "technician/profile";

  static const customerDropdown = "technician/dropdowns/customers";

  static const siteDropdown = "technician/dropdowns/sites";

  static const technicians = "technician/dropdowns/technicians";

  static const commissioningWork = "technician/commissioning-works";

  static const commissioningWorkUpdate = "technician/commissioning-works";

  static const commissioningWorkDelete = "technician/commissioning-works";

  static const serviceCallsAssigned = "technician/service-calls/assign-technicians";

  static const serviceCallsPending = "/api/v1/technician/service-calls/pending";

  static const createNewCustomer = "dealer/customers/";
}
