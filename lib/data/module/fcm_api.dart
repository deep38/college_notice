import 'dart:convert';
import 'dart:io';

import 'package:college_notice/data/models/notice.dart';
import 'package:college_notice/screens/notice_view_page.dart';
import 'package:college_notice/utils/global.dart';
import 'package:college_notice/utils/private_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

String convertPayloadToJsonString(String payload) {
  if(payload.length < 2) return payload;
  payload = payload.substring(1, payload.length - 1);
  String jsonString = "{";
  List<String> keyValuePairs = payload.split(',');

  for (var keyValuePair in keyValuePairs) {
    int index = keyValuePair.indexOf(':');
    String key = keyValuePair.substring(0, index).trim();
    String value = keyValuePair.substring(index + 1).trim();
    if(key == 'dateTime') {
      jsonString += '"$key":$value,';
    } else {
      jsonString += '"$key":"$value",';
    }
  }

  jsonString = jsonString.substring(0, jsonString.length - 1);
  jsonString += "}";

  return jsonString;
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {}

class FcmApi {
  static BuildContext? context;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    await initializeLocalNotifications();
    await onMessage();
  }

  Future<void> initializeLocalNotifications() async {
    const InitializationSettings initSettings = InitializationSettings(
        android: AndroidInitializationSettings("@drawable/ic_launcher"),
        iOS: DarwinInitializationSettings());

    /// on did receive notification response = for when app is opened via notification while in foreground on android
    await _localNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: onNotificationTap);

    /// need this for ios foregournd notification
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future<void> onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (Platform.isAndroid) {
        // if this is available when Platform.isIOS, you'll receive the notification twice
        await _localNotificationsPlugin.show(
          0,
          message.notification!.title,
          message.notification!.body,
          platformChannelSpecifics,
          payload: message.data.toString(),
        );
      }
    });
  }

  final NotificationDetails platformChannelSpecifics =
      const NotificationDetails(
    android: AndroidNotificationDetails(
      "high_importance_channel",
      "High Importance Notifications",
      priority: Priority.max,
      importance: Importance.max,
    ),
  );

  void onNotificationTap(NotificationResponse response) {
    // debugPrint(response.);
    debugPrint("Notification payload ${response.payload}");
    debugPrint("Context ${FcmApi.context}");
    if (FcmApi.context != null) {
      try {
        debugPrint(json.decode(json.encode(response.payload!)));
      } on Exception catch (e) {
        debugPrint(e.toString());
      } finally {
        debugPrint("Context finaly");
      }
      try {
        debugPrint("Trying to go to notice view...");
        String jsonString = convertPayloadToJsonString(response.payload!);
        debugPrint(jsonString);
        Notice notice = Notice.fromJson(jsonString);
        debugPrint("$notice");
        goTo(FcmApi.context!, NoticeView(notice: notice));
        debugPrint("Went to notice view");
      } on Exception catch (e) {
        debugPrint("GoTo error: $e");
      } finally {
        debugPrint("Go to finaly");
      }
    }
    debugPrint("Done");
  }

  Future<void> sendNotificationToTopic(
      String id, String topic, String title, String body) async {
    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmApiKey',
    };

    // FirebaseMessaging.instance.sendMessage(
    //   to: '/topic/$topic',
    //   data: 
    // );
    final Map<String, dynamic> data = {
      'notification': {
        'title': title,
        'body': body,
      },
      'data': {
        'id': id,
        'title': title,
        'content': body,
        'dateTime': DateTime.now().millisecondsSinceEpoch,
        'subject': topic,
      },
      'to': "/topics/$topic",
    };

    final http.Response response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      debugPrint('Notification sent successfully');
    } else {
      debugPrint('Failed to send notification. Error: ${response.body}');
    }
  }
}
