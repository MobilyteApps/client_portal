import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentView extends StatelessWidget {
  final String html;

  const ContentView({Key key, this.html}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _padding = EdgeInsets.only(top: 10, left: 20, right: 20);
    if (MediaQuery.of(context).size.width < 1024) {
      _padding = EdgeInsets.all(12);
    }
    return SingleChildScrollView(
      padding: _padding,
      child: _html(context),
    );
  }

  Widget _html(context) {
    return Html(
      data: """
        ${html}
      """,
      //Optional parameters:
      onLinkTap: (url, _, __, ___) {
        // open url in a webview
        canLaunch(url).then((value) {
          launch(url);
        });
      },
      style: {
        "div": Style(),
        "p": Style(),
        "ul": Style(
          textDecorationColor: Colors.white,
          backgroundColor: kIsWeb && MediaQuery.of(context).size.width >= 1024
              ? Colors.transparent
              : Colors.white,
            letterSpacing: 0,
            margin:EdgeInsets.all(1.0)
            // margin: EdgeInsets.all(2), letterSpacing: 0
        )
      },
      onImageTap: (src, _, __, ___) {
        // Display the image in large form.
        print(">>>>>Hello>>>>>>>$src");
      },
    );
  }
}
