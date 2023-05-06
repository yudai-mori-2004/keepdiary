import 'dart:math';
import 'package:flutter/material.dart';
import 'package:keep_diary/setting/theme_color_setting/theme1_color.dart';
import 'package:keep_diary/setting/theme_color_setting/theme2_color.dart';
import 'package:keep_diary/setting/theme_color_setting/theme3_color.dart';
import 'package:keep_diary/setting/theme_color_setting/theme4_color.dart';
import 'package:keep_diary/setting/theme_color_setting/theme5_color.dart';
import 'package:keep_diary/setting/theme_color_setting/theme6_color.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../main.dart';
import '../screen/settings_screen.dart';
import 'app_bar_color.dart';


class ThemeColorSetting extends HookConsumerWidget {
  const ThemeColorSetting({Key? key}) : super(key: key);
  static const appBarHeight = 60.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textString = AppLocalizations.of(context);
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
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
                                '${textString?.theme}',
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
                    platform: DevicePlatform.android,
                    brightness: Brightness.light,
                    lightTheme: SettingsThemeData(
                      settingsListBackground: ref.watch(theme1Provider),
                      settingsTileTextColor: ref.watch(theme4Provider),
                      titleTextColor: ref.watch(theme4Provider),
                    ),
                    sections: [
                      SettingsSection(
                        title: Text('${textString?.theme}'),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            leading: Container(
                              child:
                              Icon(Icons.color_lens, color: ref.watch(
                                  theme3Provider),),),
                            title: Text('${textString?.theme1}',style: TextStyle(color: ref.watch(theme4Provider)),),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Theme1Setting(key: key)),
                                ),
                          ),
                          // SettingsTile.navigation(
                          //   leading: Container(
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: ref.watch(theme3Provider)),
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     child:
                          //     Icon(Icons.color_lens, color: ref.watch(
                          //         theme2Provider),),),
                          //   title: Text('${textString?.theme2}'),
                          //   onPressed: (context) =>
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 Theme2Setting(key: key)),
                          //       ),
                          // ),
                          // SettingsTile.navigation(
                          //   leading: Container(
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color:ref.watch(theme3Provider)),
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     child:
                          //     Icon(Icons.color_lens, color: ref.watch(
                          //         theme3Provider),),),
                          //   title: Text('${textString?.theme3}'),
                          //   onPressed: (context) =>
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 Theme3Setting(key: key)),
                          //       ),
                          // ),
                          // SettingsTile.navigation(
                          //   leading: Container(
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color:ref.watch(theme3Provider)),
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     child:
                          //     Icon(Icons.color_lens, color: ref.watch(
                          //         theme4Provider),),),
                          //   title: Text('${textString?.theme4}'),
                          //   onPressed: (context) =>
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 Theme4Setting(key: key)),
                          //       ),
                          // ),
                          // SettingsTile.navigation(
                          //   leading: Container(
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: ref.watch(theme3Provider)),
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     child:
                          //     Icon(Icons.color_lens, color: ref.watch(
                          //         theme5Provider),),),
                          //   title: Text('${textString?.theme5}'),
                          //   onPressed: (context) =>
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 Theme5Setting(key: key)),
                          //       ),
                          // ),
                          // SettingsTile.navigation(
                          //   leading: Container(
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color:ref.watch(theme3Provider)),
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     child:
                          //     Icon(Icons.color_lens, color: ref.watch(
                          //         theme6Provider),),),
                          //   title: Text('${textString?.theme6}'),
                          //   onPressed: (context) =>
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 Theme6Setting(key: key)),
                          //       ),
                          // ),
                          SettingsTile.navigation(
                            leading:  Icon(Icons.text_format,color:ref.watch(theme3Provider)),
                            title: Text('${textString?.app_bar_color}'),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AppBarColorSetting(key: key)),
                                ),
                          ),
                          SettingsTile.switchTile(
                            leading: Icon(Icons.dark_mode,color:ref.watch(theme3Provider)),
                            title: Text('${textString?.darkmode}',style: TextStyle(color: ref.watch(theme4Provider))),
                            initialValue: ref.watch(darkMord),
                            onToggle: (value) async {
                              ref.watch(darkMord.notifier).state=value;
                              var prefs=await SharedPreferences.getInstance();
                              prefs.setBool('Dark-mode', value);
                              if(!ref.watch(darkMord)) {
                                ref
                                    .watch(theme1Provider.notifier)
                                    .state = light[ref.watch(themeIndex)][0];
                                ref
                                    .watch(theme2Provider.notifier)
                                    .state = light[ref.watch(themeIndex)][1];
                                ref
                                    .watch(theme3Provider.notifier)
                                    .state = light[ref.watch(themeIndex)][2];
                                ref
                                    .watch(theme4Provider.notifier)
                                    .state = light[ref.watch(themeIndex)][3];
                                ref
                                    .watch(theme5Provider.notifier)
                                    .state = light[ref.watch(themeIndex)][4];
                                ref
                                    .watch(theme6Provider.notifier)
                                    .state = light[ref.watch(themeIndex)][5];
                                settingData.theme1Provider = light[ref.watch(themeIndex)][0].value;
                                settingData.theme2Provider = light[ref.watch(themeIndex)][1].value;
                                settingData.theme3Provider = light[ref.watch(themeIndex)][2].value;
                                settingData.theme4Provider = light[ref.watch(themeIndex)][3].value;
                                settingData.theme5Provider = light[ref.watch(themeIndex)][4].value;
                                settingData.theme6Provider = light[ref.watch(themeIndex)][5].value;
                              }else{
                                ref
                                    .watch(theme1Provider.notifier)
                                    .state = dark[ref.watch(themeIndex)][0];
                                ref
                                    .watch(theme2Provider.notifier)
                                    .state = dark[ref.watch(themeIndex)][1];
                                ref
                                    .watch(theme3Provider.notifier)
                                    .state = dark[ref.watch(themeIndex)][2];
                                ref
                                    .watch(theme4Provider.notifier)
                                    .state = dark[ref.watch(themeIndex)][3];
                                ref
                                    .watch(theme5Provider.notifier)
                                    .state = dark[ref.watch(themeIndex)][4];
                                ref
                                    .watch(theme6Provider.notifier)
                                    .state = dark[ref.watch(themeIndex)][5];
                                settingData.theme1Provider = dark[ref.watch(themeIndex)][0].value;
                                settingData.theme2Provider = dark[ref.watch(themeIndex)][1].value;
                                settingData.theme3Provider = dark[ref.watch(themeIndex)][2].value;
                                settingData.theme4Provider = dark[ref.watch(themeIndex)][3].value;
                                settingData.theme5Provider = dark[ref.watch(themeIndex)][4].value;
                                settingData.theme6Provider = dark[ref.watch(themeIndex)][5].value;
                              }
                              settingDataBox.put(settingDataBoxName, settingData);
                            },
                          )
                        ],
                      ),

                    ],
                  )
                  )
                ]
            )
        )
    );
  }
}