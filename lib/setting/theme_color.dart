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
                    sections: [
                      SettingsSection(
                        title: Text('${textString?.theme}'),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:
                              Icon(Icons.color_lens, color: ref.watch(
                                  theme1Provider),),),
                            title: Text('${textString?.theme1}'),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Theme1Setting(key: key)),
                                ),
                          ),
                          SettingsTile.navigation(
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:
                              Icon(Icons.color_lens, color: ref.watch(
                                  theme2Provider),),),
                            title: Text('${textString?.theme2}'),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Theme2Setting(key: key)),
                                ),
                          ),
                          SettingsTile.navigation(
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:
                              Icon(Icons.color_lens, color: ref.watch(
                                  theme3Provider),),),
                            title: Text('${textString?.theme3}'),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Theme3Setting(key: key)),
                                ),
                          ),
                          SettingsTile.navigation(
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:
                              Icon(Icons.color_lens, color: ref.watch(
                                  theme4Provider),),),
                            title: Text('${textString?.theme4}'),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Theme4Setting(key: key)),
                                ),
                          ),
                          SettingsTile.navigation(
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:
                              Icon(Icons.color_lens, color: ref.watch(
                                  theme5Provider),),),
                            title: Text('${textString?.theme5}'),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Theme5Setting(key: key)),
                                ),
                          ),
                          SettingsTile.navigation(
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:
                              Icon(Icons.color_lens, color: ref.watch(
                                  theme6Provider),),),
                            title: Text('${textString?.theme6}'),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Theme6Setting(key: key)),
                                ),
                          ),
                          SettingsTile.navigation(
                            leading: const Icon(Icons.text_format),
                            title: Text('${textString?.app_bar_color}'),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AppBarColorSetting(key: key)),
                                ),
                          ),
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