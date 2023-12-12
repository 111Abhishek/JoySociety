import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Helper {
  static String getDateTime(inputDateTime) {
    tz.initializeTimeZones();

    DateTime dateTime = DateTime.parse(inputDateTime);

    // Convert to Eastern Standard Time (EST)
    var estLocation = tz.getLocation('US/Eastern');
    var estDateTime = tz.TZDateTime.from(dateTime, estLocation);

    // Format the date and time
    DateFormat dateFormat = DateFormat.MMMd().addPattern(" • hh:mm a");
    String formattedDateTime = dateFormat.format(estDateTime);

    // Combine the formatted date and time with the time zone
    String finalDateTime = '$formattedDateTime EST';

    return finalDateTime;
  }
}
