import 'package:client_portal_app/src/controllers/BaseController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/views/WorkScopeView.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyProjectWorkController extends BaseController{
  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
   return WorkScopeView();
  }
}