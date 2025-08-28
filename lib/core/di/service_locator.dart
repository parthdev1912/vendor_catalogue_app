import 'package:get_it/get_it.dart';
import 'package:vendor_catalogue_app/data/repositories/auth_repository.dart';
import 'package:vendor_catalogue_app/data/services/api_service.dart';
import '../services/logger_service.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerSingleton<LoggerService>(
    LoggerService(isEnabled: true),
  );

  serviceLocator.registerSingleton<ApiService>(
    ApiService(logger: serviceLocator<LoggerService>()),
  );

  serviceLocator.registerSingleton<AuthRepository>(
    AuthRepository(serviceLocator<ApiService>()),
  );
}