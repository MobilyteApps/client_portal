import 'package:client_portal_app/src/views/ResetPassordView.dart';
import 'package:client_portal_app/src/widgets/SplitLayout.dart';
import 'package:flutter/src/widgets/framework.dart';

class ResetPasswordController extends StatelessWidget {
  const ResetPasswordController({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplitLayout(
      child: ResetPasswordView(),
    );
  }
}
