import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:service_app/src/features/common/domain/usecase/customer_usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/sites_usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/technician_usecase.dart';
import 'package:service_app/src/features/login/domain/usecase/login_usecase.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_list_bloc/commissioning_work_list_bloc.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_work_usecase.dart';
import 'package:service_app/src/features/profile/domain/usecase/profile_details_usecase.dart';
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

  getIt.registerFactory(
        () => AuthLoginFormBloc(),
  );

  getIt.registerFactory(
        () => AuthLoginBloc(
        getIt<LoginUseCase>(),
        // getIt<ForgotPasswordUseCase>(),
        // getIt<AccountDeleteUseCase>()
    ),
  );

  getIt.registerLazySingleton(
        () => LoginUseCase(
      getIt<AuthRepositoryImpl>(),
    ),
  );

  getIt.registerFactory(
        () => ProfileDetailsBloc(
      getIt<ProfileDetailsUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
        () => ProfileDetailsUseCase(
      getIt<AuthRepositoryImpl>(),
    ),
  );

  getIt.registerFactory(
        () => SitesBloc(
      getIt<SitesUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
        () => SitesUseCase(
      getIt<AuthRepositoryImpl>(),
    ),
  );

  getIt.registerFactory(
        () => CustomerBloc(
      getIt<CustomerUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
        () => CustomerUseCase(
      getIt<AuthRepositoryImpl>(),
    ),
  );

  getIt.registerFactory(
        () => TechnicianBloc(
      getIt<TechnicianUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
        () => TechnicianUseCase(
      getIt<AuthRepositoryImpl>(),
    ),
  );

  getIt.registerFactory(
        () => CommissioningWorkListBloc(
      getIt<CommissioningWorkListUseCase>(),
    ),
  );

  getIt.registerLazySingleton(
        () => CommissioningWorkListUseCase(
      getIt<AuthRepositoryImpl>(),
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
