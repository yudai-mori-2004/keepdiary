import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../../main.dart';
import '../../screen/settings_screen.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

int _selectedValue=0;

class NotificationSetting extends HookConsumerWidget {
  NotificationSetting({Key? key}) : super(key: key);
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const appBarHeight = 60.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textString = AppLocalizations.of(context);
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: ref.watch(theme1Provider),
        body:
        SizedBox(
            height: deviceHeight,
            child: Column(
                children: [
                  CustomScrollView(
                      shrinkWrap: true,
                      primary: false,
                      slivers: [
                        SliverAppBar(
                          backgroundColor: Colors.blueAccent.withOpacity(0.3),
                          floating: true,
                          pinned: true,
                          snap: false,
                          expandedHeight: appBarHeight,
                          toolbarHeight: appBarHeight,
                          leading: BackButton(
                            color: ref.watch(
                                appBarTitleColorProvider), // <-- SEE HERE
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                                '${textString?.notification}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ref.watch(appBarTitleColorProvider),
                                  fontSize: 24,
                                  fontWeight: FontWeight
                                      .w400,
                                  fontFamily: 'f${ref.watch(
                                      fontIndexProvider)}',)
                            ),
                            background: SizedBox(
                              width: double.infinity,
                              child:
                              File(ref.watch(appBarImagePath)).existsSync()
                                  ? Image.file(
                                File(ref.watch(appBarImagePath)),
                                fit: BoxFit.cover,)
                                  : Image.asset(
                                ref.watch(appBarImageDefaultPath),
                                fit: BoxFit.cover,),
                            ),
                          ),
                        )
                      ]),
                  const SizedBox(height: 20,),
                  SwitchListTile(
                    title: Text('${textString?.notification}',style: TextStyle(color: ref.watch(theme4Provider)),),
                    value: ref.watch(notificationEnabled),
                    activeColor: ref.watch(theme6Provider),
                    onChanged: (b) async {
                      if(b){
                        await _cancelNotification();
                        await _requestPermissions();
                        _registerMessage(hour: ref.watch(notificationTimeProvider), minutes: 0, message: '${textString?.restore_yourself}', context: context);
                      }else{
                        await _cancelNotification();
                      }
                      ref
                          .watch(notificationEnabled.notifier)
                          .state = b;
                    },
                    secondary: Icon(Icons.notifications,color: ref.watch(theme3Provider),),
                  ),
                  SizedBox(
                      height: 60,
                      child:
                      DropdownButton(
                        dropdownColor: ref.watch(theme1Provider),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)),
                        value: ref.watch(notificationTimeProvider),
                        items:  [
                          DropdownMenuItem(
                            value: 0,
                            child: Text('0:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text('1:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('2:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('3:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text('4:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text('5:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 6,
                            child: Text('6:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 7,
                            child: Text('7:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 8,
                            child: Text('8:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 9,
                            child: Text('9:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 0,
                            child: Text('0:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 11,
                            child: Text('11:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 12,
                            child: Text('12:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 13,
                            child: Text('13:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 14,
                            child: Text('14:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 15,
                            child: Text('15:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 16,
                            child: Text('16:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 17,
                            child: Text('17:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 18,
                            child: Text('18:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 19,
                            child: Text('19:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 20,
                            child: Text('20:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 21,
                            child: Text('21:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 22,
                            child: Text('22:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 23,
                            child: Text('23:00',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                        ],
                        onChanged: (value) async {
                          _selectedValue = value!;
                          if(ref.watch(notificationEnabled)){
                            await _cancelNotification();
                            await _requestPermissions();
                            _registerMessage(hour: _selectedValue, minutes: 0, message: '${textString?.restore_yourself}', context: context);
                          }else{
                            await _cancelNotification();
                          }
                          ref
                              .watch(notificationTimeProvider.notifier)
                              .state = int.parse(value.toString());
                          settingData.notificationTimeProvider=int.parse(value.toString());
                          settingDataBox.put(settingDataBoxName, settingData);
                        },
                      )
                  ),
                ]
            )
        )
    );
  }

  Future<void> _init() async {
    await _configureLocalTimeZone();
    await _initializeNotification();
  }

  Future<void> _configureLocalTimeZone() async {
    initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    setLocalLocation(getLocation(timeZoneName));
  }

  Future<void> _initializeNotification() async {
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('diary_icon');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _registerMessage({
    required int hour,
    required int minutes,
    required message,
    required BuildContext context
  }) async {
    final textString = AppLocalizations.of(context);
    final TZDateTime now = TZDateTime.now(local);
    for (int i = 0; i < 10; i++) {
      TZDateTime scheduledDate = TZDateTime(
        local,
        now.year,
        now.month,
        now.day+i,
        hour,
        minutes,
      );
      final Int64List vibrationPattern = Int64List(2);
      vibrationPattern[0] = 0;
      vibrationPattern[1] = 200;
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '${textString?.time_for_diary}',
        message,
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
              'channel id $i',
              'channel name $i',
              importance: Importance.defaultImportance,
              priority: Priority.high,
              ongoing: true,
              styleInformation: BigTextStyleInformation(message),
              icon: 'diary_icon',
              vibrationPattern: vibrationPattern
          ),
          iOS: const DarwinNotificationDetails(
            badgeNumber: 1,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }
}