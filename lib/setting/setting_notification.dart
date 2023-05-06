import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../main.dart';
import '../screen/settings_screen.dart';


class NotificatikonSetting extends HookConsumerWidget {
  const NotificatikonSetting({Key? key}) : super(key: key);
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
                                '${textString?.notification}',
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
                    platform: DevicePlatform.android,
                    sections: [
                      SettingsSection(
                        title:  Text('${textString?.general}'),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            leading: const Icon(Icons.notifications),
                            title:  Text('${textString?.notification}'),
                            onPressed: (context) =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingsPage(key: key)),
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