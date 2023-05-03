import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_archive/flutter_archive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../../main.dart';
import '../helper/file_helper.dart';

final StateProvider<String>logProvider=StateProvider((ref) => '');

class BackupCreate extends HookConsumerWidget {
  BackupCreate({Key? key}) : super(key: key);
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
                  const SizedBox(height: 15,),
                  Text(ref.watch(logProvider),
                    style: TextStyle(color: ref.watch(theme6Provider)),),
                  Flexible(child: SettingsList(
                      sections: [
                        SettingsSection(
                            title: Text('${textString?.backup_attention}'),
                            tiles: <SettingsTile>[
                              SettingsTile.navigation(
                                  leading: const Icon(Icons.backup),
                                  title: Text('${textString?.backup_google}'),
                                  onPressed: (context) async {
                                    await _backUpAsZip(ref, textString);
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


  Future<void> _backUpAsZip(WidgetRef ref, AppLocalizations? textString) async {
    await [Permission.storage].request();

    String savedPath = "";
    String? externalZipPath="";
    String fileName="DiaryBackup${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}.zip";
    Uri? zipUri=null;

    if (Platform.isAndroid) {
      savedPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print("version : ${androidInfo.version.sdkInt}");
      if (androidInfo.version.sdkInt >= 30) {
        zipUri=await OpenDocument.getPath('application/zip', fileName);
        // File file = File("$savedPath/$fileName");
        // externalZipPath = file.path;
        // if(file.existsSync()){
        //   print("gbrbberbebberbbrOK  :   ${file.path}");
        // }
        // print("gbrbberbebberbbr  :   ${file.path}");
      }
    } else {
      final savedDocumentDirectoryO = await getApplicationDocumentsDirectory();
      savedPath = savedDocumentDirectoryO.path;
      externalZipPath = "$savedPath/$fileName";
    }


    await FileHelper.fileHelper.createDir(Directory('${FileHelper.fileHelper.localPath}/diary'));

    List<FileSystemEntity> fileEntityO = Directory(
        '${FileHelper.fileHelper.localPath}/diary').listSync();
    fileEntityO.removeWhere((elementO) => elementO.path.endsWith(".hive"));
    fileEntityO.add(File(dataBox.path!));
    fileEntityO.add(File(settingDataBox.path!));
    for (var elementO in fileEntityO) {
      print(elementO.path);
    }
    if (fileEntityO.isEmpty) {
      ref
          .watch(logProvider.notifier)
          .state = 'No data for backup';
      print("バックアップ対象のファイル無し");
      return;
    }

    final sourceDir = Directory(FileHelper.fileHelper.localPath);
    final List<File> files = [];
    for (int iO = 0; iO < fileEntityO.length; iO++) {
      files.add(File(fileEntityO[iO].path));
      print("${iO + 1}番目のファイルをzip");
    }
    // try {
    //   final zipFile = File(externalZipPath!);
    //   await ZipFile.createFromFiles(
    //       sourceDir: sourceDir, files: files, zipFile: zipFile);//,zipUri:zipUri);
    // } catch (e) {
    //   ref
    //       .watch(logProvider.notifier)
    //       .state = 'Failed to make zip';
    //   print(e);
    // }

    ref
        .watch(logProvider.notifier)
        .state = '${textString?.backed}';
    print("全ファイルのバックアップ完了");
  }
}

class OpenDocument {
  static const MethodChannel _channel = MethodChannel('openDocument');

  static Future<Uri?> getPath(String mime, String name) async {
    try {
      final result = await _channel.invokeMethod("getPath", {
        "mime": mime,
        "name": name,
      }); //name in native code

      return result;
    } on PlatformException catch (e) {
      //fails native call
      //handle error
      return null;
    }
  }
}