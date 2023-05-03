import 'dart:io';
import 'package:keep_diary/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  FileHelper._internal();

  static final FileHelper fileHelper = FileHelper._internal();

  String _localPath = '';

  String get localPath => _localPath;

  Future<void> loadLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    _localPath = directory.path;

    print('localPath: $localPath');
  }

  String relativePathToAbsolutePath(String relativePath) {
    return '$_localPath/$relativePath';
  }

  String absolutePathToRelativePath(String absolutePath) {
    return extractFileName(absolutePath);
  }

  Future<Directory> createDir(Directory dir) async {
    if (!await dir.exists()) {
      return await dir.create(recursive: true);
    } else {
      return dir;
    }
  }

  Future<File> saveImage(File image) async {
    final String fileName = extractFileName(image.path);
    final String absolutePath = relativePathToAbsolutePath(fileName);
    return await image.copy(absolutePath);
  }

  Future<String> saveImageAt(File image,Directory dir) async {
    final String fileName = extractFileName(image.path);
    final String absolutePath = '${dir.path}/$fileName';
    await image.copy(absolutePath);
    return absolutePath;
  }

  String extractFileName(String fullPath) {
    final RegExp exp = RegExp('[^/]+\$');
    final match = exp.firstMatch(fullPath);

    return match != null ? '${match.group(0)}' : fullPath;
  }

  List<String> findImageNames(String text) {
    final List<String> imageNames = <String>[];

    final dom.Document html = parse(text);
    final List<dom.Element> tags = html.getElementsByTagName('img');

    if (tags.isEmpty) {
      return imageNames;
    }

    for (int i = 0; i < tags.length; i++) {
      final dom.Element imgTag = tags[i];

      final String src = '${imgTag.attributes['src']}';
      imageNames.add(src);
    }

    return imageNames;
  }

  String getRemovedImageTagsText(String originalText) {
    final dom.Document html = parse(originalText);
    final List<dom.Element> tags = html.getElementsByTagName('img');

    for (int i = 0; i < tags.length; i++) {
      tags[i].remove();
    }

    return html.body?.text ?? "";
  }

  String getFormattedDate(WidgetRef ref,int format,DateTime date){
    int we=date.weekday;
    int d=date.day;
    int m=date.month;
    int y=date.year;
    String w=week[ref.watch(weekFormatProvider)][we];
    switch(format){
      case 0:
        return '$m/$d/$y';
      case 1:
        return '$m.$d.$y';
      case 2:
        return '$m-$d-$y';
      case 3:
        return '$m/$d  $y';
      case 4:
        return '$m.$d  $y';
      case 5:
        return '$m-$d  $y';
      case 6:
        return '$w  $m/$d/$y';
      case 7:
        return '$w  $m.$d.$y';
      case 8:
        return '$w  $m-$d-$y';
      case 9:
        return '$w  $m/$d  $y';
      case 10:
        return '$w  $m.$d  $y';
      case 11:
        return '$w  $m-$d  $y';
      case 12:
        return '$y/$m/$d';
      case 13:
        return '$y.$m.$d';
      case 14:
        return '$y-$m-$d';
      case 15:
        return '$y  $m/$d';
      case 16:
        return '$y  $m.$d';
      case 17:
        return '$y  $m-$d';
      case 18:
        return '$y/$m/$d  $w';
      case 19:
        return '$y.$m.$d  $w';
      case 20:
        return '$y-$m-$d  $w';
      case 21:
        return '$y  $m/$d  $w';
      case 22:
        return '$y  $m.$d  $w';
      case 23:
        return '$y  $m-$d  $w';
    }
    return '';
  }
}