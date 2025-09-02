import 'package:mobiledev_test/core/services/connectivity_service.dart';
import 'package:mobiledev_test/core/services/hive_service.dart';
import 'package:mobiledev_test/features/employee/models/employee_model.dart';
import 'package:mobiledev_test/features/employee/services/employee_service.dart';

class EmployeeRepository {
  final EmployeeService _service;
  final HiveService _hiveService;
  final ConnectivityService _connectivity;

  static const String _boxName = 'employeeCacheBox';
  static const String _listKey = 'employeeList';

  EmployeeRepository({
    required EmployeeService service,
    required HiveService hiveService,
    required ConnectivityService connectivity,
  }) : _service = service,
       _hiveService = hiveService,
       _connectivity = connectivity;

  Future<List<Employee>> getEmployees() async {
    if (await _connectivity.isOnline) {
      final employees = await _service.getEmployees();

      await _hiveService.putListAsJsonStringKey<Employee>(
        _boxName,
        _listKey,
        employees,
        (e) => e.toJson(),
      );
      return employees;
    } else {
      return await _hiveService.getListFromJsonStringKey<Employee>(
        _boxName,
        _listKey,
        (json) => Employee.fromJson(json),
      );
    }
  }

  Future<Employee> createEmployee(
    String name,
    String nik,
    String position,
  ) async {
    return await _service.createEmployee({
      'name': name,
      'nik': nik,
      'position': position,
    });
  }

  Future<Employee> updateEmployee(
    String id, {
    String? name,
    String? nik,
    String? position,
  }) async {
    final payload = <String, dynamic>{};
    if (name != null) payload['name'] = name;
    if (nik != null) payload['nik'] = nik;
    if (position != null) payload['position'] = position;
    return await _service.updateEmployee(id, payload);
  }

  Future<void> deleteEmployee(String id) async {
    await _service.deleteEmployee(id);
  }
}
