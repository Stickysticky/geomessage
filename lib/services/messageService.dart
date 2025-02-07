import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../tasks/messageTask.dart';

class MessageService {
  static const backgroundChannel = MethodChannel('com.olivier.ettlin.geomessage/background');

  @pragma('vm:entry-point')
  static void startCallback() {
    FlutterForegroundTask.setTaskHandler(MessageTask());
  }

  void startForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
        'This notification appears when the foreground service is running.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000), // Exécution toutes les 5 secondes
        autoRunOnBoot: true, // Optionnel : démarrer automatiquement après le redémarrage du téléphone
        allowWakeLock: true, // Garantir que le service reste actif même en veille
      ),
    );
  }


  static Future<void> startBackgroundProcess() async {
    try {
      await backgroundChannel.invokeMethod('startBackgroundProcess');
    } on PlatformException catch (e) {
      print("Error calling startBackgroundProcess: ${e.message}");
    }
  }

  static Future<void> stopBackgroundProcess() async {
    try {
      await backgroundChannel.invokeMethod('stopBackgroundProcess');
    } on PlatformException catch (e) {
      print("Error calling stopBackgroundProcess: ${e.message}");
    }
  }

  static Future<ServiceRequestResult> startForeGroundProcess() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        notificationIcon: null,
        notificationButtons: [
          const NotificationButton(id: 'btn_hello', text: 'hello'),
        ],
        callback: startCallback,
      );
    }
  }

  static Future<ServiceRequestResult> stopForeGroundProcess() {
    return FlutterForegroundTask.stopService();
  }
}