import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mobiledev_test/core/services/connectivity_service.dart';
import 'package:mobiledev_test/core/services/hive_service.dart';
import 'package:mobiledev_test/core/state/auth_state.dart';
import 'package:mobiledev_test/core/utils/dio_client.dart';
import 'package:mobiledev_test/features/login/services/login_service.dart';

import 'package:mobiledev_test/features/employee/services/employee_service.dart';
import 'package:mobiledev_test/features/employee/repositories/employee_repository.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<Dio>(createDioInstance);
  sl.registerLazySingleton<HiveService>(HiveService.new);
  sl.registerLazySingleton<ConnectivityService>(ConnectivityService.new);
  sl.registerLazySingleton<AuthState>(AuthState.new);

  sl.registerLazySingleton<LoginService>(() => LoginService(dio: sl<Dio>()));

  sl.registerLazySingleton<EmployeeService>(
    () => EmployeeService(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepository(
      service: sl<EmployeeService>(),
      hiveService: sl<HiveService>(),
      connectivity: sl<ConnectivityService>(),
    ),
  );
}
