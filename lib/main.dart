import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:service_app/src/app.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/constants/list_translation_locale.dart';
import 'package:service_app/src/core/services/notification_service.dart';
import 'package:service_app/src/core/services/offline_sync_service.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp();

  final token = await NoficationService.getToken();
  print("FCM token: $token");

  // ✅ Configure Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Ensure HydratedBloc is initialized before using it
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );


  // ✅ Initialize local notifications
  NoficationService.initLocalNotifications();

  // ✅ Initialize notification listener
  NoficationService.initNotificationListener();

  // ✅ Initialize GETIt service locators, and to define all services
  configureDepedencies();

  // ✅ Initialize offline sync service
  OfflineSyncService().initialize();

  // //check shared preference for base url
  // String? savedBaseUrl = await SessionManager.getBaseUrl();
  // if(savedBaseUrl != null && savedBaseUrl.isNotEmpty){
  //   configureDefaultApi(savedBaseUrl);
  // }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [englishLocale, marathiLocale, hindiLocale, gujaratiLocale, kannadaLocale],
      path: "assets/translations",
      startLocale: englishLocale,
      child: const MyApp(),
    ),
  );
}
