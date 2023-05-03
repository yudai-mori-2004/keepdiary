import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../main.dart';
import '../screen/settings_screen.dart';
import 'font_size_setting/font_size_diary.dart';
import 'font_size_setting/font_size_list.dart';


class FontSizeSetting extends HookConsumerWidget {
  const FontSizeSetting({Key? key}) : super(key: key);
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
                            color: ref.watch(appBarTitleColorProvider), // <-- SEE HERE
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                                '${textString?.text_size}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ref.watch(appBarTitleColorProvider),
                                  fontSize: 24,
                                  fontWeight: FontWeight
                                      .w400,
                                  fontFamily: 'f${ref.watch(fontIndexProvider)}',)
                            ),
                            background: SizedBox(
                              width: double.infinity,
                              child:
                              File(ref.watch(appBarImagePath)).existsSync() ? Image.file(
                                File(ref.watch(appBarImagePath)), fit: BoxFit.cover,) : Image.asset(
                                ref.watch(appBarImageDefaultPath), fit: BoxFit.cover,),
                            ),
                          ),
                        )
                      ]),
                  Expanded(child: SettingsList(
                    sections: [
                      SettingsSection(
                        title:  Text('${textString?.text_size}'),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            leading: const Icon(Icons.text_fields),
                            title:  Text('${textString?.text_size_diary}'),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FontSizeDiarySetting(key: key)),
                                ),
                          ),
                          SettingsTile.navigation(
                            leading: const Icon(Icons.text_fields),
                            title:  Text('${textString?.text_size_list}'),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FontSizeListSetting(key: key)),
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