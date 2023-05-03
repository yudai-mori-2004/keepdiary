import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:keep_diary/structure/data_structure.dart';
import 'package:keep_diary/structure/setting_data_structure.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../../main.dart';
import '../helper/file_helper.dart';

final StateProvider<String>logProvider=StateProvider((ref) => '');

class BackupRestore extends HookConsumerWidget {
  BackupRestore({Key? key}) : super(key: key);
  static const appBarHeight = 60.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textString = AppLocalizations.of(context);
    ref.listen(logProvider, (previous, next) {
      Fluttertoast.showToast(msg: next,toastLength: Toast.LENGTH_SHORT);
    });
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
                                '${textString?.backup}',
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
                  Flexible(
                      child: SettingsList(
                          sections: [
                            SettingsSection(
                                title: Text('${textString?.backup_attention2}'),
                                tiles: <SettingsTile>[
                                  SettingsTile.navigation(
                                      leading: const Icon(Icons.download_for_offline),
                                      title: Text(
                                          '${textString?.delete_restore}'),
                                      onPressed: (context) {
                                        _importFromFolder(ref, false,textString);
                                        ref.watch(logProvider.notifier).state='${textString?.backup_attention2}';
                                      }
                                  ),
                                  SettingsTile.navigation(
                                      leading: const Icon(Icons.download_for_offline),
                                      title: Text(
                                          '${textString?.leave_restore}'),
                                      onPressed: (context) {
                                        _importFromFolder(ref, true,textString);
                                        ref.watch(logProvider.notifier).state='${textString?.backup_attention2}';
                                      }
                                  ),
                                ]
                            ),
                          ]
                      )
                  ),
                ]
            )
        )
    );
  }


  Future<void> _importFromFolder(WidgetRef ref,bool leaveCur,AppLocalizations? textString) async {
    final localPath = FileHelper.fileHelper.localPath;
    FilePickerResult? importFileData = await FilePicker.platform.pickFiles();
    if (importFileData == null) {
      ref
          .watch(logProvider.notifier)
          .state = 'No file selected.';
    } else {
      final zipFile = File(importFileData.files.single.path!);
      final destinationDir = Directory(localPath);
      try {
        await ZipFile.extractToDirectory(
            zipFile: zipFile, destinationDir: destinationDir);
        await dataBox.close();
        await Hive.openBox(dataBoxName);
        dataBox = Hive.box<dynamic>(dataBoxName);
        print('datalength ${data.year.length} $leaveCur');
        if (leaveCur) {
          Data d = dataBox.get(dataBoxName, defaultValue: Data.empty());
          for (int i = 0; i < data.year.length; i++) {
            d.addDiary(
                data.year[i],
                data.month[i],
                data.day[i],
                data.date[i],
                data.height[i],
                data.title[i],
                data.text[i],
                data.image[i]);
          }
          data = d;
          dataBox.put(dataBoxName, data);
        } else {
          data = dataBox.get(dataBoxName, defaultValue: Data.empty());
          dataBox.put(dataBoxName, data);
        }

        await settingDataBox.close();
        await Hive.openBox<SettingData>(settingDataBoxName);
        settingDataBox = Hive.box<SettingData>(settingDataBoxName);
        settingData = settingDataBox.get(
            settingDataBoxName, defaultValue: SettingData.empty());
        settingDataBox.put(settingDataBoxName, settingData);

        ref
            .watch(logProvider.notifier)
            .state = '${textString?.restart}';
      } catch (e) {
        ref
            .watch(logProvider.notifier)
            .state = 'Failed to restore.';
        print(e);
      }
    }
  }
}