import 'package:intl/intl.dart';

class FormatDate {
  var arMonth = DateFormat.yMMM('ar');
  var enMonth = DateFormat.yMMM('en');
  var arFull = DateFormat.yMMMEd('ar');
  var enFull = DateFormat.yMMMEd('en');

  getArDate(DateTime dateTime) {
    return arMonth.format(dateTime);
  }

  getEnDate(DateTime dateTime) {
    return enMonth.format(dateTime);
  }

  getArFull(DateTime dateTime) {
    return arFull.format(dateTime);
  }

  getEnFull(DateTime dateTime) {
    return enFull.format(dateTime);
  }
}
