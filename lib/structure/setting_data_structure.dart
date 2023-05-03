import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'setting_data_structure.g.dart';

@HiveType(typeId : 1)
class SettingData {

  @HiveField(0)
  int appBarTitleColorProvider = Color(0xFFFFFFFF).value;
  @HiveField(1)
  String appBarImagePath = '';
  @HiveField(2)
  String appBarImageDefaultPath = 'assets/appbarDefault/appBarImage5.png';
  @HiveField(3)
  int fontIndexProvider = 0;
  @HiveField(4)
  int theme1Provider = Colors.grey.shade200.value; //背景
  @HiveField(5)
  int theme2Provider = Colors.grey.shade300.value; //ボタ
  @HiveField(6)
  int theme3Provider = Colors.black.value; //アイコンや日付
  @HiveField(7)
  int theme4Provider = Colors.grey.shade700.value; //リストで
  @HiveField(8) // の文字色
  int theme5Provider = Colors.black.value;
  @HiveField(9)
  int theme6Provider = Colors.amber.value; //アクセント
  @HiveField(10)
  int fontSizeListProvider = 16;
  @HiveField(11)
  int fontSizeDiaryProvider = 16;
  @HiveField(12)
  int listMaxLinesProvider = 3;
  @HiveField(13)
  int listHeightProvider = 80;
  @HiveField(14)
  int weekFormatProvider = 0;
  @HiveField(15)
  int dateFormatProvider = 3;
  @HiveField(16)
  int dateUpdateTimeProvider = 0;
  @HiveField(17)
  String gptIntroduce = '';
  @HiveField(18)
  bool notificationEnabled = true;
  @HiveField(19)
  int notificationTimeProvider = 21;

  SettingData(this.theme3Provider, this.theme6Provider, this.theme1Provider,
      this.theme2Provider, this.theme5Provider, this.fontSizeDiaryProvider,
      this.fontIndexProvider, this.dateFormatProvider, this.weekFormatProvider,
      this.listHeightProvider, this.listMaxLinesProvider,
      this.fontSizeListProvider, this.appBarTitleColorProvider,
      this.appBarImagePath, this.appBarImageDefaultPath, this.theme4Provider,
      this.dateUpdateTimeProvider, this.gptIntroduce, this.notificationEnabled,
      this.notificationTimeProvider);

  SettingData.empty()
      :
        appBarTitleColorProvider = Color(0xFFFFFFFF).value,
        appBarImagePath = '',
        appBarImageDefaultPath = 'assets/appbarDefault/appBarImage5.png',
        fontIndexProvider = 0,
        theme1Provider = Colors.grey.shade200.value,
        theme2Provider = Colors.grey.shade300.value,
        theme3Provider = Colors.black.value,
        theme4Provider = Colors.grey.shade700.value,
        theme5Provider = Colors.black.value,
        theme6Provider = Colors.amber.value,
        fontSizeListProvider = 16,
        fontSizeDiaryProvider = 16,
        listMaxLinesProvider = 3,
        listHeightProvider = 80,
        weekFormatProvider = 0,
        dateFormatProvider = 3,
        dateUpdateTimeProvider=0,
        gptIntroduce='',
        notificationEnabled=true,
        notificationTimeProvider=21;

}