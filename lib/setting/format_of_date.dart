import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../../main.dart';
import '../../screen/settings_screen.dart';

int _selectedValue=0;

class DateFormatSetting extends HookConsumerWidget {
  const DateFormatSetting({Key? key}) : super(key: key);
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
                                '${textString?.format_of_date}',
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
                        dropdownColor: ref.watch(theme1Provider),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)),
                        value: ref.watch(dateFormatProvider),
                        items:  [
                          DropdownMenuItem(
                            value: 0,
                            child: Text('1/1/2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text('1.1.2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('1-1-2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('1/1 2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text('1.1 2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text('1-1 2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 6,
                            child: Text('Sun 1/1/2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 7,
                            child: Text('Sun 1.1.2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 8,
                            child: Text('Sun 1-1-2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 9,
                            child: Text('Sun 1/1 2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 10,
                            child: Text('Sun 1.1 2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 11,
                            child: Text('Sun 1-1 2023',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),

                          DropdownMenuItem(
                            value: 12,
                            child: Text('2023/1/1',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 13,
                            child: Text('2023.1.1',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 14,
                            child: Text('2023-1-1',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 15,
                            child: Text('2023 1/1',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 16,
                            child: Text('2023 1.1',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 17,
                            child: Text('2023 1-1',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 18,
                            child: Text('2023/1/1 Sun',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 19,
                            child: Text('2023.1.1 Sun',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 20,
                            child: Text('2023-1-1 Sun',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 21,
                            child: Text('2023 1/1 Sun',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 22,
                            child: Text('2023 1.1 Sun',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                          DropdownMenuItem(
                            value: 23,
                            child: Text('2023 1-1 Sun',style: TextStyle(color: ref.watch(theme4Provider))),
                          ),
                        ],
                        onChanged: (value) {
                          _selectedValue = value!;
                          ref
                              .watch(dateFormatProvider.notifier)
                              .state = int.parse(value.toString());
                          settingData.dateFormatProvider=int.parse(value.toString());
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