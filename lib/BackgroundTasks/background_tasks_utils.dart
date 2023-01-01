import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:is_eat_safe/Notifications/custom_notifications.dart';
import 'package:is_eat_safe/models/watchlist_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_utils.dart';

class BackgroundUtils {
  @pragma('vm:entry-point')
  static void backgroundFetchHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      BackgroundFetch.finish(taskId);
      return;
    }
    onHeadlessBackgroundFetch();
    BackgroundFetch.finish(taskId);
  }

  static Future<void> configureBackgroundFetch(
      SharedPreferences prefs, FlutterLocalNotificationsPlugin fln) async {
    await BackgroundFetch.configure(
        BackgroundFetchConfig(minimumFetchInterval: 15), (String taskId) async {
      // <-- Event callback.
      print(" ========= ici =======");
      onBackgroundFetch(prefs, fln);
      print("Default fetch task");

      // Finish, providing received taskId.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Event timeout callback
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });

    /*BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "com.transistorsoft.fetch",
        delay: 5000  // <-- milliseconds
    ));*/
  }

  static Future<void> onBackgroundFetch(
      SharedPreferences prefs, FlutterLocalNotificationsPlugin fln) async {
    final List<String> items = prefs.getStringList('watchlist_items') ?? [];

    for (var e in items) {
      WatchlistItem item = await ApiUtils.fetchWLItem(e);
      if (item.isRecalled) {
        CustomNotifications.showBigTextNotification(
            title: "Danger",
            body: "Un article de votre liste a été rappelé",
            fln: fln);
        return;
      }
    }
  }

  static Future<void> onHeadlessBackgroundFetch() async {
    final prefs = await SharedPreferences.getInstance();
    FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();
    CustomNotifications.initialize(fln);
    onBackgroundFetch(prefs, fln);
  }
}
