import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomNotifications{

  static Future initialize(FlutterLocalNotificationsPlugin fln) async {
    var androidInit = const AndroidInitializationSettings('mipmap/ic_launcher'); //App icon is automatically replaced due to flutter_launcher_icon plugin
    var iosInit = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit);
    await fln.initialize(initSettings);
  }

  static Future showBigTextNotification({required String title, required String body, required FlutterLocalNotificationsPlugin fln
  } ) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      'watchlist_warning',
      'iseatsafe_channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails()
    );
    await fln.show(0, title, body, not);
  }

}