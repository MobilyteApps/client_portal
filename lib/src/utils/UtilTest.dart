import 'dart:collection';

import 'package:client_portal_app/src/models/EventEntryModel.dart';
import 'package:table_calendar/table_calendar.dart';


/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.





   final kEvents = LinkedHashMap<DateTime, List<EventEntryModel>>(
     equals: isSameDay,
     hashCode: getHashCode,
   )..addAll(_kEventSource);
   final _kEventSource = Map.fromIterable(List.generate(10, (index) => index),
    key: (item) => item,
    value: (item) => List<EventEntryModel>.generate(
        item % 4 + 1, (index) => EventEntryModel()))
  ..addAll({
    kToday: [
      EventEntryModel(),
      EventEntryModel(),
    ],
  });



int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 120, kToday.day);
