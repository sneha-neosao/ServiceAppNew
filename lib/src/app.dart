import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'configs/injector/injector.dart';
import 'configs/injector/injector_conf.dart';
import 'core/blocs/theme/theme_bloc.dart';
import 'core/blocs/translate/translate_bloc.dart';
import 'core/constants/list_translation_locale.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_route_conf.dart';
import 'routes/app_route_path.dart';

/// Root widget for the app. Handles initialization and routing.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// State for MyApp. Sets up router and deep link listeners.
class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = getIt<AppRouteConf>().router;

    final deepLinkService = getIt<DeepLinkService>();

    // Initialize deep link service and handle incoming URIs.
    deepLinkService.initListener((uri) {
      debugPrint("🔗 Received URI: $uri");
      debugPrint("📂 Host: ${uri.host}");
      debugPrint("📂 Path: ${uri.path}");
      debugPrint("📂 PathSegments: ${uri.pathSegments}");
      debugPrint("🔑 Token: ${uri.queryParameters['token']}");
      debugPrint("🔑 company_code: ${uri.queryParameters['company_code']}");

      /// Handle company deep link.
      if (uri.host == "invitation") {
        final companyCode = uri.queryParameters['company_code'];
        print("$companyCode invite code");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _router.goNamed(
            AppRoute.nextScreen.name,
            queryParameters: {'code': companyCode ?? ''},
          );
        });
      }
    });
  }

  /// Builds the main app widget tree with theming, localization, and routing.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<ThemeBloc>()),
            BlocProvider(create: (_) => getIt<TranslateBloc>()),
          ],
          child: BlocListener<TranslateBloc, TranslateState>(
            // When language changes, tell EasyLocalization to switch locale.
            listener: (ctx, translateState) {
              final newLocale = translateState.isMarathi
                  ? marathiLocale
                  : translateState.isHindi
                      ? hindiLocale
                      : translateState.isGujarati
                          ? gujaratiLocale
                          : translateState.isKannada
                              ? kannadaLocale
                              : englishLocale;
              ctx.setLocale(newLocale);
            },
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (_, state) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  theme: AppTheme.data(false),
                  darkTheme: AppTheme.data(true),
                  themeMode: ThemeMode.light,
                  routerConfig: _router,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
