import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:mobiledev_test/app/routes/routes.dart';
import 'package:mobiledev_test/core/services/service_locator.dart';
import 'package:mobiledev_test/core/state/auth_state.dart';
import 'package:mobiledev_test/features/login/bloc/login_bloc.dart';
import 'package:mobiledev_test/features/login/services/login_service.dart';
import 'package:mobiledev_test/features/employee/bloc/employee_bloc.dart';
import 'package:mobiledev_test/features/employee/repositories/employee_repository.dart';
import 'package:mobiledev_test/main.dart';

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
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),

      builder: (context, child) {
        return AuthStateListener(child: child!);
      },

      onGenerateInitialRoutes: (initialRoute) {
        final authState = context.read<AuthState>();
        if (authState.isLoading) {
          return [
            MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            ),
          ];
        }
        final route = authState.isAuthenticated ? Routes.home : Routes.welcome;
        return [Routes.generateRoute(RouteSettings(name: route))];
      },
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

class AuthStateListener extends StatefulWidget {
  final Widget child;
  const AuthStateListener({super.key, required this.child});

  @override
  State<AuthStateListener> createState() => _AuthStateListenerState();
}

class _AuthStateListenerState extends State<AuthStateListener> {
  late final AuthState _authState;
  bool _isInitialCheck = true;

  @override
  void initState() {
    super.initState();
    _authState = context.read<AuthState>();
    _authState.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authState.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (_authState.isLoading) return;

    if (_isInitialCheck) {
      _isInitialCheck = false;
      _performRedirect();
      return;
    }

    _performRedirect();
  }

  void _performRedirect() {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    final newRoute = _authState.isAuthenticated ? Routes.home : Routes.login;

    navigator.pushNamedAndRemoveUntil(newRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
