import 'package:client_portal_app/src/models/ProjectModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'src/models/UserModel.dart';
import 'src/utils/Config.dart';
import 'src/AppMain.dart';

void main() async {
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
  runApp(AppMain());
}
