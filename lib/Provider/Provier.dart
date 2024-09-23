import 'dart:convert';
import 'package:alaram/Model/Model.dart';
import 'package:alaram/Screen/alarm_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../Screen/home.dart';

class alarmprovider extends ChangeNotifier {
  late SharedPreferences preferences;

  List<Model> modelist = [];

  List<String> listofstring = [];

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  late BuildContext context;

  void SetAlaram(String label, String dateTime, bool check, String repeat, int id, int milliseconds) {
    modelist.add(Model(
        label: label,
        dateTime: dateTime,
        check: check,
        when: repeat,
        id: id,
        milliseconds: milliseconds));
    notifyListeners();
  }

  void EditSwitch(int index, bool check) {
    modelist[index].check = check;
    notifyListeners();
  }

  Future<void> GetData() async {
    preferences = await SharedPreferences.getInstance();
    List<String>? cominglist = await preferences.getStringList("data");

    if (cominglist != null) {
      modelist = cominglist.map((e) => Model.fromJson(json.decode(e))).toList();
      notifyListeners();
    }
  }

  void SetData() {
    listofstring = modelist.map((e) => json.encode(e.toJson())).toList();
    preferences.setStringList("data", listofstring);
    notifyListeners();
  }

  Future<void> Inituilize(BuildContext con) async {
    context = con;
    var androidInitilize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = const DarwinInitializationSettings();
    var initilizationsSettings = InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!.initialize(initilizationsSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      debugPrint('notification payload: $payload');

      // Assuming notificationId is embedded in the payload
      final int notificationId = int.tryParse(payload) ?? 0;

      // Navigate to AlarmStopScreen with notificationId
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => AlarmStopScreen(notificationId: notificationId),
        ),
      );
    }
  }

  Future<void> ShowNotification() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin!.show(
      0,
      'plain title',
      'plain body',
      notificationDetails,
      payload: '0', // Example payload, update as per logic
    );
  }

  Future<void> SecduleNotification(DateTime datetim, int Randomnumber) async {
    int newtime = datetim.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    await flutterLocalNotificationsPlugin!.zonedSchedule(
      Randomnumber,
      'Alarm Clock',
      'Your alarm is ringing! scroll for mute',
      tz.TZDateTime.now(tz.local).add(Duration(milliseconds: newtime)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          sound: RawResourceAndroidNotificationSound("alarm"),
          autoCancel: false,
          playSound: true,
          priority: Priority.max,
          importance: Importance.max,
        ),
      ),
      payload: '$Randomnumber', // Set the notification ID as payload
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> CancelNotification(int notificationId) async {
    print('Cancelling notification with ID: $notificationId');
    await flutterLocalNotificationsPlugin!.cancel(notificationId);
  }
}
