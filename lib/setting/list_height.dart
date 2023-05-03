import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../../main.dart';
import '../../screen/settings_screen.dart';

int _selectedValue=80;

class ListHeightSetting extends HookConsumerWidget {
  const ListHeightSetting({Key? key}) : super(key: key);
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
                                '${textString?.list_max_lines}',
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
                        value: ref.watch(listHeightProvider),
                        items: [
                          for(int i = 40; i <= 300; i+=5)
                            DropdownMenuItem(
                              value: i,
                              child: Text('$i${i == 80 ? ' (default)' : ''}',
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          _selectedValue = value!;
                          ref
                              .watch(listHeightProvider.notifier)
                              .state = int.parse(value.toString());
                          settingData.listHeightProvider=int.parse(value.toString());
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