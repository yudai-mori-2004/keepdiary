import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../../main.dart';
import '../../screen/settings_screen.dart';

int _selectedValue=16;

class FontSizeListSetting extends HookConsumerWidget {
  const FontSizeListSetting({Key? key}) : super(key: key);
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
                                '${textString?.text_size_list}',
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
                  Container(height: 20,color:ref.watch(theme1Provider)),
                  SizedBox(
                      height: 60,
                      child:
                      DropdownButton(
                        dropdownColor: ref.watch(theme1Provider),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)),
                        value: _selectedValue,
                        items: [
                          for(int i = 13; i <= 40; i++)
                            DropdownMenuItem(
                              value: i,
                              child: Text('$i${i == 16 ? ' (default)' : ''}'
                                  ,style: TextStyle(color: ref.watch(theme4Provider))
                              ),
                            ),
                        ],
                        //  value: '${textString?.this_font}',
                        onChanged: (value) {
                          _selectedValue = value!;
                          ref
                              .watch(fontSizeListProvider.notifier)
                              .state = int.parse(value.toString());
                          settingData.fontSizeListProvider=int.parse(value.toString());
                          settingDataBox.put(settingDataBoxName, settingData);
                        },
                      )
                  ),
                  const SizedBox(height: 30,),
                  Flexible(
                      child: SingleChildScrollView(child: Padding(
                          padding: const EdgeInsets.all(20), child: Text(
                        '${textString?.font_ex}',
                        style: TextStyle(
                        color: ref.watch(theme4Provider),
                          fontSize: ref.watch(fontSizeListProvider) * 1.0,
                          fontFamily: 'f${ref.watch(fontIndexProvider)}',),)
                      )
                      )
                  ),
                ]
            )
        )
    );
  }
}