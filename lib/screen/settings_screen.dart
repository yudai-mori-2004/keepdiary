import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:keep_diary/custom_widget/passcode.dart';
import 'package:keep_diary/helper/file_helper.dart';
import 'package:keep_diary/setting/app_bar_color.dart';
import 'package:keep_diary/setting/backup_data.dart';
import 'package:keep_diary/setting/day_update_time.dart';
import 'package:keep_diary/setting/email.dart';
import 'package:keep_diary/setting/font_change.dart';
import 'package:keep_diary/setting/format_of_week.dart';
import 'package:keep_diary/setting/list_max_lines.dart';
import 'package:keep_diary/setting/self_introduction.dart';
import 'package:keep_diary/setting/setting_notification.dart';
import 'package:keep_diary/setting/theme_color.dart';
import 'package:keep_diary/structure/setting_data_structure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:settings_ui/settings_ui.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../custom_widget/alert_dialog_quit.dart';
import '../main.dart';
import '../setting/font_size.dart';
import '../setting/format_of_date.dart';
import '../setting/list_height.dart';
import '../setting/notification_time.dart';
import 'bookcover_screen.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const appBarHeight = 60.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Setting updated');

    final textString = AppLocalizations.of(context);
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return WillPopScope(
      child: Scaffold(
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
                            flexibleSpace: FlexibleSpaceBar(
                              title: Text(
                                  '${textString?.settings}',
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
                    Expanded(child: SettingsList(
                      brightness: Brightness.light,
                      lightTheme: SettingsThemeData(
                        settingsListBackground: ref.watch(theme1Provider),
                        settingsTileTextColor: ref.watch(theme4Provider),
                        titleTextColor: ref.watch(theme4Provider),
                      ),
                      platform: DevicePlatform.android,
                      sections: [
                        SettingsSection(
                          title: Text('${textString?.general}'),
                          tiles: <SettingsTile>[
                            SettingsTile.navigation(
                                leading: Icon(Icons.notifications, color: ref
                                    .watch(theme3Provider),),
                                title: Text('${textString?.notification}'),
                                onPressed: (context) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationSetting(key: key))
                                  );
                                }
                            ),
                            SettingsTile.navigation(
                              leading: Icon(Icons.lock, color: ref.watch(
                                  theme3Provider),),
                              title: Text('${textString?.lock}'),
                              onPressed: (context) =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const PasscodeSetScreen()),
                                  ),
                            ),
                            SettingsTile.navigation(
                              leading: Icon(Icons.more_time, color: ref.watch(
                                  theme3Provider),),
                              title: Text('${textString?.date_update_time}'),
                              onPressed: (context) =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DateUpdateSetting(key: key)),
                                  ),
                            ),
                            SettingsTile.navigation(
                              leading: Icon(Icons.backup, color: ref.watch(
                                  theme3Provider),),
                              title: Text('${textString?.backup}'),
                              onPressed: (context) =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BackupSetting(key: key)),
                                  ),
                            ),
                            SettingsTile.navigation(
                              leading: Icon(Icons.person, color: ref.watch(
                                  theme3Provider),),
                              title: Text('${textString?.self}'),
                              onPressed: (context) =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IntroSetting(
                                                key, ref.watch(gptIntroduce))),
                                  ),
                            ),
                          ],
                        ),
                        SettingsSection(
                          title: Text('${textString?.design}'),
                          tiles: <SettingsTile>[
                            SettingsTile.navigation(
                              leading: Icon(Icons.color_lens, color: ref.watch(
                                  theme3Provider),),
                              title: Text('${textString?.theme}'),
                              onPressed: (context) =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ThemeColorSetting(key: key)),
                                  ),
                            ),
                            SettingsTile.navigation(
                              leading: Icon(Icons.font_download, color: ref
                                  .watch(
                                  theme3Provider),),
                              title: Text('${textString?.font}'),
                              onPressed: (context) =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FontSetting(key: key)),
                                  ),
                            ),
                            SettingsTile.navigation(
                              leading: Icon(Icons.text_fields, color: ref.watch(
                                  theme3Provider),),
                              title: Text('${textString?.text_size}'),
                              onPressed: (context) =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FontSizeSetting(key: key)),
                                  ),
                            ),
                            SettingsTile.navigation(
                              leading: Icon(Icons.image, color: ref.watch(
                                  theme3Provider),),
                              title: Text('${textString?.app_bar_background}'),
                              onPressed: (context) =>
                                  pickAppBarImageAndSave(ref),
                            ),
                            SettingsTile.navigation(
                              leading: Icon(
                                Icons.line_weight_outlined, color: ref
                                  .watch(theme3Provider),),
                              title: Text('${textString?.list_max_lines}'),
                              onPressed: (context) =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListMaxLinesSetting(key: key)),
                                  ),
                            ),
                            SettingsTile.navigation(
                              leading: Icon(Icons.height, color: ref.watch(
                                  theme3Provider),),
                              title: Text('${textString?.list_height}'),
                              onPressed: (context) =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListHeightSetting(key: key)),
                                  ),
                            ),
                            SettingsTile.navigation(
                              leading: Icon(Icons.nights_stay, color: ref.watch(
                                  theme3Provider),),
                              title: Text('${textString?.format_of_week}'),
                              onPressed: (context) =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WeekFormatSetting(key: key)),
                                  ),
                            ),
                            SettingsTile.navigation(
                              leading: Icon(Icons.calendar_month, color: ref
                                  .watch(theme3Provider),),
                              title: Text('${textString?.format_of_date}'),
                              onPressed: (context) =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DateFormatSetting(key: key)),
                                  ),
                            ),
                          ],
                        ),
                        SettingsSection(
                            title: Text('${textString?.others}'),
                            tiles: <SettingsTile>[
                              SettingsTile.navigation(
                                leading: Icon(Icons.mail, color: ref.watch(
                                    theme3Provider),),
                                title: Text('${textString?.mail_setting}'),
                                onPressed: (context) =>
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SendMailSetting(key: key)),
                                    ),
                              ),
                            ]
                        )
                      ],
                    )
                    )
                  ]
              )
          )
      ),
      onWillPop: () async {
        showDialog<void>(
            context: context,
            builder: (_) {
              return AlertQuit(null, ref.watch(fontIndexProvider));
            });
        return true;
      },
    );
  }

  Future pickAppBarImageAndSave(WidgetRef ref) async {
    try {
      final localPath = FileHelper.fileHelper.localPath;
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final dir = await FileHelper.fileHelper.createDir(
          Directory('$localPath/appBar'));
      final targetFile = File(ref.watch(appBarImagePath));
      if (targetFile.existsSync()) {
        targetFile.deleteSync(recursive: true);
      }
      final im = File(image.path);
      final savedPath = await FileHelper.fileHelper.saveImageAt(im, dir);
      ref
          .watch(appBarImagePath.notifier)
          .state = savedPath;
      print(appBarImagePath);
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }
}