import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobiledev_test/features/employee/view/home_page.dart';
import 'package:mobiledev_test/features/welcome/view/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:mobiledev_test/app/routes/routes.dart';
import 'package:mobiledev_test/core/services/service_locator.dart';
import 'package:mobiledev_test/core/state/auth_state.dart';
import 'package:mobiledev_test/features/login/bloc/login_bloc.dart';
import 'package:mobiledev_test/features/login/services/login_service.dart';

import 'package:mobiledev_test/features/employee/bloc/employee_bloc.dart';
import 'package:mobiledev_test/features/employee/repositories/employee_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(loginService: sl<LoginService>()),
        ),

        BlocProvider<EmployeeBloc>(
          create: (context) => EmployeeBloc(sl<EmployeeRepository>()),
        ),
      ],
      child: ChangeNotifierProvider<AuthState>(
        create: (_) => sl<AuthState>(),
        child: Consumer<AuthState>(
          builder: (context, authState, child) {
            return MaterialApp(
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                useMaterial3: true,
              ),

              initialRoute: authState.isAuthenticated
                  ? Routes.home
                  : Routes.welcome,

              onGenerateInitialRoutes: (initialRoute) {
                if (authState.isAuthenticated) {
                  return [
                    MaterialPageRoute(
                      builder: (_) => HomePage(),
                      settings: const RouteSettings(name: Routes.home),
                    ),
                  ];
                }
                return [
                  MaterialPageRoute(builder: (_) => WelcomePage.create()),
                ];
              },
              onGenerateRoute: Routes.generateRoute,
            );
          },
        ),
      ),
    );
  }
}
