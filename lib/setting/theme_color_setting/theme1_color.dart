import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../../main.dart';


class Theme1Setting extends HookConsumerWidget {
  const Theme1Setting({Key? key}) : super(key: key);
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
                            color: ref.watch(appBarTitleColorProvider), // <-- SEE HERE
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                                '${textString?.theme1}',
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
                    onColorChanged: (Color color) async {
                      ref.watch(themeIndex.notifier).state=pickColors.indexOf(color);
                      var prefs=await SharedPreferences.getInstance();
                      prefs.setInt('Theme-index',ref.watch(themeIndex));
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
                    availableColors: pickColors
                  ),
                  )
                ]
            )
        )
    );
  }
}
List<Color>pickColors=const [
  Color(0xFFEEEEEE),
  Color(0xffff4094),
  Color(0xfffb443b),
  Color(0xFFe8c348),
  Color(0xff006e29),
  Color(0xff006875),
  Color(0xff6d3ed0),
];
List<List<Color>>light= [
  [Colors.grey.shade200,Colors.grey.shade300,Colors.black,Colors.black,Colors.black,Colors.amber],
  [Color(0xfffaf0f7),Color(0xffffd9e2),Color(0xff7c5635),Color(0xff000000),Color(0xff000000),Color(0xffff4094)],
  [Color(0xfffaf0f4),Color(0xffffa89d),Color(0xff410002),Color(0xff1f1a19),Color(0xff1f1a19),Color(0xfffb443b)],
  [Color(0xfff7f3f3),Color(0xfff1e1bb),Color(0xff735c00),Color(0xff1d1b17),Color(0xff1d1b17),Color(0xffc8ecca)],
  [Color(0xfff1f6ee),Color(0xffd4e8d0),Color(0xff006e29),Color(0xff1a1c19),Color(0xff1a1c19),Color(0xffbceaf2)],
  [Color(0xfff0f4f6),Color(0xffcde7ed),Color(0xff006875),Color(0xff1a1c1d),Color(0xff1a1c1d),Color(0xff9defff)],
  [Color(0xfff6f1fc),Color(0xffe8def8),Color(0xff6d3ed0),Color(0xff1c1b1e),Color(0xff1c1b1e),Color(0xffffd9e2)],
];

List<List<Color>>dark= [
  [Color(0xff111111),Colors.grey.shade700,Colors.white,Colors.white,Colors.white,Color(0xffb97d00)],
  [Color(0xff201a1b),Color(0xff5a3f47),Color(0xffffb1c8),Color(0xffe9e0e1),Color(0xffe9e0e1),Color(0xffff4094)],
  [Color(0xff292221),Color(0xff442926),Color(0xffeb574b),Color(0xffebe0de),Color(0xffebe0de),Color(0xff930009)],
  [Color(0xff20261f),Color(0xff3c2f00),Color(0xffe2c45e),Color(0xffe7e2da),Color(0xffe7e2da),Color(0xff46664b)],
  [Color(0xff20261f),Color(0xff243424),Color(0xff60df76),Color(0xffe2e3de),Color(0xffe2e3de),Color(0xffa1ced6)],
  [Color(0xff1f2628),Color(0xff424463),Color(0xff0097a9),Color(0xffe1e3e3),Color(0xffe1e3e3),Color(0xff50d7ed)],
  [Color(0xff252429),Color(0xff625b70),Color(0xffd0bcff),Color(0xffe5e1e6),Color(0xffe5e1e6),Color(0xff633b48)],
];