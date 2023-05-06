import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keep_diary/custom_widget/passcode.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../screen/bookcover_screen.dart';
import '../screen/home_page.dart';

class FirstInputPassword extends ConsumerStatefulWidget {

  String password;

  FirstInputPassword({super.key, required this.password});

  @override
  _FirstInputPasswordState createState() => _FirstInputPasswordState();
}

class _FirstInputPasswordState extends ConsumerState<FirstInputPassword> {

  final StreamController<bool> _verificationNotifier =
  StreamController<bool>.broadcast(); //入力状況を感知
  late AppLocalizations? textString = AppLocalizations.of(context);
  bool isAuthenticated = false;
  int passwordDigits = 4; //パスワードの桁数
  late String passLockMessage; //エラーメッセージ

//入力されたパスワードを保存する処理です。
  _setPassword(String value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString("lockPassword", value);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    passLockMessage = '${textString?.confirm_pass}';
//機能実装都合でここに書いてありますが、initstate内に書いても通常は問題ないはずです。
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _showLockScreen( //パスワード設定画面をは発動します。
        context,
        opaque: false,
        textString: textString
    );
  }

//再入力画面の設定
//ほぼほぼ前の方と同じです。
  _showLockScreen(BuildContext context,
      {required bool opaque, AppLocalizations? textString}) {
    return PasscodeScreen(
      title: Column(
        children: <Widget>[
          Icon(Icons.lock, size: 30,color: ref.watch(theme4Provider),),
          Text(
            '${textString?.input_pass}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15,color: ref.watch(theme3Provider),)
          ),
        ],
      ),
      passwordDigits: passwordDigits,
      circleUIConfig: CircleUIConfig(
        borderColor: ref.watch(theme3Provider),
        fillColor: ref.watch(theme3Provider),
        circleSize: 20,
      ),
      keyboardUIConfig: KeyboardUIConfig(
        primaryColor: ref.watch(theme3Provider),
        digitTextStyle: TextStyle(color: ref.watch(theme4Provider),fontSize: 25),
        deleteButtonTextStyle: const TextStyle(fontSize: 15),
      ),
      passwordEnteredCallback: _onPasscodeEntered,
      //パスワードが入力された時の処理
      deleteButton: Icon(Icons.backspace, size: 25.0, color: ref.watch(theme3Provider)),
      cancelButton: Icon(Icons.cancel, size: 25.0, color: ref.watch(theme3Provider)),
      shouldTriggerVerification: _verificationNotifier.stream,
      backgroundColor: ref.watch(theme1Provider),
    );
  }

  _onPasscodeEntered(String enteredPasscode) async {
    bool isValid = widget.password == enteredPasscode;
    if (isValid) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              settings: const RouteSettings(name: 'book'),
              builder: (context) => HomePage())
      );
    } else {
      setState(() {
        passLockMessage = '${textString?.invalid_pass}'; //エラーメッセージを変数に格納
      });
    }
  }
}