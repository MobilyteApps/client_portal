import 'dart:async';

import 'package:client_portal_app/src/AppMain.dart';
import 'package:client_portal_app/src/models/ProjectModel.dart';
import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:sentry/sentry.dart';

final SentryClient sentry =
    new SentryClient(SentryOptions(dsn: Config.sentryDSN));

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console.
  print('Caught error: $error');
  if (isInDebugMode) {
    // Print the full stacktrace in debug mode.
    print(stackTrace);
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode.
    sentry.captureException(
      error,
      stackTrace: stackTrace,
    );
  }
}

void main() async {
  FlutterError.onError = (details, {bool forceReport = false}) {
    _reportError(details.exception, details.stack);
  };
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    if (kIsWeb == false) {
      final appDocumentDirectory =
          await pathProvider.getApplicationDocumentsDirectory();

      Hive.init(appDocumentDirectory.path);
    }
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ProjectModelAdapter());
    const bool isProduction = bool.fromEnvironment('dart.vm.product');
    if (isProduction) {
      Config.setIsProduction();
    }

    print('-----' + Config.apiBaseUrl + '------');
    runApp(AppMain());
  }, (Object error, StackTrace stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    _reportError(error, stackTrace);
  });
}
