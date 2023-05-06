import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';
import '../screen/bookcover_screen.dart';
import '../screen/home_page.dart';

class AlertQuit extends StatelessWidget {
  AlertQuit(Key? key,int f) : super(key: key){font=f;}

  late int font;

  @override
  Widget build(BuildContext context) {
    final textString = AppLocalizations.of(context);
    return AlertDialog(
      title: Text('${textString?.quit}',style: TextStyle(fontSize: 20,fontFamily: 'f$font')),
      actions: <Widget>[
        GestureDetector(
          child: Text('  ${textString?.cancel}  ',style: TextStyle(fontSize: 14,fontFamily: 'f$font'),),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: Text('  ${textString?.yes}  ',style: TextStyle(fontSize: 14,fontFamily: 'f$font')),
          onTap: () {
            exit(0);
          },
        )
      ],
    );
  }
}