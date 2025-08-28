import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:vendor_catalogue_app/constants/navigation_helper.dart';
import 'package:vendor_catalogue_app/constants/preference_helper.dart';
import 'package:vendor_catalogue_app/constants/preference_key.dart';
import 'package:vendor_catalogue_app/core/services/logger_service.dart';
import 'package:vendor_catalogue_app/data/services/snackbar_service.dart';


class ApiService {

  final Dio _dio;
  final LoggerService _logger;
  String? _authToken;

  ApiService({LoggerService? logger})
      : _dio = Dio(),
        _logger = logger ?? LoggerService(isEnabled: true) {
    _dio.options.baseUrl = 'https://dummyjson.com';
    _dio.options.connectTimeout = Duration(seconds: 15);
    _dio.options.receiveTimeout = Duration(seconds: 15);
    _dio.options.validateStatus = (status) => status != null && status < 500;
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        _logger.apiError("SSL Verification", "Bypassing certificate verification for host: $host", StackTrace.current);
        return true;
      };
      return client;
    };

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          throw DioException(
            requestOptions: options,
            error: 'No internet connection',
            type: DioExceptionType.connectionError,
          );
        }
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }

        _logger.apiRequest(
          options.method,
          options.uri.toString(),
          options.headers,
          options.data != null ? jsonEncode(options.data) : null,
        );
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.apiResponse(
          response.requestOptions.path,
          response.statusCode ?? 0,
          response.data,
        );
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          _handleUnauthorized();
        }

        _logger.apiError(
          e.requestOptions.path,
          'Dio Error: ${e.message ?? "Unknown error"}, Type: ${e.type}',
          e.stackTrace ?? StackTrace.current,
        );

        return handler.next(e);
      },
    ));
  }

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  void _handleUnauthorized() async {
    clearAuthToken();
    await PreferenceHelper.removePrefValue(key: SharedPreferencesConstants.accessToken);
    NavigationService.navigateToLoginScreen();
    _showSnackbar('Session expired. Please login again.');
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final finalHeaders = {...?headers};

      final response = await _dio.get(
        endpoint,
        options: Options(headers: finalHeaders),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        _handleErrorResponse(endpoint, response);

        String errorMessage = 'Failed with status: ${response.statusCode}';
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          if (responseData.containsKey('message') && responseData['message'] != null) {
            errorMessage = responseData['message'];
          }
        }

        throw ApiException(errorMessage, response.statusCode!);
      }
    } on DioException catch (e) {
      final handledError = _handleDioError(endpoint, e);
      throw handledError;
    } catch (e, stackTrace) {

      if (e is ApiException) {
        rethrow;
      }
      _logger.apiError(endpoint, 'Unexpected error: $e', stackTrace);
      throw ApiException('Network error: $e', 0);
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, {dynamic data, Map<String, String>? headers}) async {
    try {
      final finalHeaders = {...?headers};

      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: finalHeaders),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        _handleErrorResponse(endpoint, response);

        String errorMessage = 'Failed with status: ${response.statusCode}';
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          if (responseData.containsKey('message') && responseData['message'] != null) {
            errorMessage = responseData['message'];
          }
        }

        throw ApiException(errorMessage, response.statusCode!);
      }
    } on DioException catch (e) {
      final handledError = _handleDioError(endpoint, e);
      throw handledError;
    } catch (e, stackTrace) {

      if (e is ApiException) {
        rethrow;
      }
      _logger.apiError(endpoint, 'Unexpected error: $e', stackTrace);
      throw ApiException('Network error: $e', 0);
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, {dynamic data, Map<String, String>? headers}) async {
    try {
      final finalHeaders = {...?headers};

      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(headers: finalHeaders),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        _handleErrorResponse(endpoint, response);

        String errorMessage = 'Failed with status: ${response.statusCode}';
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          if (responseData.containsKey('message') && responseData['message'] != null) {
            errorMessage = responseData['message'];
          }
        }

        throw ApiException(errorMessage, response.statusCode!);
      }
    } on DioException catch (e) {
      final handledError = _handleDioError(endpoint, e);
      throw handledError;
    } catch (e, stackTrace) {

      if (e is ApiException) {
        rethrow;
      }
      _logger.apiError(endpoint, 'Unexpected error: $e', stackTrace);
      throw ApiException('Network error: $e', 0);
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint, {dynamic data, Map<String, String>? headers}) async {
    try {
      final finalHeaders = {...?headers};

      final response = await _dio.delete(
        endpoint,
        data: data,
        options: Options(headers: finalHeaders),
      );

      return response.data;
    } on DioException catch (e) {
      final handledError = _handleDioError(endpoint, e);
      throw handledError;
    } catch (e, stackTrace) {
      _logger.apiError(endpoint, 'Unexpected error: $e', stackTrace);
      throw ApiException('Network error: $e', 0);
    }
  }

  void _handleErrorResponse(String url, Response response) {
    final statusCode = response.statusCode ?? 0;
    String errorMessage;

    switch (statusCode) {
      case 400:
        final requestData = response.requestOptions.data;
        final responseData = response.data;

        errorMessage = 'Bad Request (400)';
        _logger.apiError(
          url,
          'Bad Request (400): ${requestData != null ? "Request: ${jsonEncode(requestData)}" : "No request data"}',
          StackTrace.current,
        );
        if (responseData != null) {
          _logger.apiError(
            url,
            'Response: ${jsonEncode(responseData)}',
            StackTrace.current,
          );
        }
        break;
      case 401:
        if (response.data != null &&
            response.data is Map<String, dynamic> &&
            response.data['message'] == "Unauthorized") {
          errorMessage = 'TOKEN_EXPIRED';
        } else {
          errorMessage = 'Authentication Required';
        }
        _logger.apiError(
          url,
          'Authentication Required (401): ${jsonEncode(response.data)}',
          StackTrace.current,
        );
        _showSnackbar('Login or authentication required');
        break;
      case 500:
        errorMessage = 'Internal Server Error';
        _logger.apiError(
          url,
          'Internal Server Error (500): ${jsonEncode(response.data)}',
          StackTrace.current,
        );
        break;
      default:
        errorMessage = 'HTTP Error: $statusCode';
        _logger.apiError(
          url,
          'Failed with status: $statusCode',
          StackTrace.current,
        );
    }
  }

  ApiException _handleDioError(String url, DioException e) {
    String errorMessage;
    int statusCode = 0;

    if (e.error != null) {
      _logger.apiError(url, 'Error type: ${e.error.runtimeType}, Error: ${e.error}', e.stackTrace ?? StackTrace.current);
    }

    if (e.response != null) {
      statusCode = e.response!.statusCode ?? 0;
      _handleErrorResponse(url, e.response!);

      errorMessage = 'Server responded with status ${e.response!.statusCode}';

      if (e.response!.data != null && e.response!.data is Map<String, dynamic>) {
        final responseData = e.response!.data as Map<String, dynamic>;
        if (responseData.containsKey('message') && responseData['message'] != null) {
          errorMessage = responseData['message'];
        }
      }
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          errorMessage = 'Connection timeout. Please check your internet connection.';
          _showSnackbar(errorMessage);
          break;
        case DioExceptionType.connectionError:
          if (e.error?.toString().contains('No internet connection') == true) {
            errorMessage = 'NO_INTERNET_CONNECTION';
          } else {
            errorMessage = 'No internet connection. Please check your network settings.';
          }
          _showSnackbar('No internet connection. Please check your network settings.');
          break;
        case DioExceptionType.badCertificate:
          errorMessage = 'SSL certificate error. Could not establish secure connection.';
          _showSnackbar(errorMessage);
          break;
        case DioExceptionType.badResponse:
          errorMessage = 'Bad server response. Please try again later.';
          _showSnackbar(errorMessage);
          break;
        case DioExceptionType.cancel:
          errorMessage = 'Request was cancelled';
          break;
        case DioExceptionType.unknown:
        default:
          if (e.error is HandshakeException) {
            errorMessage = 'SSL certificate verification failed. Please check server configuration.';
            _showSnackbar('Connection security error. Please try again later.');
          } else {
            errorMessage = 'Unknown network error: ${e.message ?? "No details available"}';
            _showSnackbar('Connection error. Please try again.');
          }
          break;
      }

      _logger.apiError(
        url,
        'Dio Error Type: ${e.type}, Message: ${e.message ?? "null"}, Error: ${e.error ?? "null"}',
        e.stackTrace ?? StackTrace.current,
      );
    }

    return ApiException(errorMessage, statusCode);
  }

  void _showSnackbar(String message) {
    SnackbarService.show(message);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}

