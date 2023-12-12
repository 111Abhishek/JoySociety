import 'package:joy_society/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  Future<String?> getAuthorizationKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(AppConstants.TOKEN) as String?;
  }

  Future<List<String>?> getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("notificationsData");
  }

  Future setNotificationItems(List<String> notifications) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("notificationsData", notifications);
  }
}
