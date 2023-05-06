import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../main.dart';
import '../screen/settings_screen.dart';


class FontSetting extends HookConsumerWidget {
  FontSetting({Key? key}) : super(key: key);
  static const appBarHeight = 60.0;
  int _selectedValue=0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textString = AppLocalizations.of(context);
    _selectedValue=ref.watch(fontIndexProvider);
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
                                '${textString?.font}',
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
                  Container(height: 20,color: ref.watch(theme1Provider),),
                  Container(
                    height: 60,
                      color:ref.watch(theme1Provider),
                      child:
                      DropdownButton(
                        dropdownColor: ref.watch(theme1Provider),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        value: _selectedValue,
                        style: TextStyle(
                          fontFamily: 'f${ref.watch(fontIndexProvider)}',),
                        items: [
                          for(int i = 0; i <= 17; i++)
                            DropdownMenuItem(
                              value: i,
                              child: Text('${textString?.this_font} $i',
                                style: TextStyle(fontFamily: 'f$i',color: ref.watch(theme4Provider)),
                              ),
                            ),
                        ],
                        //  value: '${textString?.this_font}',
                        onChanged: (value) {
                          _selectedValue = value!;
                          ref
                              .watch(fontIndexProvider.notifier)
                              .state = int.parse(value.toString());
                          settingData.fontIndexProvider=int.parse(value.toString());
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
                          fontSize: 30,
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