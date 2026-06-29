import 'package:dio/dio.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_report_step1_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/get_amc_report_pdf_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_report_step2_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_report_step3_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/get_amc_check_feedback_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_visit_complete_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/get_amc_report_step1_autofill_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/get_amc_report_step2_autofill_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/get_amc_assigned_technicians_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/get_amc_reports_history_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:service_app/src/features/common/domain/usecase/customer_usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/sites_usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/technician_usecase.dart';
import 'package:service_app/src/features/home/domain/usecase/upcoming_amc_usecase.dart';
import 'package:service_app/src/features/login/domain/usecase/login_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step1_autofill_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_work_usecase.dart';
import 'package:service_app/src/features/profile/domain/usecase/profile_details_usecase.dart';
import 'package:service_app/src/features/profile/domain/usecase/delete_account_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step1_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step2_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step2_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step3_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step3_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step4_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step4_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step5_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step5_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step6_autofill_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_step6_usecase.dart';
import '../../features/my_commissioning/domain/usecase/assigned_technician_representative_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_create_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_report_history_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_report_details_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_report_check_feedback_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_report_pdf_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_history_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_check_feedback_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_pdf_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_complaint_pdf_usecase.dart';
import '../../features/service_calls/bloc/service_call_complaint_pdf_bloc/service_call_complaint_pdf_bloc.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_details_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_update_usecase.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_delete_usecase.dart';
import '../../features/service_calls/domain/usecase/assigned_service_calls_usecase.dart';
import '../../features/service_calls/domain/usecase/pending_service_calls_usecase.dart';
import '../../features/service_calls/domain/usecase/active_technicians_service_calls_usecase.dart';
import '../../features/service_calls/domain/usecase/assign_technician_service_calls_usecase.dart';
import '../../features/service_calls/domain/usecase/close_over_call_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step1_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step1_autofill_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step2_autofill_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step2_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step3_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step3_autofill_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step4_autofill_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step4_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step5_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step5_autofill_usecase.dart';
import '../../features/service_calls/domain/usecase/assigned_servicecall_technician_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step6_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_report_step6_autofill_usecase.dart';
import '../../features/service_calls/domain/usecase/service_call_details_usecase.dart';
import '../../features/common/domain/usecase/create_new_customer_usecase.dart';
import '../../features/common/domain/usecase/create_new_site_usecase.dart';
import '../../features/amc/domain/usecase/amc_visits_list_usecase.dart';
import '../../features/amc/domain/usecase/get_customer_amc_visits_usecase.dart';
import '../../features/amc/bloc/customer_amc_visits_bloc/customer_amc_visits_bloc.dart';
import '../../features/amc/domain/usecase/amc_visit_reports_usecase.dart';
import '../../features/amc/domain/usecase/delete_amc_report_usecase.dart';
import '../../features/reports/domain/usecases/service_work_report_step1_usecase.dart';
import '../../features/reports/domain/usecases/service_work_report_step2_usecase.dart';
import '../../features/reports/domain/usecases/service_work_report_step1_autofill_usecase.dart';
import '../../features/reports/domain/usecases/service_work_report_step2_autofill_usecase.dart';
import '../../features/reports/domain/usecases/service_work_report_step3_usecase.dart';
import '../../features/reports/domain/usecases/service_work_report_step4_usecase.dart';
import '../../features/reports/domain/usecases/service_work_report_step4_autofill_usecase.dart';
import '../../features/reports/domain/usecases/service_work_report_technicians_usecase.dart';
import '../../features/reports/domain/usecases/service_work_report_step3_autofill_usecase.dart';
import '../../features/reports/domain/usecases/delete_service_work_report_usecase.dart';
import '../../features/notifications/domain/usecase/fcm_register_usecase.dart';
import '../../features/home/domain/usecase/get_app_settings_usecase.dart';
import '../../features/notifications/domain/usecase/get_notifications_usecase.dart';
import '../../features/notifications/domain/usecase/mark_all_notifications_read_usecase.dart';
import '../../features/notifications/bloc/mark_all_read_bloc/mark_all_read_bloc.dart';
import '../../features/notifications/domain/usecase/get_unread_count_usecase.dart';
import '../../features/notifications/bloc/unread_count_bloc/unread_count_bloc.dart';
import 'injector.dart';

final getIt = GetIt.I;

void configureDepedencies() {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 400,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(ApiInterceptor(dio));
    return dio;
  });

  /// App Essentials
  getIt.registerLazySingleton(() => ThemeBloc());

  getIt.registerLazySingleton(() => TranslateBloc());

  getIt.registerLazySingleton(() => AppRouteConf());

  // getIt.registerFactory(() => BottomNav4Bloc());
  //
  // getIt.registerFactory(() => BottomNav3Bloc());

  getIt.registerFactory(() => SplashBloc());

  getIt.registerLazySingleton(() => DeepLinkService());

  /// Other api blocs

  getIt.registerFactory(() => AuthLoginFormBloc());

  getIt.registerFactory(
    () => AuthLoginBloc(
      getIt<LoginUseCase>(),
      // getIt<ForgotPasswordUseCase>(),
      // getIt<AccountDeleteUseCase>()
    ),
  );

  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(
    () => ProfileDetailsBloc(getIt<ProfileDetailsUseCase>()),
  );

  getIt.registerLazySingleton(
    () => ProfileDetailsUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerLazySingleton(
    () => DeleteAccountUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(() => SitesBloc(getIt<SitesUseCase>()));

  getIt.registerLazySingleton(() => SitesUseCase(getIt<AuthRepositoryImpl>()));

  getIt.registerFactory(() => CustomerBloc(getIt<CustomerUseCase>()));

  getIt.registerLazySingleton(
    () => CustomerUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(() => TechnicianBloc(getIt<TechnicianUseCase>()));

  getIt.registerLazySingleton(
    () => TechnicianUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningWorkListBloc(getIt<CommissioningWorkListUseCase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningWorkListUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(() => UpcomingAmcBloc(getIt<UpcomingAmcUseCase>()));

  getIt.registerLazySingleton(
    () => UpcomingAmcUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep1AutoFillBloc(
      getIt<CommissioningStep1AutofillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep1AutofillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep1Bloc(getIt<CommissioningStep1Usecase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep1Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep2Bloc(getIt<CommissioningStep2Usecase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep2Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep2AutoFillBloc(
      getIt<CommissioningStep2AutofillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep2AutofillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep3Bloc(getIt<CommissioningStep3Usecase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep3Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep3AutoFillBloc(
      getIt<CommissioningStep3AutofillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep3AutofillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep4Bloc(getIt<CommissioningStep4Usecase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep4Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep4AutoFillBloc(
      getIt<CommissioningStep4AutofillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep4AutofillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep5Bloc(getIt<CommissioningStep5Usecase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep5Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep5AutoFillBloc(
      getIt<CommissioningStep5AutofillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep5AutofillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep6Bloc(getIt<CommissioningStep6Usecase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep6Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningStep6AutoFillBloc(
      getIt<CommissioningStep6AutofillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CommissioningStep6AutofillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AssignedTechnicianRepresentativeBloc(
      getIt<AssignedTechnicianRepresentativeUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => AssignedTechnicianRepresentativeUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningWorkCreateBloc(getIt<CommissioningWorkCreateUseCase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningWorkCreateUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningReportHistoryBloc(
      getIt<CommissioningReportHistoryUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CommissioningReportCheckFeedbackUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CheckFeedbackBloc(usecase: getIt<CommissioningReportCheckFeedbackUsecase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningReportPdfUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningReportPdfBloc(usecase: getIt<CommissioningReportPdfUseCase>()),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportHistoryUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportHistoryBloc(usecase: getIt<ServiceCallReportHistoryUsecase>()),
  );

  getIt.registerLazySingleton(
    () => ServiceCallCheckFeedbackUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallCheckFeedbackBloc(usecase: getIt<ServiceCallCheckFeedbackUsecase>()),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportPdfUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportPdfBloc(usecase: getIt<ServiceCallReportPdfUseCase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningReportHistoryUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningReportDetailsBloc(
      getIt<CommissioningReportDetailsUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CommissioningReportDetailsUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () =>
        CommissioningWorkDetailsBloc(getIt<CommissioningWorkDetailsUseCase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningWorkDetailsUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningWorkUpdateBloc(getIt<CommissioningWorkUpdateUseCase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningWorkUpdateUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningWorkDeleteBloc(getIt<CommissioningWorkDeleteUseCase>()),
  );

  getIt.registerLazySingleton(
    () => CommissioningWorkDeleteUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AssignedServiceCallsBloc(getIt<AssignedServiceCallsUseCase>()),
  );

  getIt.registerLazySingleton(
    () => AssignedServiceCallsUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => PendingServiceCallsBloc(getIt<PendingServiceCallsUseCase>()),
  );

  getIt.registerLazySingleton(
    () => PendingServiceCallsUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ActiveTechniciansServiceCallsBloc(
      activeTechniciansServiceCallsUsecase:
          getIt<ActiveTechniciansServiceCallsUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ActiveTechniciansServiceCallsUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AssignTechnicianServiceCallsBloc(
      assignTechnicianServiceCallsUsecase:
          getIt<AssignTechnicianServiceCallsUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => AssignTechnicianServiceCallsUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () =>
        CloseOverCallBloc(closeOverCallUsecase: getIt<CloseOverCallUsecase>()),
  );

  getIt.registerLazySingleton(
    () => CloseOverCallUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep1Bloc(
      usecase: getIt<ServiceCallReportStep1Usecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep1Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceWorkReportStep1Bloc(
      usecase: getIt<ServiceWorkReportStep1Usecase>(),
    ),
  );

  getIt.registerLazySingleton<ServiceWorkReportStep2Usecase>(
    () => ServiceWorkReportStep2Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceWorkReportStep2Bloc(
      usecase: getIt<ServiceWorkReportStep2Usecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceWorkReportStep1Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceWorkReportStep1AutofillBloc(
      getIt<ServiceWorkReportStep1AutoFillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceWorkReportStep1AutoFillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceWorkReportStep2AutofillBloc(
      getIt<ServiceWorkReportStep2AutoFillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceWorkReportStep2AutoFillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceWorkReportStep3Bloc(
      usecase: getIt<ServiceWorkReportStep3Usecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceWorkReportStep3Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceWorkReportStep4Bloc(
      usecase: getIt<ServiceWorkReportStep4Usecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceWorkReportStep4Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceWorkReportStep4AutofillBloc(
      getIt<ServiceWorkReportStep4AutoFillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceWorkReportStep4AutoFillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceWorkReportTechniciansBloc(
      getIt<ServiceWorkReportTechniciansUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceWorkReportTechniciansUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceWorkReportStep3AutofillBloc(
      getIt<ServiceWorkReportStep3AutoFillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceWorkReportStep3AutoFillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep1AutoFillBloc(
      usecase: getIt<ServiceCallReportStep1AutoFillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep1AutoFillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep2AutoFillBloc(
      usecase: getIt<ServiceCallReportStep2AutoFillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep2AutoFillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep2Bloc(
      usecase: getIt<ServiceCallReportStep2Usecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep2Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep3Bloc(
      usecase: getIt<ServiceCallReportStep3Usecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep3Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep3AutoFillBloc(
      usecase: getIt<ServiceCallReportStep3AutoFillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep3AutoFillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep4AutoFillBloc(
      usecase: getIt<ServiceCallReportStep4AutoFillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep4AutoFillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep4Bloc(
      usecase: getIt<ServiceCallReportStep4Usecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep4Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep5Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep5Bloc(
      usecase: getIt<ServiceCallReportStep5Usecase>(),
    ),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep5AutoFillBloc(
      usecase: getIt<ServiceCallReportStep5AutoFillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep5AutoFillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AssignedServicecallTechnicianBloc(
      usecase: getIt<AssignedServicecallTechnicianUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => AssignedServicecallTechnicianUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep6Bloc(
      usecase: getIt<ServiceCallReportStep6Usecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep6Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallReportStep6AutoFillBloc(
      getIt<ServiceCallReportStep6AutoFillUsecase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ServiceCallReportStep6AutoFillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CreateNewCustomerBloc(getIt<CreateNewCustomerUsecase>()),
  );

  getIt.registerLazySingleton(
    () => CreateNewCustomerUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(() => CreateNewSiteBloc(getIt<CreateNewSiteUsecase>()));

  getIt.registerLazySingleton(
    () => CreateNewSiteUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(() => AmcVisitsListBloc(getIt<AmcVisitsListUseCase>()));

  getIt.registerLazySingleton(
    () => AmcVisitsListUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(() => CustomerAmcVisitsBloc(getCustomerAmcVisitsUseCase: getIt<GetCustomerAmcVisitsUseCase>()));

  getIt.registerLazySingleton(
    () => GetCustomerAmcVisitsUseCase(repository: getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(() => AmcVisitReportsBloc(getIt<AmcVisitReportsUsecase>()));

  getIt.registerLazySingleton(
    () => AmcVisitReportsUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(() => AmcReportsHistoryBloc(getIt<GetAmcReportsHistoryUseCase>()));

  getIt.registerLazySingleton(
    () => GetAmcReportsHistoryUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallDetailsBloc(getIt<ServiceCallDetailsUseCase>()),
  );

  getIt.registerLazySingleton(
    () => ServiceCallDetailsUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AmcReportStep1Bloc(getIt<PostAmcReportStep1Usecase>()),
  );

  getIt.registerLazySingleton(
    () => PostAmcReportStep1Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AmcReportStep1AutofillBloc(getIt<GetAmcReportStep1AutofillUsecase>()),
  );

  getIt.registerLazySingleton(
    () => GetAmcReportStep1AutofillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AmcReportStep2AutofillBloc(getIt<GetAmcReportStep2AutofillUsecase>()),
  );

  getIt.registerLazySingleton(
    () => GetAmcReportStep2AutofillUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AmcAssignedTechniciansBloc(getIt<GetAmcAssignedTechniciansUsecase>()),
  );

  getIt.registerLazySingleton(
    () => GetAmcAssignedTechniciansUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AmcReportStep2Bloc(getIt<PostAmcReportStep2Usecase>()),
  );

  getIt.registerLazySingleton(
    () => PostAmcReportStep2Usecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AmcReportStep3Bloc(getIt<PostAmcReportStep3UseCase>()),
  );

  getIt.registerLazySingleton(
    () => PostAmcReportStep3UseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AmcReportPdfBloc(getAmcReportPdfUseCase: getIt<GetAmcReportPdfUseCase>()),
  );

  getIt.registerLazySingleton(
    () => GetAmcReportPdfUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AmcCheckFeedbackBloc(getIt<GetAmcCheckFeedbackUseCase>()),
  );

  getIt.registerLazySingleton(
    () => GetAmcCheckFeedbackUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AmcVisitCompleteBloc(getIt<PostAmcVisitCompleteUseCase>()),
  );

  getIt.registerLazySingleton(
    () => PostAmcVisitCompleteUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => DeleteAmcReportBloc(getIt<DeleteAmcReportUsecase>()),
  );

  getIt.registerLazySingleton(
    () => DeleteAmcReportUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => FcmRegisterBloc(fcmRegisterUseCase: getIt<FcmRegisterUseCase>()),
  );

  getIt.registerLazySingleton(
    () => FcmRegisterUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => AppSettingsBloc(getAppSettingsUseCase: getIt<GetAppSettingsUseCase>()),
  );

  getIt.registerLazySingleton(
    () => GetAppSettingsUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => NotificationsBloc(getNotificationsUseCase: getIt<GetNotificationsUseCase>()),
  );

  getIt.registerLazySingleton(
    () => GetNotificationsUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => MarkAllReadBloc(
      markAllNotificationsReadUseCase:
          getIt<MarkAllNotificationsReadUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => MarkAllNotificationsReadUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => UnreadCountBloc(
      getUnreadNotificationCountUseCase:
          getIt<GetUnreadNotificationCountUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetUnreadNotificationCountUseCase(getIt<AuthRepositoryImpl>()),
  );

  // Profile Delete Account
  getIt.registerFactory(() => DeleteAccountBloc(getIt()));

  getIt.registerFactory(
    () => DeleteServiceWorkReportBloc(usecase: getIt<DeleteServiceWorkReportUsecase>()),
  );

  getIt.registerLazySingleton(
    () => DeleteServiceWorkReportUsecase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerLazySingleton(
    () => ServiceCallComplaintPdfUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => ServiceCallComplaintPdfBloc(
      usecase: getIt<ServiceCallComplaintPdfUseCase>(),
    ),
  );

  /// API Helper

  getIt.registerLazySingleton(() => NetworkInfo());

  getIt.registerLazySingleton(
    () =>
        AuthRepositoryImpl(getIt<RemoteDataSourceImpl>(), getIt<NetworkInfo>()),
  );

  getIt.registerLazySingleton(() => RemoteDataSourceImpl(getIt<ApiHelper>()));

  getIt.registerLazySingleton(() => ApiHelper(getIt<Dio>()));

  // getIt.registerLazySingleton(
  //   () => Dio()..interceptors.add(getIt<ApiInterceptor>()),
  // );

  // getIt.registerLazySingleton(() => ApiInterceptor());
}
