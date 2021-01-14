import 'dart:convert';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/RightDrawerModel.dart';
import 'package:client_portal_app/src/reducers/EventEntryReducer.dart';
import 'package:client_portal_app/src/widgets/EventEntryDetailPanel.dart';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/EventEntry.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class ScheduleView extends StatefulWidget {
  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  ScrollController _scrollController = ScrollController();

  Future<http.Response> upNext() {
    Api api = Api(baseUrl: Config.apiBaseUrl);
    return api.upNext();
  }

  List<Widget> entries(jsonBody, context) {
    List<DateTime> trackDates = [];

    List<Widget> entries = [];

    var reducer =
        EventEntryReducer(payload: List<Map<String, dynamic>>.from(jsonBody));

    reducer.reduce();

    var _sortedModels = reducer.asSplayTreeMap();

    var dates = _sortedModels.keys.toList();

    dates.forEach((date) {
      if (trackDates.contains(date) == false) {
        double _top = 0;

        if (trackDates.length > 0) {
          _top = 25;
        }

        trackDates.add(date);
        entries.add(Container(
          child: Text(_sortedModels[date].first.dateLong),
          margin: EdgeInsets.only(top: _top),
        ));
      }

      _sortedModels[date].forEach((eventEntryModel) {
        entries.add(
          EventEntry(
            model: eventEntryModel,
            onTap: (EventEntry eventEntry) {
              Scaffold.of(context).openEndDrawer();
              ScopedModel.of<RightDrawerModel>(context).setContent(
                EventEntryDetailPanel(
                  eventEntryModel: eventEntryModel,
                ),
              );
            },
          ),
        );
      });
    });

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    var _padding = EdgeInsets.only(top: 60, left: 60, right: 60);
    if (MediaQuery.of(context).size.width < 1024) {
      _padding = EdgeInsets.only(top: 40, left: 30, right: 15);
    }
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, widget, layoutModel) {
        return FutureBuilder(
          future: upNext(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              http.Response response = snapshot.data;
              if (response.statusCode == 200 || response.statusCode == 201) {
                var body = json.decode(response.body.toString());
                var _entries = entries(body, context);
                Widget _viewFullSchedule = Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    hoverColor: Colors.transparent,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/calendar');
                    },
                    child: Text(
                      'VIEW FULL SCHEDULE',
                      style: TextStyle(
                        color: Brand.primary,
                      ),
                    ),
                  ),
                );
                if (_entries.isEmpty) {
                  _viewFullSchedule = SizedBox();
                }
                var _header = Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Upcoming Dates',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _viewFullSchedule,
                  ],
                );
                return Container(
                  constraints: BoxConstraints(maxWidth: 480),
                  padding: _padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: _header,
                        margin: EdgeInsets.only(bottom: 25),
                      ),
                      Expanded(
                        child: Scrollbar(
                          controller: _scrollController,
                          isAlwaysShown: true,
                          child: ListView(
                            padding: EdgeInsets.only(right: 15, bottom: 15),
                            controller: _scrollController,
                            shrinkWrap: true,
                            children: _entries,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Text('api error: ' + response.reasonPhrase);
              }
            }

            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          },
        );
      },
    );
  }
}
