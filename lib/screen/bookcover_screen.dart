import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:keep_diary/custom_widget/comfirm_pass.dart';
import 'package:keep_diary/screen/settings_screen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../custom_widget/input_pass.dart';
import '../helper/file_helper.dart';
import '../main.dart';
import 'diary_edit_screen.dart';
import 'diary_view_screen.dart';

var _itemScrollController = ItemScrollController();
var _itemPositionsListener = ItemPositionsListener.create();
var _initialized=false;
var _wordList=<String>[];
var _lastM=0;

class BookCoverPage extends ConsumerStatefulWidget {
  const BookCoverPage({Key? key}) : super(key: key);

  @override
  BookCoverPageState createState() => BookCoverPageState();
}

class BookCoverPageState extends ConsumerState<BookCoverPage> {
  static const appBarHeight = 60.0;

  @override
  void initState() {
    super.initState();
    _itemScrollController = ItemScrollController();
    _itemPositionsListener = ItemPositionsListener.create();
    _initialized = false;
    _wordList = <String>[];
    _lastM = 0;
  }


  @override
  Widget build(BuildContext context) {
    final textString = AppLocalizations.of(context);
    final password=prefs.getString('lockPassword') ?? '';
    final valid=prefs.getBool("isPasswordLock") ?? false;
    print(password+" "+valid.toString());
      if(valid) {
        ref.listen<AppLifecycleState>(
          appLifecycleProvider,
              (previous, next) {
            if (next == AppLifecycleState.resumed) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      settings: const RouteSettings(name: 'passcode'),
                      builder: (context) => InputPassword(password: password)),
                      (Route<dynamic> route) {
                    if (route.settings.name != null &&
                        route.settings.name! == 'passcode') {
                      return false;
                    }
                    return true;
                  },
                );
            }
          },
        );
      }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .watch(passwordProvider.notifier)
          .state = password;
      ref
          .watch(passwordValidProvider.notifier)
          .state = valid;
    });

        _wordList.clear();
    for (int i = 0; i <data.year.length; i++) {
      _wordList.add(
          '${data.year[i]}/${data.month[i]}/${data.day[i]}/${data.title[i]}');
    }

    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    const sidePadding = 15.0;

    return Focus(
        child: GestureDetector(
            onTap: () {
              final FocusScopeNode currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
            },
            child: Scaffold(
              body: CustomScrollView(slivers: [
                SliverAppBar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.3),
                  floating: true,
                  pinned: true,
                  snap: false,
                  expandedHeight: appBarHeight,
                  toolbarHeight: appBarHeight,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                        '${textString?.diary}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ref.watch(appBarTitleColorProvider),
                          fontSize: 24,
                          fontWeight: FontWeight
                              .w400,
                          fontFamily: 'f${ref.watch(fontIndexProvider)}',)
                    ),
                    background: SizedBox(
                      width: double.infinity,
                      child:
                      File(ref.watch(appBarImagePath)).existsSync()
                          ? Image.file(
                        File(ref.watch(appBarImagePath)), fit: BoxFit.cover,)
                          : Image.asset(
                        ref.watch(appBarImageDefaultPath), fit: BoxFit.cover,),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.settings_applications,
                        color: ref.watch(appBarTitleColorProvider),),
                      onPressed: () =>
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsPage()),
                          ),
                    ),
                  ],
                ),
                SliverList(
                    delegate: SliverChildListDelegate(
                        <Widget>[
                          Container(
                            color: ref.watch(theme1Provider),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: sidePadding,
                                right: sidePadding,
                                bottom: 15.0,
                              ),

                              child: SizedBox(
                                height: deviceHeight - appBarHeight -
                                    statusBarHeight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 16,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        SizedBox(width: 16,
                                          height: 16,
                                          child: Icon(
                                            Icons.article,
                                            color: ref.watch(theme3Provider),
                                            size: 16,),),
                                        const SizedBox(width: 5,),
                                        SizedBox(width: 40,
                                          height: 23,
                                          child: Text(
                                              '${data.title.length}',
                                              style: TextStyle(fontSize: 16,
                                                  color: ref.watch(
                                                      theme3Provider),
                                                  fontFamily: 'f${ref.watch(
                                                      fontIndexProvider)}',
                                                  fontWeight: FontWeight
                                                      .w400)),),
                                        Flexible(child: _searchTextField(ref)),
                                        const SizedBox(width: 8,),
                                        SizedBox(width: 60,
                                          height: 60,
                                          child: IconButton(
                                            onPressed: () {
                                              ref.watch(currentPickImageProvider.notifier).state=[];
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  settings: const RouteSettings(name: 'edit'),
                                                  pageBuilder: (context,
                                                      animation,
                                                      secondaryAnimation) {
                                                    return DiaryEditPage(null,'','',const [],false);
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
                                              );
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: ref.watch(theme3Provider),
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16,),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                              alignment: Alignment.topCenter,
                                              child:
                                              Container(
                                                  width: 100,
                                                  height: 120,
                                                  alignment: Alignment.center,
                                                  child: Consumer(
                                                      builder: (context, ref,
                                                          _) {
                                                        var curDate = ref.watch(
                                                            currentDateProvider);
                                                        return RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text: ' ${curDate
                                                                        .year} \n',
                                                                    style: TextStyle(
                                                                      color: ref
                                                                          .watch(
                                                                          theme3Provider),
                                                                      fontSize: 19,
                                                                      fontWeight: FontWeight
                                                                          .w300,
                                                                      fontFamily: 'f${ref
                                                                          .watch(
                                                                          fontIndexProvider)}',)),
                                                                TextSpan(
                                                                    text: '${curDate
                                                                        .month}.${curDate
                                                                        .day}\n',
                                                                    style: TextStyle(
                                                                      color: ref
                                                                          .watch(
                                                                          theme3Provider),
                                                                      fontSize: getAppropriateFontSize(
                                                                          ref
                                                                              .watch(
                                                                              fontIndexProvider)) *
                                                                          1.0,
                                                                      fontWeight: FontWeight
                                                                          .w300,
                                                                      fontFamily: 'f${ref
                                                                          .watch(
                                                                          fontIndexProvider)}',)),
                                                                TextSpan(
                                                                    text: week[ref
                                                                        .watch(
                                                                        weekFormatProvider)][curDate
                                                                        .weekday],
                                                                    style: TextStyle(
                                                                      color: ref
                                                                          .watch(
                                                                          theme3Provider),
                                                                      fontSize: 30,
                                                                      fontWeight: FontWeight
                                                                          .w300,
                                                                      fontFamily: 'f${ref
                                                                          .watch(
                                                                          fontIndexProvider)}',))
                                                              ],
                                                            )
                                                        );
                                                      })
                                              )
                                          ),
                                          Flexible(
                                              child: _initialized
                                                  ? _searchListView(ref)
                                                  : _defaultListView(ref)
                                          )
                                        ],
                                      ),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]
                    )
                )
              ],
                shrinkWrap: false,
                physics: const NeverScrollableScrollPhysics(),
              ),
            )));
  }


  Widget _searchTextField(WidgetRef ref) {
    return TextField(
      cursorColor: ref.watch(theme3Provider),
      style: TextStyle(color: ref.watch(theme3Provider), fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search, color: ref.watch(theme3Provider), size: 16,),
        filled: true,
        fillColor: ref.watch(theme2Provider),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(0),
      ),
      onChanged: (String text) {
        ref.watch(searchIndexListProvider.notifier).state = [];
        for (int i = 0; i < _wordList.length; i++) {
          if (text == '' || _wordList[i].contains(text)) {
            ref.watch(searchIndexListProvider.notifier).state.add(i); // 今回の問題はここ！！！
          }
        }
      },
    );
  }


  Widget _searchListView(WidgetRef ref) {
    return ScrollablePositionedList.builder(
        itemCount: ref
            .watch(searchIndexListProvider)
            .length,
        padding: const EdgeInsets.only(left: 16),
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemBuilder: (context, int index) {
          index = ref
              .watch(searchIndexListProvider)
              .length - index - 1;
          index = ref
              .watch(searchIndexListProvider.notifier)
              .state[index];
          return Card(
            color: ref.watch(theme2Provider),
            shadowColor: Colors.black,
            child: Container(
                height: ref.watch(listHeightProvider) * 1.0,
                decoration: data.image[index].isNotEmpty ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(
                        //  File('/data/user/0/com.forestocean.keepdiary/app_flutter/appBar/images (6).jpg'),
                          File(data.image[index][0])
                      ),
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.5), BlendMode.srcATop,),
                      fit: BoxFit.cover,
                    )) :
                BoxDecoration(
                  borderRadius: BorderRadius.circular(10),),
                child:
                ListTile(
                  onTap: () {
                    ref
                        .watch(currentDiaryProvider.notifier)
                        .state = index;
                    ref
                        .watch(currentPickImageProvider.notifier)
                        .state = data.image[index];
                    Navigator.of(context).push(
                        PageRouteBuilder(
                          settings: const RouteSettings(name: 'view'),
                          pageBuilder: (context, animation,
                              secondaryAnimation) {
                            return const DiaryViewPage();
                          },
                          transitionsBuilder: (context, animation,
                              secondaryAnimation, child) {
                            const double begin = 0.0;
                            const double end = 1.0;
                            final Animatable<double> tween = Tween(
                                begin: begin, end: end)
                                .chain(CurveTween(curve: Curves.easeInOut));
                            final Animation<double> doubleAnimation = animation
                                .drive(tween);
                            return FadeTransition(
                              opacity: doubleAnimation,
                              child: child,
                            );
                          },
                        )
                    );
                  },
                  title: RichText(
                      maxLines: ref.watch(listMaxLinesProvider),
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: '${FileHelper.fileHelper.getFormattedDate(
                                  ref, ref.watch(dateFormatProvider), DateTime(
                                  data.year[index], data.month[index],
                                  data.day[index]))}\n',
                              style: TextStyle(
                                color: ref.watch(theme4Provider),
                                fontSize: ref.watch(fontSizeListProvider) * 1.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'f${ref.watch(
                                    fontIndexProvider)}',)),
                          TextSpan(
                              text: data.title[index],
                              style: TextStyle(
                                color: ref.watch(theme4Provider),
                                fontSize: ref.watch(fontSizeListProvider) * 1.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'f${ref.watch(
                                    fontIndexProvider)}',)),
                        ],
                      )
                  ),
                )
            ),
          );
        });
  }


  Widget _defaultListView(WidgetRef ref) {
    if (!_initialized) {
      ref
          .watch(searchIndexListProvider.notifier)
          .state
          .clear();
    }
    _itemPositionsListener.itemPositions.addListener(() {
      final visibleIndexes = _itemPositionsListener.itemPositions.value
          .toList()
          .map((itemPosition) => itemPosition.index);
      int m = visibleIndexes.isNotEmpty ? visibleIndexes.reduce(min) : -1;
      m = data.year.length - m - 1;
      if (m >= 0) {
        m =
        ref
            .watch(searchIndexListProvider.notifier)
            .state[m];
        if (m != _lastM) {
          ref
              .watch(currentDateProvider.notifier)
              .state = DateTime(data.year[m], data.month[m], data.day[m]);
          _lastM = m;
        }
      }
    });
    for (int i = 0; i < _wordList.length; i++) {
      ref
          .watch(searchIndexListProvider.notifier)
          .state
          .add(i);
    }
    _initialized = true;
    return ScrollablePositionedList.builder(
        itemCount: ref
            .watch(searchIndexListProvider)
            .length,
        padding: const EdgeInsets.only(left: 16),
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemBuilder: (context, int index) {
          index = ref
              .watch(searchIndexListProvider.notifier)
              .state[index];
          index = ref
              .watch(searchIndexListProvider)
              .length - index - 1;
          return Card(
            color: ref.watch(theme2Provider),
            shadowColor: Colors.black,
            child: Container(
                height: data.height[index] * 1.0,
                decoration: data.image[index].isNotEmpty ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(
                        //  File('/data/user/0/com.forestocean.keepdiary/app_flutter/appBar/images (6).jpg'),
                          File(data.image[index][0])
                      ),
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.5), BlendMode.srcATop,),
                      fit: BoxFit.cover,
                    )) :
                BoxDecoration(
                  borderRadius: BorderRadius.circular(10),),
                child:
                ListTile(
                  onTap: () {
                    ref
                        .watch(currentDiaryProvider.notifier)
                        .state = index;
                    ref
                        .watch(currentPickImageProvider.notifier)
                        .state = data.image[index];
                    Navigator.of(context).push(
                        PageRouteBuilder(
                          settings: const RouteSettings(name: 'view'),
                          pageBuilder: (context, animation,
                              secondaryAnimation) {
                            return const DiaryViewPage();
                          },
                          transitionsBuilder: (context, animation,
                              secondaryAnimation, child) {
                            const double begin = 0.0;
                            const double end = 1.0;
                            final Animatable<double> tween = Tween(begin: begin,
                                end: end)
                                .chain(CurveTween(curve: Curves.easeInOut));
                            final Animation<double> doubleAnimation = animation
                                .drive(tween);
                            return FadeTransition(
                              opacity: doubleAnimation,
                              child: child,
                            );
                          },
                        )
                    );
                  },
                  title: RichText(
                      maxLines: ref.watch(listMaxLinesProvider),
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: '${FileHelper.fileHelper.getFormattedDate(
                                  ref, ref.watch(dateFormatProvider), DateTime(
                                  data.year[index], data.month[index],
                                  data.day[index]))}\n',
                              style: TextStyle(
                                color: ref.watch(theme4Provider),
                                fontSize: ref.watch(fontSizeListProvider) * 1.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'f${ref.watch(
                                    fontIndexProvider)}',)),
                          TextSpan(
                              text: data.title[index],
                              style: TextStyle(
                                color: ref.watch(theme4Provider),
                                fontSize: ref.watch(fontSizeListProvider) * 1.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'f${ref.watch(
                                    fontIndexProvider)}',)),
                        ],
                      )
                  ),
                )
            ),
          );
        });
  }

  int getAppropriateFontSize(int i) {
    if (i == 16) {
      return 26;
    } else if (i == 14 || i == 15) {
      return 30;
    } else if (i == 6 || i == 7 || i == 11 || i == 12 || i == 4) {
      return 33;
    } else {
      return 38;
    }
  }
}