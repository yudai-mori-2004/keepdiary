import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';
import '../main.dart';
import '../screen/settings_screen.dart';


class AppBarColorSetting extends HookConsumerWidget {
  const AppBarColorSetting({Key? key}) : super(key: key);
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
                                '${textString?.app_bar_color}',
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
                  Expanded(child:
                  BlockPicker(
                    pickerColor: ref.watch(appBarTitleColorProvider),
                    onColorChanged: (Color color) {
                      ref
                          .watch(appBarTitleColorProvider.notifier)
                          .state = color;
                      settingData.appBarTitleColorProvider=color.value;
                      settingDataBox.put(settingDataBoxName, settingData);
                    },
                    availableColors: const [
                      Color(0xFF000000),
                      Color(0xFF808080),
                      Color(0xFFd3d3d3),
                      Color(0xFFb0c4de),
                      Color(0xFF4682b4),
                      Color(0xFF000080),
                      Color(0xFF00bfff),
                      Color(0xFF00ffff),
                      Color(0xFF20b2aa),
                      Color(0xFF008000),
                      Color(0xFF7cfc00),
                      Color(0xFF808000),
                      Color(0xFFffff00),
                      Color(0xFFff8c00),
                      Color(0xFFa0522d),
                      Color(0xFFa52a2a),
                      Color(0xFFff0000),
                      Color(0xFFff1493),
                      Color(0xFFff00ff),
                      Color(0xFF9400d3),
                      Color(0xFF4b0082),
                    ],
                  ),
                  )
                ]
            )
        )
    );
  }
}