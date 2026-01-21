import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marriage/core/utils/networking/error/AppException.dart';

/// API Client for making HTTP requests
class ApiClient {
  final http.Client client;
  
  // TODO: Replace with your actual API base URL
  static const String baseUrl = 'https://api.yourapp.com';

  ApiClient({required this.client});

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      final response = await client.get(
        uri,
        headers: _getHeaders(headers),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException('فشل الاتصال بالخادم: ${e.toString()}');
    }
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await client.post(
        uri,
        headers: _getHeaders(headers),
        body: body != null ? json.encode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException('فشل الاتصال بالخادم: ${e.toString()}');
    }
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await client.put(
        uri,
        headers: _getHeaders(headers),
        body: body != null ? json.encode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException('فشل الاتصال بالخادم: ${e.toString()}');
    }
  }

  /// DELETE request
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await client.delete(
        uri,
        headers: _getHeaders(headers),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException('فشل الاتصال بالخادم: ${e.toString()}');
    }
  }

  /// Get default headers
  Map<String, String> _getHeaders(Map<String, String>? headers) {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // TODO: Add authorization token if needed
      // 'Authorization': 'Bearer $token',
    };

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    return defaultHeaders;
  }

  /// Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw ValidationException('خطأ في البيانات المرسلة');
      case 401:
        throw AuthException('غير مصرح لك بالوصول');
      case 403:
        throw AuthException('ليس لديك صلاحية للوصول');
      case 404:
        throw ServerException('الصفحة غير موجودة');
      case 500:
      case 502:
      case 503:
        throw ServerException('خطأ في الخادم، يرجى المحاولة لاحقاً');
      default:
        throw ServerException('حدث خطأ غير متوقع: ${response.statusCode}');
    }
  }
}