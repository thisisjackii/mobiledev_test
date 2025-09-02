import 'package:flutter/widgets.dart';

import 'package:mobiledev_test/app/app.dart';
import 'package:mobiledev_test/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await bootstrap(() => const App());
}
