import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../../main.dart';
import '../../screen/settings_screen.dart';

int _selectedValue=80;

class WeekFormatSetting extends HookConsumerWidget {
  const WeekFormatSetting({Key? key}) : super(key: key);
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
                                '${textString?.format_of_week}',
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
                  SizedBox(
                      height: 60,
                      child:
                      DropdownButton(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)),
                        value: ref.watch(weekFormatProvider),
                        items: const [
                          DropdownMenuItem(
                            value: 0,
                            child: Text('Sun'),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text('SUN'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Su'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('SU'),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text('日'),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text('日曜'),
                          ),
                          DropdownMenuItem(
                            value: 6,
                            child: Text('日曜日'),
                          ),
                        ],
                        onChanged: (value) {
                          _selectedValue = value!;
                          ref
                              .watch(weekFormatProvider.notifier)
                              .state = int.parse(value.toString());
                          settingData.weekFormatProvider=int.parse(value.toString());
                          settingDataBox.put(settingDataBoxName, settingData);
                        },
                      )
                  ),
                ]
            )
        )
    );
  }
}