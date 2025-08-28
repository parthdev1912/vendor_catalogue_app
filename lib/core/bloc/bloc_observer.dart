import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor_catalogue_app/core/services/logger_service.dart';
import '../di/service_locator.dart';

class AppBlocObserver extends BlocObserver {
  final LoggerService _logger = serviceLocator<LoggerService>();

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.log('BLOC CREATED: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.log('BLOC EVENT: ${bloc.runtimeType} - ${event.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.log('BLOC CHANGE: ${bloc.runtimeType} - Current: ${change.currentState.runtimeType} - Next: ${change.nextState.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.log(
      'BLOC TRANSITION: ${bloc.runtimeType} - '
          'Event: ${transition.event.runtimeType} - '
          'CurrentState: ${transition.currentState.runtimeType} - '
          'NextState: ${transition.nextState.runtimeType}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.log(
      'BLOC ERROR: ${bloc.runtimeType} - $error',
      level: LogLevel.error,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.log('BLOC CLOSED: ${bloc.runtimeType}');
  }
}