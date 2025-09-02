import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobiledev_test/features/employee/models/employee_model.dart';

class EmployeeApiException implements Exception {
  final String message;
  final int? statusCode;
  EmployeeApiException(this.message, {this.statusCode});

  @override
  String toString() => 'EmployeeApiException: $message (Status: $statusCode)';
}

class EmployeeService {
  final Dio _dio;

  final String _baseUrl = 'https://63a167d8a543280f775561e5.mockapi.io/flutter';

  EmployeeService({required Dio dio}) : _dio = dio;

  Future<List<Employee>> getEmployees() async {
    try {
      final response = await _dio.get(_baseUrl);

      if (response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        debugPrint(
          "[EmployeeService-GET List] Respons terdeteksi sebagai Map terbungkus.",
        );
        final List<dynamic> employeeListJson = response.data['data'];
        return employeeListJson.map((json) => Employee.fromJson(json)).toList();
      } else if (response.data is List) {
        debugPrint(
          "[EmployeeService-GET List] Respons terdeteksi sebagai List langsung.",
        );
        final List<dynamic> data = response.data;
        return data.map((json) => Employee.fromJson(json)).toList();
      } else {
        throw EmployeeApiException(
          'Struktur respons API untuk daftar employee tidak terduga.',
        );
      }
    } on DioException catch (e) {
      throw EmployeeApiException(
        e.response?.data?['message']?.toString() ??
            e.message ??
            'Gagal mengambil data pegawai',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw EmployeeApiException('Gagal memproses data pegawai: $e');
    }
  }

  Future<Employee> getEmployeeDetail(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/$id');

      if (response.data is Map<String, dynamic> &&
          response.data['data'] is Map<String, dynamic>) {
        debugPrint(
          "[EmployeeService-GET Detail] Respons terdeteksi sebagai Map terbungkus.",
        );
        final Map<String, dynamic> employeeJson = response.data['data'];
        return Employee.fromJson(employeeJson);
      } else if (response.data is Map<String, dynamic>) {
        debugPrint(
          "[EmployeeService-GET Detail] Respons terdeteksi sebagai Map (objek) langsung.",
        );
        return Employee.fromJson(response.data);
      } else {
        throw EmployeeApiException(
          'Struktur respons detail API tidak terduga.',
        );
      }
    } on DioException catch (e) {
      throw EmployeeApiException(
        e.response?.data?['message']?.toString() ??
            e.message ??
            'Gagal mengambil detail pegawai',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw EmployeeApiException('Gagal memproses detail pegawai: $e');
    }
  }

  Future<Employee> createEmployee(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.post(_baseUrl, data: payload);

      return Employee.fromJson(response.data);
    } on DioException catch (e) {
      throw EmployeeApiException(
        e.response?.data?['message']?.toString() ??
            e.message ??
            'Gagal membuat pegawai',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Employee> updateEmployee(
    String id,
    Map<String, dynamic> payload,
  ) async {
    try {
      await _dio.put('$_baseUrl/$id', data: payload);

      return await getEmployeeDetail(id);
    } on DioException catch (e) {
      throw EmployeeApiException(
        e.response?.data?['message']?.toString() ??
            e.message ??
            'Gagal mengubah data pegawai',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await _dio.delete('$_baseUrl/$id');
    } on DioException catch (e) {
      throw EmployeeApiException(
        e.response?.data?['message']?.toString() ??
            e.message ??
            'Gagal menghapus pegawai',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
