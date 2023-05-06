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

class ConfirmPassword extends ConsumerStatefulWidget {

  String password;

  ConfirmPassword({super.key, required this.password});

  @override
  _ConfirmPasswordState createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends ConsumerState<ConfirmPassword> {

  final StreamController<bool> _verificationNotifier =
  StreamController<bool>.broadcast();//入力状況を感知
  late AppLocalizations? textString=AppLocalizations.of(context);
  bool isAuthenticated = false;
  int passwordDigits = 4;  //パスワードの桁数
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
    return _showLockScreen(//パスワード設定画面をは発動します。
      context,
      opaque: false,
      textString:textString
    );
  }

//再入力画面の設定
//ほぼほぼ前の方と同じです。
  _showLockScreen(BuildContext context,
      {required bool opaque,AppLocalizations? textString}) {
    return  PasscodeScreen(
      title: Column(
        children: <Widget>[
          Icon(Icons.lock, size: 30,color: ref.watch(theme4Provider),),
          Text(
            '${textString?.input_pass}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15,color:ref.watch(theme3Provider), ),
          ),
          Text(
            '${textString?.confirm_pass}',//メッセージを表示します。
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10,color:ref.watch(theme3Provider),),
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
      passwordEnteredCallback: _onPasscodeEntered,//パスワードが入力された時の処理
      deleteButton: Icon(Icons.backspace, size: 25.0,color:ref.watch(theme3Provider) ,),
      cancelButton:  ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor:ref.watch(theme3Provider),
          shape: const StadiumBorder(),
        ),
        onPressed: () { _onPasscodeCancelled(); },
        child: Text('${textString?.free_lock}',
            style: TextStyle(color: ref.watch(theme3Provider),)
        ),
      ),
      shouldTriggerVerification: _verificationNotifier.stream,
      backgroundColor: ref.watch(theme1Provider),
    );
  }

//パスワードが桁数入力されたときの処理
  _onPasscodeEntered(String enteredPasscode) async {

//パスワードのチェック
    bool isValid = widget.password == enteredPasscode;
    _verificationNotifier.add(isValid);//パスコードが正しいかどうかをパスコード画面に通知してます。
    if (isValid) {
      await _setPassword(enteredPasscode);
      _isPasswordLock(true);
      setState(() {
        passLockMessage = "";//メッセージを空に
        isAuthenticated = isValid; //trueにしています。
//
      });
    } else {
      setState(() {
        passLockMessage = '${textString?.invalid_pass}';     //エラーメッセージを変数に格納
      });
    }
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
  }

//パスワードを再入力をキャンセルした場合
  _onPasscodeCancelled() async{
    await _isPasswordLock(false); //パスワードロック設定をオフ状態
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
    ); //パスワード設定画面に戻します。
  }

//パスワードロック設定のオンオフを記録
  _isPasswordLock(bool value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isPasswordLock", value);
  }
}