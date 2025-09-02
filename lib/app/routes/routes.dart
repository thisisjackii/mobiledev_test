import 'package:flutter/material.dart';
import 'package:mobiledev_test/features/login/view/login_page.dart';
import 'package:mobiledev_test/features/welcome/view/welcome_page.dart';
import 'package:mobiledev_test/features/employee/view/home_page.dart';
import 'package:mobiledev_test/features/employee/view/employee_form_page.dart';
import 'package:mobiledev_test/features/employee/models/employee_model.dart';

class Routes {
  static const welcome = '/';
  static const login = '/login';
  static const home = '/home';
  static const employeeForm = '/employee-form';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(
          builder: (_) => WelcomePage.create(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case employeeForm:
        final employee = settings.arguments as Employee?;
        return MaterialPageRoute(
          builder: (_) => EmployeeFormPage(employee: employee),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
