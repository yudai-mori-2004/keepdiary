import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';
import '../screen/bookcover_screen.dart';

class AlertReBack extends StatelessWidget {
  AlertReBack(Key? key,Function a,int f) : super(key: key){action=a;font=f;}
  
  late Function action;
  late int font;

  @override
  Widget build(BuildContext context) {
    final textString = AppLocalizations.of(context);
    return AlertDialog(
      title: Text('${textString?.back}',style: TextStyle(fontSize: 20,fontFamily: 'f$font')),
      actions: <Widget>[
        GestureDetector(
          child: Text('${textString?.cancel}  ',style: TextStyle(fontSize: 14,fontFamily: 'f$font'),),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: Text('  ${textString?.no}',style: TextStyle(fontSize: 14,fontFamily: 'f$font'),),
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: Text('  ${textString?.yes}  ',style: TextStyle(fontSize: 14,fontFamily: 'f$font')),
          onTap: () {
            action();
          },
        )
      ],
    );
  }
}