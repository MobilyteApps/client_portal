import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:scoped_model/scoped_model.dart';

class PushNotificationHandler extends StatefulWidget {
  const PushNotificationHandler({Key key, this.child, this.platform})
      : super(key: key);
  final Widget child;
  final TargetPlatform platform;

  @override
  _PushNotificationHandlerState createState() =>
      _PushNotificationHandlerState();
}

class _PushNotificationHandlerState extends State<PushNotificationHandler> {
  LayoutModel model;

  final api = Api(baseUrl: Config.apiBaseUrl);

  @override
  void initState() {
    super.initState();

    model = ScopedModel.of<LayoutModel>(context);
    if (widget.platform == TargetPlatform.android ||
        widget.platform == TargetPlatform.iOS) {
      _initPushNotificationSupport();
    }
  }

  void _initPushNotificationSupport() {
    print('init firebase messaging');

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMsg) {
      Map<String, dynamic> message = remoteMsg.data;

      try {
        print("onMessage: ${message}");
        String title = '';
        String body = '';
        if (message['notification'] != null) {
          title = message['notification']['title'];
          body = message['notification']['body'];
        } else {
          title = message['aps']['alert']['title'];
          body = message['aps']['alert']['body'];
        }
        var snackbar = SnackBar(
          duration: Duration(minutes: 60),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              model.scaffoldKey.currentState.hideCurrentSnackBar();
            },
          ),
          backgroundColor: Colors.grey.shade200,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                body,
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
        );
        model.scaffoldKey.currentState.showSnackBar(snackbar);
      } catch (error) {
        print(error);
      }
    });

// resume and pause notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // stub (not implemented)
    });
    // model.firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     try {
    //       print("onMessage: $message");
    //       String title = '';
    //       String body = '';
    //       if (message['notification'] != null) {
    //         title = message['notification']['title'];
    //         body = message['notification']['body'];
    //       } else {
    //         title = message['aps']['alert']['title'];
    //         body = message['aps']['alert']['body'];
    //       }
    //       var snackbar = SnackBar(
    //         duration: Duration(minutes: 60),
    //         action: SnackBarAction(
    //           label: 'Dismiss',
    //           onPressed: () {
    //             model.scaffoldKey.currentState.hideCurrentSnackBar();
    //           },
    //         ),
    //         backgroundColor: Colors.grey.shade200,
    //         content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               title,
    //               style: TextStyle(
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.black,
    //               ),
    //             ),
    //             Text(
    //               body,
    //               style: TextStyle(
    //                 color: Colors.black,
    //               ),
    //             )
    //           ],
    //         ),
    //       );
    //       model.scaffoldKey.currentState.showSnackBar(snackbar);
    //     } catch (error) {
    //       print(error);
    //     }

    //     // show a snackbar
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     // stub (not implemented)
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     // stub (not implemented)
    //   },
    // );

    // model.firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(
    //     sound: true,
    //     badge: true,
    //     alert: true,
    //     provisional: true,
    //   ),
    // );

    model.firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: true);

    // model.firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) async {
    //   String fcmToken = await model.firebaseMessaging.getToken();
    //   _saveDeviceToken(fcmToken);
    // });

    model.firebaseMessaging.onTokenRefresh.listen((token) {
      _saveDeviceToken(token);
    });
  }

  void _saveDeviceToken(String token) async {
    try {
      model.saveDeviceToken();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return widget.child;
      },
    );
  }
}
