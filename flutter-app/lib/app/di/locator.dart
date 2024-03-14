import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../data/cache/settings/settings_cache_client.dart';
import '../../data/cache/user/user_tokens_cache_client.dart';
import '../../data/constants/storage_consts.dart';
import '../../data/handler/request_handler.dart';
import '../../data/repository/settings/settings_repo.dart';
import '../../data/repository/user/user_repo.dart';
import '../../data/source/api/api_requests.dart';
import '../../data/source/api/interceptors/auth_interceptor.dart';
import '../../data/source/api/interceptors/error_interceptor.dart';
import '../../domain/services/auth/auth.dart';
import '../../domain/services/auth/custom_auth_impl.dart';
import '../../domain/services/localization_service.dart';
import '../../domain/services/theme_service.dart';
import '../../presentation/app/main_viewmodel.dart';
import 'storage.dart';

final locator = GetIt.instance;

Future<void> setupDependencies() async {
  await setupStorage();

  locator

    ///Api
    ..registerLazySingleton(
      () => Dio(
        BaseOptions(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          connectTimeout: const Duration(seconds: 30),

          ///Should be loaded from env
          baseUrl: 'https://www.thecocktaildb.com/api/json/v1/1/',
        ),
      ),
    )
    ..registerLazySingleton(
      () => RetryInterceptor(
        dio: locator(),
        logPrint: log,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryableExtraStatuses: {401, 403},
      ),
    )
    ..registerLazySingleton(
      () => AuthInterceptor(
        auth: locator(),
      ),
    )
    ..registerLazySingleton(ErrorInterceptor.new)
    ..registerLazySingleton(
      () => ApiRequests(
        dio: locator<Dio>()
          ..interceptors.add(
            locator<AuthInterceptor>(),
          )
          ..interceptors.add(
            locator<ErrorInterceptor>(),
          )
          ..interceptors.add(
            locator<RetryInterceptor>(),
          ),
      ),
    )
    //Cache Clients
    ..registerLazySingleton(
      () => UserTokensCacheClient(
        box: Hive.box(StorageConsts.hiveEncryptedStorageKey),
      ),
    )
    ..registerLazySingleton(
      () => SettingsCacheClient(
        box: Hive.box(StorageConsts.hiveStorageKey),
      ),
    )

    ///Repository
    ..registerLazySingleton(RequestHandler.new)
    ..registerLazySingleton(
      () => UserRepository(
        tokensCacheClient: locator(),
      ),
    )
    ..registerLazySingleton(
      () => SettingsRepository(
        settingsCacheClient: locator(),
      ),
    )

    ///Services
    ..registerLazySingleton<Auth>(
      () => CustomAuthImpl(
        userRepository: locator(),
      ),
    )
    ..registerLazySingleton(
      () => ThemeService(
        settingsRepository: locator(),
      ),
    )
    ..registerLazySingleton(
      () => LocalizationService(
        settingsRepository: locator(),
      ),
    )

    ///Presentation
    ..registerFactory(
      () => MainViewModel(
        localizationService: locator(),
        themeService: locator(),
        auth: locator(),
      ),
    );
}
