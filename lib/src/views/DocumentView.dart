import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/ContentModel.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/NewMessageView.dart';
import 'package:client_portal_app/src/views/PdfDataView.dart';
import 'package:client_portal_app/src/widgets/PanelScaffold.dart';
import 'package:client_portal_app/src/widgets/PersonAvatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DocumentView extends StatelessWidget {
  Future<List<ContentModel>> _getTeam() async {
    var api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.document();
    List<Map<String, dynamic>> _json =
        List<Map<String, dynamic>>.from(json.decode(response.body));
    return _json.map((e) {
      return ContentModel.fromMap(e);
    }).toList();
  }

  var fileDoc;

  Widget _messageButton(context, PersonModel person) {
    if (person.messagingOptIn == false) {
      return SizedBox();
    }

    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: Brand.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: Text(
        'Message'.toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        if (MediaQuery.of(context).size.width >= 1024) {
          Navigator.pushNamed(context, '/new-message', arguments: person);
        } else {
          Navigator.push(
            context,
            SlideUpRoute(
              settings: RouteSettings(arguments: person),
              page: PanelScaffold(
                title: 'New Message',
                body: NewMessageView(),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var padding = EdgeInsets.only(top: 20);

          return Padding(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var padding = EdgeInsets.all(15);
                if (MediaQuery.of(context).size.width >= 1024) {
                  padding = padding.copyWith(left: 0, right: 0);
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
                        IconButton(
                            onPressed: null,
                            icon: FaIcon(FontAwesomeIcons.file)),
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
                  onTap: () async {
                    if (MediaQuery.of(context).size.width >= 1024) {
                      Navigator.pushNamed(context, '/new-message',
                          arguments: 'person');
                    } else {
                      //  var doc = await _getTeamV2(snapshot.data[index]?.file);
                      Navigator.push(
                        context,
                        SlideUpRoute(
                          settings: RouteSettings(arguments: 'person'),
                          page: PdfDataView(
                            pdfName: snapshot?.data[index]?.file.toString(),
                            onGetFile: (doc) {
                              // setState(() {
                              //   fileDoc = doc;
                              // });
                            },
                          ),


                          // PanelScaffold(
                          //   needPrintAction: true,
                          //   title: snapshot?.data[index]?.title.toString(),
                          //   //document: fileDoc, //snapshot.data[index],
                          //   body: PdfDataView(
                          //     pdfName: snapshot?.data[index]?.file.toString(),
                          //     onGetFile: (doc) {
                          //       // setState(() {
                          //       //   fileDoc = doc;
                          //       // });
                          //     },
                          //   ),
                          // ),
                        ),
                      );
                    }
                  },
                );
              },
              itemCount: snapshot.data.length,
            ),
            padding: padding,
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      },
      future: _getTeam(),
    );
  }

  dynamic _getTeamV2(doc) async {
    var api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.fileContent(doc);
    return response.bodyBytes;
  }
}
