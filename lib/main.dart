import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:keep_diary/helper/file_helper.dart';
import 'package:keep_diary/screen/diary_edit_screen.dart';
import 'package:keep_diary/screen/empty.dart';
import 'package:keep_diary/structure/data_structure.dart';
import 'package:keep_diary/structure/setting_data_structure.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

final onSearchProvider = StateProvider((ref) => false);
final StateProvider<List<int>> searchIndexListProvider = StateProvider((ref) => []);
final StateProvider<int>currentDiaryProvider=StateProvider((ref) => 0);
final StateProvider<List<String>>currentPickImageProvider=StateProvider((ref) => []);
final StateProvider<DateTime> currentDateProvider = StateProvider((ref) => data.year.isNotEmpty?DateTime(data.year[0],data.month[0],data.day[0]):DateTime.now());

final StateProvider<Color> appBarTitleColorProvider=StateProvider((ref) => const Color(0xFFFFFFFF));
final StateProvider<String>appBarImagePath=StateProvider((ref) => '');
final StateProvider<String>appBarImageDefaultPath=StateProvider((ref) => 'assets/appbarDefault/appBarImage4.png');
final StateProvider<int>fontIndexProvider=StateProvider((ref) => 0);
final StateProvider<Color>theme1Provider=StateProvider((ref) => Colors.grey.shade200);//背景
final StateProvider<Color>theme2Provider=StateProvider((ref) => Colors.grey.shade300);//ボタンなど
final StateProvider<Color>theme3Provider=StateProvider((ref) => Colors.black);//アイコンや日付
final StateProvider<Color>theme4Provider=StateProvider((ref) => Colors.grey.shade700);//リストでの文字色
final StateProvider<Color>theme5Provider=StateProvider((ref) => Colors.black);
final StateProvider<Color>theme6Provider=StateProvider((ref) => Colors.amber);//アクセント
final StateProvider<int>fontSizeListProvider=StateProvider((ref) => 16);
final StateProvider<int>fontSizeDiaryProvider=StateProvider((ref) => 16);
final StateProvider<int>listMaxLinesProvider=StateProvider((ref) => 3);
final StateProvider<int>listHeightProvider=StateProvider((ref) => 80);
final StateProvider<int>weekFormatProvider=StateProvider((ref) => 0);
final StateProvider<int>dateFormatProvider=StateProvider((ref) => 3);
final StateProvider<int>dateUpdateTimeProvider=StateProvider((ref) => 0);
final StateProvider<int>notificationTimeProvider=StateProvider((ref) => 21);
final StateProvider<String>gptInputProvider=StateProvider((ref) => '');
final StateProvider<String>gptIntroduce=StateProvider((ref) => '');
final StateProvider<bool>notificationEnabled=StateProvider((ref) => false);

final StateProvider<String>passwordProvider=StateProvider((ref) => '');
final StateProvider<bool>passwordValidProvider=StateProvider((ref) => false);
final StateProvider<String>signStatusProvider=StateProvider((ref) => '');
final StateProvider<DateTime>calenderDateProvider=StateProvider((ref) => DateTime.now());
final StateProvider<CalendarFormat> calendarFormatProvider=StateProvider((ref) => CalendarFormat.month);
final StateProvider<bool>adLoadedProvider=StateProvider((ref) => false);
final StateProvider<bool>darkMord=StateProvider((ref) => false);
final StateProvider<int>themeIndex=StateProvider((ref) => 0);

final appLifecycleProvider = Provider<AppLifecycleState>((ref) {
  final observer = _AppLifecycleObserver((value) => ref.state = value);
  final binding = WidgetsBinding.instance..addObserver(observer);
  ref.onDispose(() => binding.removeObserver(observer));
  return AppLifecycleState.resumed;
});

const dataBoxName='dataBox',settingDataBoxName='settingDataBox';
const week =
[
  ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
  ['', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
  ['', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
  ['', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'],
  ['', '月', '火', '水', '木', '金', '土', '日'],
  ['', '月曜', '火曜', '水曜', '木曜', '金曜', '土曜', '日曜'],
  ['', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日', '日曜日'],
];

late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FileHelper.fileHelper.loadLocalPath();
  MobileAds.instance.initialize();
  // .evnから環境変数を読み込む
  await dotenv.load(fileName: '.env');
  OpenAI.apiKey = dotenv.get('OPEN_AI_API_KEY');

  prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  Hive.registerAdapter(SettingDataAdapter());
  Hive.registerAdapter(DataAdapter());
  await Hive.openBox<Data>(dataBoxName);
  await Hive.openBox<SettingData>(settingDataBoxName);
  dataBox = Hive.box<Data>(dataBoxName);
  settingDataBox = Hive.box<SettingData>(settingDataBoxName);

  data=dataBox.get(dataBoxName, defaultValue: Data.empty());
  settingData=settingDataBox.get(settingDataBoxName, defaultValue: SettingData.empty());
  e_title = prefs.getString("e_title") ?? '';
  e_text = prefs.getString('e_text') ?? '';
  e_image = prefs.getStringList('e_image') ?? [];
  e_height = prefs.getInt('e_height') ?? 80;

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

late Data data;
late SettingData settingData;
late Box dataBox;
late Box settingDataBox;
late RewardedAd rewardedAd;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: '',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        dividerColor: Colors.white,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        dividerColor: Colors.white,
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const EmptyPage(),
    );
  }
}

class _AppLifecycleObserver extends WidgetsBindingObserver {
  _AppLifecycleObserver(this._didChangeState);

  final ValueChanged<AppLifecycleState> _didChangeState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _didChangeState(state);
    super.didChangeAppLifecycleState(state);
  }
}
