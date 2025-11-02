import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Base response model for API calls
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(
      success: true,
      data: data,
      message: 'Success',
      statusCode: 200,
    );
  }

  factory ApiResponse.error(String message, [int? statusCode]) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}

/// Base API service for handling HTTP requests
class ApiService {
  final http.Client _client;
  final Duration _timeout;

  ApiService({
    http.Client? client,
    Duration timeout = const Duration(seconds: 10),
  }) : _client = client ?? http.Client(),
       _timeout = timeout;

  /// GET request
  Future<ApiResponse<Map<String, dynamic>>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .get(uri, headers: headers)
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('Tidak ada koneksi internet', 0);
    } on HttpException {
      return ApiResponse.error('Terjadi kesalahan pada server', 500);
    } on FormatException {
      return ApiResponse.error('Format respons tidak valid', 400);
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}', 500);
    }
  }

  /// POST request
  Future<ApiResponse<Map<String, dynamic>>> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('Tidak ada koneksi internet', 0);
    } on HttpException {
      return ApiResponse.error('Terjadi kesalahan pada server', 500);
    } on FormatException {
      return ApiResponse.error('Format respons tidak valid', 400);
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}', 500);
    }
  }

  /// Handle HTTP response
  ApiResponse<Map<String, dynamic>> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(data);
      } else {
        return ApiResponse.error(
          data['message']?.toString() ?? 'Terjadi kesalahan',
          response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'Gagal memproses respons server',
        response.statusCode,
      );
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}
