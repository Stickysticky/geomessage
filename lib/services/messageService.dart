import 'package:flutter/services.dart';

class MessageService {
  static const backgroundChannel = MethodChannel('com.olivier.ettlin.geomessage/background');

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
}