import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class ContentView extends StatelessWidget {
  final String html;
  const ContentView({Key key, this.html}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _padding = EdgeInsets.only(top: 30, left: 60, right: 60);
    if (MediaQuery.of(context).size.width < 1024) {
      _padding = EdgeInsets.all(20);
    }
    return Scrollbar(
      child: SingleChildScrollView(
        padding: _padding,
        child: _html(),
      ),
    );
  }

  Widget _html() {
    return Html(
      data: """
        ${html}
      """,
      //Optional parameters:
      onLinkTap: (url) {
        // open url in a webview
        print(url);
      },
      style: {"div": Style(), "p": Style()},
      onImageTap: (src) {
        // Display the image in large form.
        print(src);
      },
    );
  }
}
