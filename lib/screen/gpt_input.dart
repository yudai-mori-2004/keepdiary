import 'dart:io';
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:keep_diary/screen/diary_re_edit_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:keep_diary/screen/empty.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../custom_widget/alert_dialog_gptback.dart';
import '../custom_widget/alert_dialog_replace.dart';
import '../main.dart';
import 'diary_edit_screen.dart';
part '../home_screen.g.dart';

String selfIntroduce='a 19-year-old college student.';
int rewardCount=0;

@riverpod
class Messages extends _$Messages {
  @override
  List<OpenAIChatCompletionChoiceMessageModel> build() => [];

  Future<void> sendMessage(String message) async {
    final newUserMessage = OpenAIChatCompletionChoiceMessageModel(
      content: message,
      role: OpenAIChatMessageRole.user,
    );
    state = [
      newUserMessage,
    ];
    final chatCompletion = await OpenAI.instance.chat.create(
      model: 'gpt-3.5-turbo',
      messages:state,
      temperature: 1.0,

    );
    // 結果を追加
    state = [
      chatCompletion.choices.first.message,
    ];
  }
}


class HomeScreen extends HookConsumerWidget {
  HomeScreen(Key? key,this.title,this.text,this.images,this.isRe) : super(key: key) {
    gptTitle = title;
    gptText = text;
    messagesProvider=messagesProvider = AutoDisposeNotifierProvider<Messages,
        List<OpenAIChatCompletionChoiceMessageModel>>.internal(
      Messages.new,
      name: r'messagesProvider',
      debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$messagesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );
  }
  static const appBarHeight = 60.0;
  String title='';
  String text='';
  List<String>images=[];
  String gptTitle='';
  String gptText='';

  bool changed=false;
  bool isRe=false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textString = AppLocalizations.of(context);
    final messageController = useTextEditingController();
    final controller0 = useTextEditingController();
    final controller1 = useTextEditingController();
selfIntroduce=ref.watch(gptIntroduce);
    var message = ref
        .watch(messagesProvider)
        .isNotEmpty ? ref
        .watch(messagesProvider)
        .last
        .content : '';
    message=message.contains(
        '''## template
"::::[Title of diary]::::[Write diary here]::::"'''
    )?'':message;

    if (message.isNotEmpty&&ref.watch(adLoadedProvider)) {
      var vs = message.split(':');
      vs.removeWhere((s) => s == '');
      vs.removeWhere((s) => s == '\n');
      vs.removeWhere((s) => s == '"');
      int i = 0;
      for (var element in vs) {
        element=element.replaceAll('"', '');
        print('$i' + '  ' + element);
        if (i == 0) {
          controller0.value =
              controller0.value.copyWith(
                  text: element);
        } else if (i == 1) {
          controller1.value =
              controller1.value.copyWith(
                  text: element);
        }
        i++;
      }
    }else {
      controller0.value =
          controller0.value.copyWith(text: gptTitle);
      controller1.value =
          controller1.value.copyWith(text: gptText);
    }

    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;

    final isWaiting = useState(false);

    String language = isoLangs[ Localizations
        .localeOf(context)
        .languageCode]!['name']!;

    String template =
    '''## Request
You are a $selfIntroduce. Output a diary based on the following constraints, template and input sentences. 

## constraints
・Write in $language
・Do not write anything that is not in the input text

## template
"::::[Title of diary]::::[Write diary here]::::"

## input
${ref.watch(gptInputProvider)}''';

    return WillPopScope(

        onWillPop: ()async {
          if(changed) {
            showDialog<void>(
                context: context,
                builder: (_) {
                  return AlertGPTBack(key, () {
                    gptTitle=controller0.text;
                    gptText=controller1.text;
                    if (isRe) {
                      Navigator.of(context)
                          .pushAndRemoveUntil(
                        PageRouteBuilder(
                          settings: const RouteSettings(name: 'edit'),
                          pageBuilder: (context,
                              animation,
                              secondaryAnimation) {
                            return DiaryReEditPage(
                                key,'$title\n$gptTitle',
                                '$text\n$gptText',images,true);
                          },
                          transitionsBuilder: (
                              context,
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
                                begin: begin,
                                end: end)
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
                            (Route<dynamic> route) {
                          if (route.settings.name != null && (route.settings.name! == 'view'||route.settings.name! == 'book')) {
                            return true;
                          }
                          return false;
                        },
                      );
                    } else {
                      Navigator.of(context)
                          .pushAndRemoveUntil(
                        PageRouteBuilder(
                          settings: const RouteSettings(name: 'edit'),
                          pageBuilder: (context,
                              animation,
                              secondaryAnimation) {
                            return DiaryEditPage(
                                key, '$title\n$gptTitle',
                                '$text\n$gptText', images,true);
                          },
                          transitionsBuilder: (
                              context,
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
                                begin: begin,
                                end: end)
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
                            (Route<dynamic> route) {
                          if (route.settings.name != null && (route.settings.name! == 'view'||route.settings.name! == 'book')) {
                            return true;
                          }
                          return false;
                        },
                      );
                    }
                      },
                      ref.watch(
                          fontIndexProvider));
                });
          }else {
            Navigator.of(context).pop();
          }
          return true;
        },
    child: Scaffold(
        body:
        Container(
          height: deviceHeight,
          color: ref.watch(theme1Provider),
          child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                            children: [
                              CustomScrollView(
                                  shrinkWrap: true,
                                  primary: false,
                                  slivers: [
                                    SliverAppBar(
                                      backgroundColor: Colors.blueAccent
                                          .withOpacity(0.3),
                                      floating: true,
                                      pinned: true,
                                      snap: false,
                                      expandedHeight: appBarHeight,
                                      toolbarHeight: appBarHeight,
                                      leading: IconButton(
                                        icon: const Icon(Icons.close),
                                        color: ref.watch(
                                            appBarTitleColorProvider),
                                        onPressed: () {
                                          if(changed) {
                                            showDialog<void>(
                                                context: context,
                                                builder: (_) {
                                                  return AlertGPTBack(key, () {
                                                    gptTitle=controller0.text;
                                                    gptText=controller1.text;
                                                    if (isRe) {
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                        PageRouteBuilder(
                                                          settings: const RouteSettings(name: 'edit'),
                                                          pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) {
                                                            return DiaryReEditPage(
                                                                key,'$title\n$gptTitle',
                                                                '$text\n$gptText',images,true);
                                                          },
                                                          transitionsBuilder: (
                                                              context,
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
                                                                begin: begin,
                                                                end: end)
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
                                                            (Route<dynamic> route) {
                                                          if (route.settings.name != null && (route.settings.name! == 'view'||route.settings.name! == 'book')) {
                                                            return true;
                                                          }
                                                          return false;
                                                        },
                                                      );
                                                    } else {
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                        PageRouteBuilder(
                                                          settings: const RouteSettings(name: 'edit'),
                                                          pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) {
                                                            return DiaryEditPage(
                                                                key, '$title\n$gptTitle',
                                                                '$text\n$gptText', images,true);
                                                          },
                                                          transitionsBuilder: (
                                                              context,
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
                                                                begin: begin,
                                                                end: end)
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
                                                            (Route<dynamic> route) {
                                                          if (route.settings.name != null && (route.settings.name! == 'view'||route.settings.name! == 'book')) {
                                                            return true;
                                                          }
                                                          return false;
                                                        },
                                                      );
                                                    }
                                                  },
                                                      ref.watch(
                                                          fontIndexProvider));
                                                });
                                          }else {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                      flexibleSpace: FlexibleSpaceBar(
                                        title: Text('${textString?.auto_diary}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: ref.watch(
                                                  appBarTitleColorProvider),
                                              fontSize: 24,
                                              fontWeight: FontWeight
                                                  .w400,
                                              fontFamily: 'f${ref.watch(
                                                  fontIndexProvider)}',)),
                                        background: SizedBox(
                                          width: double.infinity,
                                          child:
                                          File(ref.watch(appBarImagePath))
                                              .existsSync()
                                              ? Image.file(
                                            File(ref.watch(appBarImagePath)),
                                            fit: BoxFit.cover,)
                                              : Image.asset(
                                            ref.watch(appBarImageDefaultPath),
                                            fit: BoxFit.cover,),
                                        ),
                                      ),
                                    )
                                  ]
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(
                                    left: 32, right: 32, bottom: 10, top: 15),
                                child: Theme(data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                      cursorColor: ref.watch(theme6Provider),
                                      selectionColor: ref.watch(theme6Provider),
                                      selectionHandleColor: ref.watch(
                                          theme6Provider)),
                                ),
                                    child: TextFormField(
                                      autofocus: true,
                                      cursorColor: ref.watch(theme6Provider),
                                      maxLines: null,
                                      controller: messageController,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '${textString
                                            ?.auto_diary_desc}',
                                        hintMaxLines: 8,
                                        hintStyle: TextStyle(
                                            color: ref.watch(theme5Provider)
                                                .withOpacity(0.6)
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: ref.watch(
                                            fontSizeDiaryProvider) *
                                            1.0,
                                        fontFamily: 'f${ref.watch(
                                            fontIndexProvider)}',
                                        fontWeight: FontWeight.w400,
                                        color: ref.watch(theme5Provider),
                                      ),
                                      onChanged: (s) {
                                        changed=true;
                                        ref
                                            .watch(gptInputProvider.notifier)
                                            .state = s;
                                      },
                                    )
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: ref.watch(theme2Provider),
                                  backgroundColor: ref.watch(theme6Provider),
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () async {
                                  if (messageController.text.isEmpty) {
                                    Fluttertoast.cancel();
                                    Fluttertoast.showToast(
                                      msg: '${textString?.empty}',
                                      toastLength: Toast.LENGTH_SHORT,
                                    );
                                  } else {
                                    if(rewardCount==0) {
                                      if (ref.watch(adLoadedProvider)) {
                                        rewardedAd.show(onUserEarnedReward: (
                                            AdWithoutView ad,
                                            RewardItem rewardItem) {
                                          EmptyState.loadAd(ref);
                                          rewardCount +=
                                              rewardItem.amount.toInt();
                                        });
                                      } else {
                                        EmptyState.loadAdAndShow((ad,
                                            rewardItem) {
                                          rewardCount +=
                                              rewardItem.amount.toInt();
                                        }, textString, ref);
                                      }
                                    }else {
                                      rewardCount--;
                                      isWaiting.value = true;
                                      print('Template$template');
                                      await ref.read(messagesProvider.notifier).sendMessage(template);
                                      isWaiting.value = false;
                                    }
                                  }
                                },
                                child: Text('${textString?.gpt_write}',
                                    style: TextStyle(
                                        color: ref.watch(theme3Provider))),
                              ),
                              Text('${textString?.gpt_write_ad}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:'f${ref.watch(fontIndexProvider)}',
                                      color: ref.watch(theme3Provider))),
                              const SizedBox(height: 10,),
                              if (isWaiting.value)
                               IconButton(
                                  onPressed: null,
                                  icon: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(color: ref.watch(theme6Provider),),
                                  ),
                                ),
                              Divider(
                                color: ref.watch(theme6Provider),
                                thickness: 3,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(
                                    left: 32, right: 32, bottom: 10, top: 15),
                                child: Theme(data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                      cursorColor: ref.watch(theme6Provider),
                                      selectionColor: ref.watch(theme6Provider),
                                      selectionHandleColor: ref.watch(
                                          theme6Provider)),
                                ),
                                    child: TextFormField(
                                      autofocus: false,
                                      readOnly: true,
                                      cursorColor: ref.watch(theme6Provider),
                                      maxLines: null,
                                      controller: controller0,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '${textString?.title_hint}',
                                          hintStyle: TextStyle(
                                              color: ref.watch(theme5Provider)
                                                  .withOpacity(0.6))
                                      ),
                                      style: TextStyle(
                                        fontSize: ref.watch(
                                            fontSizeDiaryProvider) *
                                            1.0,
                                        fontFamily: 'f${ref.watch(
                                            fontIndexProvider)}',
                                        fontWeight: FontWeight.w400,
                                        color: ref.watch(theme5Provider),
                                      ),
                                      onChanged: (String s) {

                                      }
                                    )),
                              ),
                              Divider(
                                color: ref.watch(theme2Provider),
                                indent: 32,
                                endIndent: 32,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 32, right: 32, bottom: 35, top: 10),
                                alignment: Alignment.centerLeft,
                                child: Theme(
                                    data: ThemeData(
                                      textSelectionTheme: TextSelectionThemeData(
                                          selectionColor: ref.watch(
                                              theme6Provider)),
                                      colorSchemeSeed: ref.watch(
                                          theme6Provider),
                                    ),
                                    child: TextFormField(
                                      autofocus: true,
                                      readOnly: true,
                                      cursorColor: ref.watch(theme6Provider),
                                      keyboardType: TextInputType.multiline,
                                      controller: controller1,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '${textString?.text_hint}',
                                          hintStyle: TextStyle(
                                              color: ref.watch(theme5Provider)
                                                  .withOpacity(0.6))
                                      ),
                                      style: TextStyle(
                                        fontSize: ref.watch(
                                            fontSizeDiaryProvider) *
                                            1.0,
                                        fontFamily: 'f${ref.watch(
                                            fontIndexProvider)}',
                                        fontWeight: FontWeight.w400,
                                        color: ref.watch(theme5Provider),
                                      ),
                                      onChanged: (String s) {

                                      },
                                    )),
                              ),
                            ]
                        )
                    )),
                Container(
                    color: ref.watch(theme2Provider),
                    width: deviceWidth,
                    child: Row(
                        children: [
                          const Expanded(child: SizedBox(height: 10,)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ref.watch(theme2Provider),
                              backgroundColor: ref.watch(theme6Provider),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              showDialog<void>(
                                  context: context,
                                  builder: (_) {
                                    return AlertReplace(key,
                                            () {
                                              gptTitle=controller0.text;
                                              gptText=controller1.text;
                                              if (isRe) {
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                    PageRouteBuilder(
                                                      settings: const RouteSettings(name: 'edit'),
                                                      pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) {
                                                        return DiaryReEditPage(
                                                            key, gptTitle,
                                                            gptText,images,true);
                                                      },
                                                      transitionsBuilder: (
                                                          context,
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
                                                            begin: begin,
                                                            end: end)
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
                                                      (Route<dynamic> route) {
                                                        if (route.settings.name != null && (route.settings.name! == 'view'||route.settings.name! == 'book')) {
                                                          return true;
                                                        }
                                                        return false;
                                                      },
                                                );
                                              } else {
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                    PageRouteBuilder(
                                                      settings: const RouteSettings(name: 'edit'),
                                                      pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) {
                                                        return DiaryEditPage(
                                                            key, gptTitle,
                                                            gptText,images,true);
                                                      },
                                                      transitionsBuilder: (
                                                          context,
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
                                                            begin: begin,
                                                            end: end)
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
                                                      (Route<dynamic> route) {
                                                    if (route.settings.name != null && (route.settings.name! == 'view'||route.settings.name! == 'book')) {
                                                      return true;
                                                    }
                                                    return false;
                                                  },
                                                );
                                              }
                                            },
                                        ref.watch(
                                            fontIndexProvider));
                                  });
                            },
                            child: Text('${textString?.replace}',
                                style: TextStyle(
                                    color: ref.watch(theme3Provider))),
                          ),
                          const SizedBox(width: 15,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ref.watch(theme2Provider),
                              backgroundColor: ref.watch(theme6Provider),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              gptTitle=controller0.text;
                              gptText=controller1.text;
                              if (isRe) {
                                Navigator.of(context)
                                    .pushAndRemoveUntil(
                                    PageRouteBuilder(
                                      settings: const RouteSettings(name: 'edit'),
                                      pageBuilder: (context,
                                          animation,
                                          secondaryAnimation) {
                                        return DiaryReEditPage(
                                            key,'$title\n$gptTitle',
                                            '$text\n$gptText',images,true);
                                      },
                                      transitionsBuilder: (
                                          context,
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
                                            begin: begin,
                                            end: end)
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
                                      (Route<dynamic> route) {
                                    if (route.settings.name != null && (route.settings.name! == 'view'||route.settings.name! == 'book')) {
                                      return true;
                                    }
                                    return false;
                                  },
                                );
                              } else {
                                Navigator.of(context)
                                    .pushAndRemoveUntil(
                                    PageRouteBuilder(
                                      settings: const RouteSettings(name: 'edit'),
                                      pageBuilder: (context,
                                          animation,
                                          secondaryAnimation) {
                                        return DiaryEditPage(
                                            key, '$title\n$gptTitle',
                                            '$text\n$gptText', images,true);
                                      },
                                      transitionsBuilder: (
                                          context,
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
                                            begin: begin,
                                            end: end)
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
                                      (Route<dynamic> route) {
                                    if (route.settings.name != null && (route.settings.name! == 'view'||route.settings.name! == 'book')) {
                                      return true;
                                    }
                                    return false;
                                  },
                                );
                              }
                            },
                            child: Text('${textString?.add}',
                                style: TextStyle(
                                    color: ref.watch(theme3Provider))),
                          ),
                        ])
                )
              ]),
        )
    ));
  }


  static const isoLangs = {
    "ab": {"name": "Abkhaz", "nativeName": "аҧсуа"},
    "aa": {"name": "Afar", "nativeName": "Afaraf"},
    "af": {"name": "Afrikaans", "nativeName": "Afrikaans"},
    "ak": {"name": "Akan", "nativeName": "Akan"},
    "sq": {"name": "Albanian", "nativeName": "Shqip"},
    "am": {"name": "Amharic", "nativeName": "አማርኛ"},
    "ar": {"name": "Arabic", "nativeName": "العربية"},
    "an": {"name": "Aragonese", "nativeName": "Aragonés"},
    "hy": {"name": "Armenian", "nativeName": "Հայերեն"},
    "as": {"name": "Assamese", "nativeName": "অসমীয়া"},
    "av": {"name": "Avaric", "nativeName": "авар мацӀ, магӀарул мацӀ"},
    "ae": {"name": "Avestan", "nativeName": "avesta"},
    "ay": {"name": "Aymara", "nativeName": "aymar aru"},
    "az": {"name": "Azerbaijani", "nativeName": "azərbaycan dili"},
    "bm": {"name": "Bambara", "nativeName": "bamanankan"},
    "ba": {"name": "Bashkir", "nativeName": "башҡорт теле"},
    "eu": {"name": "Basque", "nativeName": "euskara, euskera"},
    "be": {"name": "Belarusian", "nativeName": "Беларуская"},
    "bn": {"name": "Bengali", "nativeName": "বাংলা"},
    "bh": {"name": "Bihari", "nativeName": "भोजपुरी"},
    "bi": {"name": "Bislama", "nativeName": "Bislama"},
    "bs": {"name": "Bosnian", "nativeName": "bosanski jezik"},
    "br": {"name": "Breton", "nativeName": "brezhoneg"},
    "bg": {"name": "Bulgarian", "nativeName": "български език"},
    "my": {"name": "Burmese", "nativeName": "ဗမာစာ"},
    "ca": {"name": "Catalan; Valencian", "nativeName": "Català"},
    "ch": {"name": "Chamorro", "nativeName": "Chamoru"},
    "ce": {"name": "Chechen", "nativeName": "нохчийн мотт"},
    "ny": {
      "name": "Chichewa; Chewa; Nyanja",
      "nativeName": "chiCheŵa, chinyanja"
    },
    "zh": {"name": "Chinese", "nativeName": "中文 (Zhōngwén), 汉语, 漢語"},
    "cv": {"name": "Chuvash", "nativeName": "чӑваш чӗлхи"},
    "kw": {"name": "Cornish", "nativeName": "Kernewek"},
    "co": {"name": "Corsican", "nativeName": "corsu, lingua corsa"},
    "cr": {"name": "Cree", "nativeName": "ᓀᐦᐃᔭᐍᐏᐣ"},
    "hr": {"name": "Croatian", "nativeName": "hrvatski"},
    "cs": {"name": "Czech", "nativeName": "česky, čeština"},
    "da": {"name": "Danish", "nativeName": "dansk"},
    "dv": {"name": "Divehi; Dhivehi; Maldivian;", "nativeName": "ދިވެހި"},
    "nl": {"name": "Dutch", "nativeName": "Nederlands, Vlaams"},
    "en": {"name": "English", "nativeName": "English"},
    "eo": {"name": "Esperanto", "nativeName": "Esperanto"},
    "et": {"name": "Estonian", "nativeName": "eesti, eesti keel"},
    "ee": {"name": "Ewe", "nativeName": "Eʋegbe"},
    "fo": {"name": "Faroese", "nativeName": "føroyskt"},
    "fj": {"name": "Fijian", "nativeName": "vosa Vakaviti"},
    "fi": {"name": "Finnish", "nativeName": "suomi, suomen kieli"},
    "fr": {"name": "French", "nativeName": "français, langue française"},
    "ff": {
      "name": "Fula; Fulah; Pulaar; Pular",
      "nativeName": "Fulfulde, Pulaar, Pular"
    },
    "gl": {"name": "Galician", "nativeName": "Galego"},
    "ka": {"name": "Georgian", "nativeName": "ქართული"},
    "de": {"name": "German", "nativeName": "Deutsch"},
    "el": {"name": "Greek, Modern", "nativeName": "Ελληνικά"},
    "gn": {"name": "Guaraní", "nativeName": "Avañeẽ"},
    "gu": {"name": "Gujarati", "nativeName": "ગુજરાતી"},
    "ht": {"name": "Haitian; Haitian Creole", "nativeName": "Kreyòl ayisyen"},
    "ha": {"name": "Hausa", "nativeName": "Hausa, هَوُسَ"},
    "he": {"name": "Hebrew (modern)", "nativeName": "עברית"},
    "hz": {"name": "Herero", "nativeName": "Otjiherero"},
    "hi": {"name": "Hindi", "nativeName": "हिन्दी, हिंदी"},
    "ho": {"name": "Hiri Motu", "nativeName": "Hiri Motu"},
    "hu": {"name": "Hungarian", "nativeName": "Magyar"},
    "ia": {"name": "Interlingua", "nativeName": "Interlingua"},
    "id": {"name": "Indonesian", "nativeName": "Bahasa Indonesia"},
    "ie": {
      "name": "Interlingue",
      "nativeName": "Originally called Occidental; then Interlingue after WWII"
    },
    "ga": {"name": "Irish", "nativeName": "Gaeilge"},
    "ig": {"name": "Igbo", "nativeName": "Asụsụ Igbo"},
    "ik": {"name": "Inupiaq", "nativeName": "Iñupiaq, Iñupiatun"},
    "io": {"name": "Ido", "nativeName": "Ido"},
    "is": {"name": "Icelandic", "nativeName": "Íslenska"},
    "it": {"name": "Italian", "nativeName": "Italiano"},
    "iu": {"name": "Inuktitut", "nativeName": "ᐃᓄᒃᑎᑐᑦ"},
    "ja": {"name": "Japanese", "nativeName": "日本語 (にほんご／にっぽんご)"},
    "jv": {"name": "Javanese", "nativeName": "basa Jawa"},
    "kl": {
      "name": "Kalaallisut, Greenlandic",
      "nativeName": "kalaallisut, kalaallit oqaasii"
    },
    "kn": {"name": "Kannada", "nativeName": "ಕನ್ನಡ"},
    "kr": {"name": "Kanuri", "nativeName": "Kanuri"},
    "ks": {"name": "Kashmiri", "nativeName": "कश्मीरी, كشميري‎"},
    "kk": {"name": "Kazakh", "nativeName": "Қазақ тілі"},
    "km": {"name": "Khmer", "nativeName": "ភាសាខ្មែរ"},
    "ki": {"name": "Kikuyu, Gikuyu", "nativeName": "Gĩkũyũ"},
    "rw": {"name": "Kinyarwanda", "nativeName": "Ikinyarwanda"},
    "ky": {"name": "Kirghiz, Kyrgyz", "nativeName": "кыргыз тили"},
    "kv": {"name": "Komi", "nativeName": "коми кыв"},
    "kg": {"name": "Kongo", "nativeName": "KiKongo"},
    "ko": {"name": "Korean", "nativeName": "한국어 (韓國語), 조선말 (朝鮮語)"},
    "ku": {"name": "Kurdish", "nativeName": "Kurdî, كوردی‎"},
    "kj": {"name": "Kwanyama, Kuanyama", "nativeName": "Kuanyama"},
    "la": {"name": "Latin", "nativeName": "latine, lingua latina"},
    "lb": {
      "name": "Luxembourgish, Letzeburgesch",
      "nativeName": "Lëtzebuergesch"
    },
    "lg": {"name": "Luganda", "nativeName": "Luganda"},
    "li": {
      "name": "Limburgish, Limburgan, Limburger",
      "nativeName": "Limburgs"
    },
    "ln": {"name": "Lingala", "nativeName": "Lingála"},
    "lo": {"name": "Lao", "nativeName": "ພາສາລາວ"},
    "lt": {"name": "Lithuanian", "nativeName": "lietuvių kalba"},
    "lu": {"name": "Luba-Katanga", "nativeName": ""},
    "lv": {"name": "Latvian", "nativeName": "latviešu valoda"},
    "gv": {"name": "Manx", "nativeName": "Gaelg, Gailck"},
    "mk": {"name": "Macedonian", "nativeName": "македонски јазик"},
    "mg": {"name": "Malagasy", "nativeName": "Malagasy fiteny"},
    "ms": {"name": "Malay", "nativeName": "bahasa Melayu, بهاس ملايو‎"},
    "ml": {"name": "Malayalam", "nativeName": "മലയാളം"},
    "mt": {"name": "Maltese", "nativeName": "Malti"},
    "mi": {"name": "Māori", "nativeName": "te reo Māori"},
    "mr": {"name": "Marathi (Marāṭhī)", "nativeName": "मराठी"},
    "mh": {"name": "Marshallese", "nativeName": "Kajin M̧ajeļ"},
    "mn": {"name": "Mongolian", "nativeName": "монгол"},
    "na": {"name": "Nauru", "nativeName": "Ekakairũ Naoero"},
    "nv": {"name": "Navajo, Navaho", "nativeName": "Diné bizaad, Dinékʼehǰí"},
    "nb": {"name": "Norwegian Bokmål", "nativeName": "Norsk bokmål"},
    "nd": {"name": "North Ndebele", "nativeName": "isiNdebele"},
    "ne": {"name": "Nepali", "nativeName": "नेपाली"},
    "ng": {"name": "Ndonga", "nativeName": "Owambo"},
    "nn": {"name": "Norwegian Nynorsk", "nativeName": "Norsk nynorsk"},
    "no": {"name": "Norwegian", "nativeName": "Norsk"},
    "ii": {"name": "Nuosu", "nativeName": "ꆈꌠ꒿ Nuosuhxop"},
    "nr": {"name": "South Ndebele", "nativeName": "isiNdebele"},
    "oc": {"name": "Occitan", "nativeName": "Occitan"},
    "oj": {"name": "Ojibwe, Ojibwa", "nativeName": "ᐊᓂᔑᓈᐯᒧᐎᓐ"},
    "cu": {
      "name":
      "Old Church Slavonic, Church Slavic, Church Slavonic, Old Bulgarian, Old Slavonic",
      "nativeName": "ѩзыкъ словѣньскъ"
    },
    "om": {"name": "Oromo", "nativeName": "Afaan Oromoo"},
    "or": {"name": "Oriya", "nativeName": "ଓଡ଼ିଆ"},
    "os": {"name": "Ossetian, Ossetic", "nativeName": "ирон æвзаг"},
    "pa": {"name": "Panjabi, Punjabi", "nativeName": "ਪੰਜਾਬੀ, پنجابی‎"},
    "pi": {"name": "Pāli", "nativeName": "पाऴि"},
    "fa": {"name": "Persian", "nativeName": "فارسی"},
    "pl": {"name": "Polish", "nativeName": "polski"},
    "ps": {"name": "Pashto, Pushto", "nativeName": "پښتو"},
    "pt": {"name": "Portuguese", "nativeName": "Português"},
    "qu": {"name": "Quechua", "nativeName": "Runa Simi, Kichwa"},
    "rm": {"name": "Romansh", "nativeName": "rumantsch grischun"},
    "rn": {"name": "Kirundi", "nativeName": "kiRundi"},
    "ro": {"name": "Romanian, Moldavian, Moldovan", "nativeName": "română"},
    "ru": {"name": "Russian", "nativeName": "русский язык"},
    "sa": {"name": "Sanskrit (Saṁskṛta)", "nativeName": "संस्कृतम्"},
    "sc": {"name": "Sardinian", "nativeName": "sardu"},
    "sd": {"name": "Sindhi", "nativeName": "सिन्धी, سنڌي، سندھی‎"},
    "se": {"name": "Northern Sami", "nativeName": "Davvisámegiella"},
    "sm": {"name": "Samoan", "nativeName": "gagana faa Samoa"},
    "sg": {"name": "Sango", "nativeName": "yângâ tî sängö"},
    "sr": {"name": "Serbian", "nativeName": "српски језик"},
    "gd": {"name": "Scottish Gaelic; Gaelic", "nativeName": "Gàidhlig"},
    "sn": {"name": "Shona", "nativeName": "chiShona"},
    "si": {"name": "Sinhala, Sinhalese", "nativeName": "සිංහල"},
    "sk": {"name": "Slovak", "nativeName": "slovenčina"},
    "sl": {"name": "Slovene", "nativeName": "slovenščina"},
    "so": {"name": "Somali", "nativeName": "Soomaaliga, af Soomaali"},
    "st": {"name": "Southern Sotho", "nativeName": "Sesotho"},
    "es": {"name": "Spanish; Castilian", "nativeName": "español, castellano"},
    "su": {"name": "Sundanese", "nativeName": "Basa Sunda"},
    "sw": {"name": "Swahili", "nativeName": "Kiswahili"},
    "ss": {"name": "Swati", "nativeName": "SiSwati"},
    "sv": {"name": "Swedish", "nativeName": "svenska"},
    "ta": {"name": "Tamil", "nativeName": "தமிழ்"},
    "te": {"name": "Telugu", "nativeName": "తెలుగు"},
    "tg": {"name": "Tajik", "nativeName": "тоҷикӣ, toğikī, تاجیکی‎"},
    "th": {"name": "Thai", "nativeName": "ไทย"},
    "ti": {"name": "Tigrinya", "nativeName": "ትግርኛ"},
    "bo": {
      "name": "Tibetan Standard, Tibetan, Central",
      "nativeName": "བོད་ཡིག"
    },
    "tk": {"name": "Turkmen", "nativeName": "Türkmen, Түркмен"},
    "tl": {"name": "Tagalog", "nativeName": "Wikang Tagalog, ᜏᜒᜃᜅ᜔ ᜆᜄᜎᜓᜄ᜔"},
    "tn": {"name": "Tswana", "nativeName": "Setswana"},
    "to": {"name": "Tonga (Tonga Islands)", "nativeName": "faka Tonga"},
    "tr": {"name": "Turkish", "nativeName": "Türkçe"},
    "ts": {"name": "Tsonga", "nativeName": "Xitsonga"},
    "tt": {"name": "Tatar", "nativeName": "татарча, tatarça, تاتارچا‎"},
    "tw": {"name": "Twi", "nativeName": "Twi"},
    "ty": {"name": "Tahitian", "nativeName": "Reo Tahiti"},
    "ug": {"name": "Uighur, Uyghur", "nativeName": "Uyƣurqə, ئۇيغۇرچە‎"},
    "uk": {"name": "Ukrainian", "nativeName": "українська"},
    "ur": {"name": "Urdu", "nativeName": "اردو"},
    "uz": {"name": "Uzbek", "nativeName": "zbek, Ўзбек, أۇزبېك‎"},
    "ve": {"name": "Venda", "nativeName": "Tshivenḓa"},
    "vi": {"name": "Vietnamese", "nativeName": "Tiếng Việt"},
    "vo": {"name": "Volapük", "nativeName": "Volapük"},
    "wa": {"name": "Walloon", "nativeName": "Walon"},
    "cy": {"name": "Welsh", "nativeName": "Cymraeg"},
    "wo": {"name": "Wolof", "nativeName": "Wollof"},
    "fy": {"name": "Western Frisian", "nativeName": "Frysk"},
    "xh": {"name": "Xhosa", "nativeName": "isiXhosa"},
    "yi": {"name": "Yiddish", "nativeName": "ייִדיש"},
    "yo": {"name": "Yoruba", "nativeName": "Yorùbá"},
    "za": {"name": "Zhuang, Chuang", "nativeName": "Saɯ cueŋƅ, Saw cuengh"}
  };
}
