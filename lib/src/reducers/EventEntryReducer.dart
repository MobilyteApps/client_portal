import 'dart:collection';

import 'package:client_portal_app/src/models/EventEntryModel.dart';
import 'package:flutter/material.dart';

class EventEntryReducer {
  EventEntryReducer({@required this.payload});

  List<Map<String, dynamic>> payload;

  Map<DateTime, List<EventEntryModel>> _entryModels = {};

  Map<DateTime, List<EventEntryModel>> reduce() {
    payload.forEach((entry) {
      EventEntryModel eventEntryModel = EventEntryModel.fromJson(entry);

      eventEntryModel.sequence().forEach((seq) {
        DateTime ymd = DateTime.parse(seq.ymd());
        if (_entryModels.containsKey(ymd) == false) {
          _entryModels[ymd] = [];
        }
        _entryModels[ymd].add(seq);
      });
    });

    return _entryModels;
  }

  SplayTreeMap<DateTime, List<EventEntryModel>> asSplayTreeMap() {
    return SplayTreeMap.from(_entryModels);
  }
}
