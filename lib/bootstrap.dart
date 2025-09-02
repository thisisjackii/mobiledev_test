import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobiledev_test/core/services/service_locator.dart';
import 'package:mobiledev_test/core/state/auth_state.dart';

Future<void> _openAllHiveBoxes() async {
  await Hive.openBox<String>('secureBox');
  await Hive.openBox<String>('employeeCacheBox');
  debugPrint('All Hive boxes opened globally for the test.');
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await Hive.initFlutter();
  await _openAllHiveBoxes();
  debugPrint('Hive initialized.');

  setupServiceLocator();
  debugPrint('Service Locator (GetIt) setup.');

  if (sl.isRegistered<AuthState>()) {
    await sl<AuthState>().tryAutoLogin();
  }

  runApp(await builder());
}

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
