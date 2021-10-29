import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentView extends StatelessWidget {
  final String html;
  const ContentView({Key key, this.html}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _padding = EdgeInsets.only(top: 10, left: 60, right: 30);
    if (MediaQuery.of(context).size.width < 1024) {
      _padding = EdgeInsets.all(20);
    }
    return SingleChildScrollView(
      padding: _padding,
      child: _html(),
    );
  }

  Widget _html() {
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
      style: {"div": Style(), "p": Style(), "ul":Style(textDecorationColor: Colors.white,backgroundColor: Colors.white)},
       onImageTap: (src, _, __, ___) {
        // Display the image in large form.
        //print(src);
      },
    );
  }
}
