import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../screen/bookcover_screen.dart';
import 'comfirm_pass.dart';

class PasscodeSetScreen extends StatefulWidget {
  const PasscodeSetScreen({super.key});

  @override
  _PasscodeState createState() => _PasscodeState();
}

class _PasscodeState extends State<PasscodeSetScreen> {

  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  int passwordDigits = 4; //パスワードの桁数

  @override
  void dispose() {
    // TODO: implement dispose
    _verificationNotifier.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final textString = AppLocalizations.of(context);
//パスワードロック画面を発動
    return _showLockScreen(
        context,
        opaque: false,
      textString: textString
    );
  }

//パスワードロック画面の見た目の詳細
//ボタンの大きさや、色などカスタマイズできます。
//各色の設定はmain.dartで定義しているカラーなどを設定しています。

  _showLockScreen(BuildContext context, {required bool opaque,required AppLocalizations? textString}) {

    return  PasscodeScreen(
      title: Column(
        children: <Widget>[
          const Icon(Icons.lock, size: 30),
          Text('${textString?.input_pass}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15,color:Theme.of(context).dividerColor ),
          ),
        ],
      ),
      passwordDigits: passwordDigits,
      circleUIConfig: CircleUIConfig(
        borderColor: Theme.of(context).dividerColor,
        fillColor: Theme.of(context).dividerColor,
        circleSize: 20,
      ),
      keyboardUIConfig: KeyboardUIConfig(
        primaryColor: Theme.of(context).dividerColor,
        digitTextStyle: const TextStyle(fontSize: 25),
        deleteButtonTextStyle: const TextStyle(fontSize: 15),
      ),
      passwordEnteredCallback: _onPasscodeEntered,//パスワードが入力された時の処理
      deleteButton: Icon(Icons.backspace, size: 25.0,color:Theme.of(context).dividerColor ,),
      cancelButton:  ElevatedButton(
        style: ElevatedButton.styleFrom(
           foregroundColor: Colors.grey,
           backgroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
        onPressed: () { _onPasscodeCancelled(); },
        child: Text('${textString?.free_lock}',
            style: const TextStyle(color: Colors.black)
        ),
      ), //パスワードが入力がキャンセルされた時の処理
      shouldTriggerVerification: _verificationNotifier.stream,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

//パスワードが桁数まで入力された発動する処理
  _onPasscodeEntered(String enteredPasscode)  {

//パスワード確認フォームに飛ばす
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmPassword(password: enteredPasscode))); //入力されているパスワードを引数として渡す。
  }

//入力がキャンセルされたら発動する処理
  _onPasscodeCancelled() async{
    await _isPasswordLock(false); //とりあえず、パスワード設定をオフにしておく
    Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          settings: const RouteSettings(name: 'book'),
          pageBuilder: (context, animation,
              secondaryAnimation) {
            return const BookCoverPage();
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
  }

//パスワード設定のオンオフを記録する(shared_preferencesパッケージの機能です)
  _isPasswordLock(bool value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isPasswordLock", value);
  }
}