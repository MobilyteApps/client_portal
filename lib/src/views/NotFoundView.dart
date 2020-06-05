import 'package:client_portal_app/src/Brand.dart';
import 'package:flutter/material.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Opacity(
              child: Image.asset('images/logo.png'),
              opacity: .3,
            ),
            Text(
              '404',
              style:
                  TextStyle(fontSize: 90, color: Colors.black.withOpacity(.5)),
            ),
            Text(
              'Page not found.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/');
              },
              child: Text(
                'return home',
                style: TextStyle(
                  color: Brand.primary,
                  height: 1,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
