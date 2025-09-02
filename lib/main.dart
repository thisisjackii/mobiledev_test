import 'package:flutter/material.dart';
import 'package:mobiledev_test/app/app.dart';
import 'package:mobiledev_test/bootstrap.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await bootstrap(() => const App());
}
