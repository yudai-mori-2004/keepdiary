import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';
import '../screen/bookcover_screen.dart';
import '../screen/home_page.dart';

class AlertDelete extends StatelessWidget {
  AlertDelete(Key? key,int i,int f,Function fun) : super(key: key){index=i;font=f;function=fun;}

  late int index;
  late int font;
  late Function function;

  @override
  Widget build(BuildContext context) {
    final textString = AppLocalizations.of(context);
    return AlertDialog(
      title: Text('${textString?.delete}',style: TextStyle(fontSize: 20,fontFamily: 'f$font')),
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
            data.removeAt(index);
            dataBox.put(dataBoxName, data);
            function.call();

            Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  settings: const RouteSettings(name: 'book'),
                  pageBuilder: (context, animation,
                      secondaryAnimation) {
                    return HomePage();
                  },
                  transitionsBuilder: (context,
                      animation,
                      secondaryAnimation,
                      child) {
                    const Offset begin = Offset(
                        0.0, 1.0); // 下から上
                    // final Offset begin = Offset(0.0, -1.0); // 上から下
                    const Offset end = Offset
                        .zero;
                    final Animatable<
                        Offset> tween = Tween(
                        begin: begin, end: end)
                        .chain(CurveTween(
                        curve: Curves
                            .easeInOut));
                    final Animation<
                        Offset> offsetAnimation = animation
                        .drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(
                      milliseconds: 300),
                ),
                    (_) => false
            );
          },
        )
      ],
    );
  }
}