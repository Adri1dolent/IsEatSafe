import 'dart:ffi';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:is_eat_safe/Notifications/custom_notifications.dart';
import 'package:is_eat_safe/models/watchlist_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_utils.dart';

class BackgroundUtils{

  @pragma('vm:entry-point')
  static void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  onHeadlessBackgroundFetch();
  BackgroundFetch.finish(taskId);
  }

  static Future<void> configureBackgroundFetch(SharedPreferences prefs, FlutterLocalNotificationsPlugin fln) async {
    int status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        requiredNetworkType: NetworkType.ANY
    ), (String taskId) async {  // <-- Event callback.
      // This is the fetch-event callback.
      print("[BackgroundFetch] taskId: $taskId");

      // Use a switch statement to route task-handling.
      switch (taskId) {
        case 'com.transistorsoft.customtask':
          print("Received custom task");
          break;
        default:
          print("Default fetch task");
      }
      onBackgroundFetch(prefs,fln);
      // Finish, providing received taskId.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {  // <-- Event timeout callback
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });

// Step 2:  Schedule a custom "oneshot" task "com.transistorsoft.customtask" to execute 5000ms from now.
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "com.transistorsoft.customtask",
        delay: 5000  // <-- milliseconds
    ));
  }


  static Future<void> onBackgroundFetch(SharedPreferences prefs, FlutterLocalNotificationsPlugin fln) async{
    final List<String> items = prefs.getStringList('watchlist_items') ?? [];
    //CustomNotifications.showBigTextNotification(title: "Danger", body: "Un article de votre liste a été rapplé", fln: fln);
    for (var e in items) {
      WatchlistItem item = await ApiUtils.fetchWLItem(e);
      if(item.isRecalled){
        CustomNotifications.showBigTextNotification(title: "Danger", body: "Un article de votre liste a été rappelé", fln: fln);
        return;
      }
    }
  }

  static Future<void> onHeadlessBackgroundFetch() async {
    final prefs = await SharedPreferences.getInstance();
    FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();
    CustomNotifications.initialize(fln);
    onBackgroundFetch(prefs,fln);
  }

}