import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../custom_widget/first_input_pass.dart';
import '../main.dart';
import 'bookcover_screen.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

class EmptyPage extends ConsumerStatefulWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  EmptyState createState() => EmptyState();
}

class EmptyState extends ConsumerState<EmptyPage> {
  static const appBarHeight = 60.0;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _init();
    loadAd(ref);
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


  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textString = AppLocalizations.of(context);
    final password = prefs.getString('lockPassword') ?? '';
    final valid = prefs.getBool("isPasswordLock") ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref
          .watch(appBarTitleColorProvider.notifier)
          .state = Color(settingData.appBarTitleColorProvider);
      ref
          .watch(appBarImagePath.notifier)
          .state = settingData.appBarImagePath;
      ref
          .watch(appBarImageDefaultPath.notifier)
          .state = settingData.appBarImageDefaultPath;
      ref
          .watch(fontIndexProvider.notifier)
          .state = settingData.fontIndexProvider;
      ref
          .watch(theme1Provider.notifier)
          .state = Color(settingData.theme1Provider); //背景
      ref
          .watch(theme2Provider.notifier)
          .state = Color(settingData.theme2Provider); //ボタンなど
      ref
          .watch(theme3Provider.notifier)
          .state = Color(settingData.theme3Provider); //アイコンや日付
      ref
          .watch(theme4Provider.notifier)
          .state = Color(settingData.theme4Provider); //リストでの文字色
      ref
          .watch(theme5Provider.notifier)
          .state = Color(settingData.theme5Provider);
      ref
          .watch(theme6Provider.notifier)
          .state = Color(settingData.theme6Provider); //アクセント
      ref
          .watch(fontSizeListProvider.notifier)
          .state = settingData.fontSizeListProvider;
      ref
          .watch(fontSizeDiaryProvider.notifier)
          .state = settingData.fontSizeDiaryProvider;
      ref
          .watch(listMaxLinesProvider.notifier)
          .state = settingData.listMaxLinesProvider;
      ref
          .watch(listHeightProvider.notifier)
          .state = settingData.listHeightProvider;
      ref
          .watch(weekFormatProvider.notifier)
          .state = settingData.weekFormatProvider;
      ref
          .watch(dateFormatProvider.notifier)
          .state = settingData.dateFormatProvider;
      ref
          .watch(dateUpdateTimeProvider.notifier)
          .state = settingData.dateUpdateTimeProvider;
      ref
          .watch(gptIntroduce.notifier)
          .state = settingData.gptIntroduce;
      ref
          .watch(notificationEnabled.notifier)
          .state = settingData.notificationEnabled;

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              settings: const RouteSettings(name: 'book'),
              builder: (context) {
                return valid
                    ? FirstInputPassword(password: password)
                    : const BookCoverPage();
              }
          )
      );

      await _cancelNotification();
      await _requestPermissions();

      if (ref.watch(notificationEnabled)) {
        await _registerMessage(
          hour: ref.watch(notificationTimeProvider),
          minutes: 0,
          message: '${textString?.restore_yourself}',
        );
      }
    });
    return const Scaffold();
  }

   static void loadAd(WidgetRef ref){
    RewardedAd.load(
        adUnitId: Platform.isAndroid?'ca-app-pub-5499367448047451/9258647921':'ca-app-pub-5499367448047451/4847865287',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            ref.watch(adLoadedProvider.notifier).state=true;
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            rewardedAd = ad;
            rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedAd ad) =>
                  print('$ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                print('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
                loadAd(ref);
              },
              onAdFailedToShowFullScreenContent: (RewardedAd ad,
                  AdError error) {
                print('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
                loadAd(ref);
              },
              onAdImpression: (RewardedAd ad) =>
                  print('$ad impression occurred.'),
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            ref.watch(adLoadedProvider.notifier).state=false;
          },
        ));
   }


  static void loadAdAndShow(Function(AdWithoutView ad, RewardItem rewardItem) onUserEarnedReward,AppLocalizations? textString,WidgetRef ref){
    RewardedAd.load(
        adUnitId: Platform.isAndroid?'ca-app-pub-5499367448047451/9258647921':'ca-app-pub-5499367448047451/4847865287',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            ref.watch(adLoadedProvider.notifier).state=true;
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            rewardedAd = ad;
            rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedAd ad) =>
                  print('$ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                print('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
                loadAd(ref);
              },
              onAdFailedToShowFullScreenContent: (RewardedAd ad,
                  AdError error) {
                print('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
                loadAd(ref);
              },
              onAdImpression: (RewardedAd ad) =>
                  print('$ad impression occurred.'),
            );
            ad.show(onUserEarnedReward: onUserEarnedReward);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            Fluttertoast.cancel();
            Fluttertoast.showToast(
              msg: '${textString?.ad_failed}',
              toastLength: Toast.LENGTH_SHORT,
            );
            ref.watch(adLoadedProvider.notifier).state=false;
          },
        ));
   }
}