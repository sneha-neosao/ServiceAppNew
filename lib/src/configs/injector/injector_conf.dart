import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:service_app/src/features/common/domain/usecase/customer_usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/sites_usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/technician_usecase.dart';
import 'package:service_app/src/features/home/domain/usecase/upcoming_amc_usecase.dart';
import 'package:service_app/src/features/login/domain/usecase/login_usecase.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_list_bloc/commissioning_work_list_bloc.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step1_autofill_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_work_usecase.dart';
import 'package:service_app/src/features/profile/domain/usecase/profile_details_usecase.dart';
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
import '../../features/my_commissioning/bloc/commissioning_step4_autofill_bloc/commissioning_step4_autofill_bloc.dart';
import '../../features/my_commissioning/bloc/commissioning_step4_bloc/commissioning_step4_bloc.dart';
import '../../features/my_commissioning/bloc/commissioning_step5_autofill_bloc/commissioning_step5_autofill_bloc.dart';
import '../../features/my_commissioning/bloc/commissioning_step5_bloc/commissioning_step5_bloc.dart';
import '../../features/my_commissioning/bloc/commissioning_step6_autofill_bloc/commissioning_step6_autofill_bloc.dart';
import '../../features/my_commissioning/bloc/commissioning_step6_bloc/commissioning_step6_bloc.dart';
import '../../features/my_commissioning/bloc/assigned_technician_representative_bloc/assigned_technician_representative_bloc.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_create_usecase.dart';
import '../../features/my_commissioning/bloc/commissioning_work_create_bloc/commissioning_work_create_bloc.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_report_history_usecase.dart';
import '../../features/my_commissioning/bloc/commissioning_report_history_bloc/commissioning_report_history_bloc.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_report_details_usecase.dart';
import '../../features/my_commissioning/bloc/commissioning_report_details_bloc/commissioning_report_details_bloc.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_details_usecase.dart';
import '../../features/my_commissioning/bloc/commissioning_work_details_bloc/commissioning_work_details_bloc.dart';
import '../../features/my_commissioning/domain/usecase/commissioning_work_update_usecase.dart';
import '../../features/my_commissioning/bloc/commissioning_work_update_bloc/commissioning_work_update_bloc.dart';
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
    () => CommissioningWorkDetailsBloc(
      getIt<CommissioningWorkDetailsUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CommissioningWorkDetailsUseCase(getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CommissioningWorkUpdateBloc(
      getIt<CommissioningWorkUpdateUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CommissioningWorkUpdateUseCase(getIt<AuthRepositoryImpl>()),
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
