import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/models/ContentModel.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/PdfDataView.dart';
import 'package:client_portal_app/src/widgets/PanelScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DocumentController extends ResponsiveController {
  DocumentController({
    Key key,
    String panelLayoutTitle,
    bool panelCenterTitle = false,
    IconData appBarIcon,
  }) : super(
      panelLayoutTitle: panelLayoutTitle,
      panelCenterTitle: panelCenterTitle,
      appBarIcon: appBarIcon);


  final _api = Api(baseUrl: Config.apiBaseUrl);

  Future<List<ContentModel>> _getDocument() async {
    var response = await _api.document();
    List<Map<String, dynamic>> _json =
    List<Map<String, dynamic>>.from(json.decode(response.body));
    return _json.map((e) {
      return ContentModel.fromMap(e);
    }).toList();
  }


  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          EdgeInsets titlePadding =
          EdgeInsets.only(top: 30, left: 30, right: 30);
          var padding = EdgeInsets.all(20);

          if (MediaQuery.of(context).size.width >= 1024) {
            titlePadding = titlePadding.copyWith(left: 60, right: 60, top: 50);
          }

          return ListView(
            children: [
              Container(
                child: Text(
                  'Documents',
                  style: Theme.of(context).textTheme.headline6,
                ),
                padding: titlePadding,
              ),
              Padding(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var padding = EdgeInsets.all(15);
                    if (MediaQuery.of(context).size.width >= 1024) {
                      padding = padding.copyWith(left: 30, right: 0);
                    }
                    return InkWell(
                      child: Container(
                        padding: padding,
                        decoration: BoxDecoration(
                            border: BorderDirectional(
                                bottom: BorderSide(
                                    color: Colors.black.withOpacity(.12)))),
                        child: Row(
                          children: <Widget>[
                            //  _avatar(context, snapshot.data[index]),//snapshot?.data[index]?.icon
                            IconButton(onPressed: null, icon: FaIcon(FontAwesomeIcons.file)),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  // Text(snapshot?.data[index]?.slug),
                                  Text(snapshot?.data[index]?.title),
                                ],
                              ),
                            ),
                            // _messageButton(context, snapshot?.data[index]),
                          ],
                        ),
                      ),
                      onTap: (){
                        if (MediaQuery.of(context).size.width >= 1024) {
                          Navigator.pushNamed(context, '/pdf-content-view', arguments: snapshot?.data[index]?.file.toString());
                        } else {
                          Navigator.push(
                            context,
                            SlideUpRoute(
                              settings: RouteSettings(arguments: 'person'),
                              page: PanelScaffold(
                                title: 'Document',
                                body: PdfDataView(pdfName:snapshot?.data[index]?.file.toString()),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                  itemCount: snapshot.data.length,
                ),
                padding: padding,
              )
            ],
          );
        }

        return Container(
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      },
      future: _getDocument(),
    );
  }
}
