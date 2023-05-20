import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';
import '../custom_widget/alert_dialog_quit.dart';
import '../custom_widget/input_pass.dart';
import '../helper/file_helper.dart';
import '../main.dart';
import 'diary_view_screen.dart';

var _itemScrollController = ItemScrollController();
var _itemPositionsListener = ItemPositionsListener.create();
var _initialized=false;
var _selected=DateTime.now();
var _wordList=<String>[];
var _lastM=0;
var _flg=false;

class CalenderPage extends ConsumerStatefulWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  CalenderState createState() => CalenderState();
}

class CalenderState extends ConsumerState<CalenderPage> {
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
    final password = prefs.getString('lockPassword') ?? '';
    final valid = prefs.getBool("isPasswordLock") ?? false;
    print(password + " " + valid.toString());
    if (valid) {
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
    var sampleEvents = {};
    for(int i=0;i<data.year.length;i++) {
      sampleEvents.addAll(
          {DateTime.utc(data.year[i], data.month[i], data.day[i]): [data.title[i]]});
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_flg) {
        _flg = true;
        ref
            .watch(passwordProvider.notifier)
            .state = password;
        ref
            .watch(passwordValidProvider.notifier)
            .state = valid;

        ref
            .watch(searchIndexListProvider.notifier)
            .state = [];
        for (int i = 0; i < _wordList.length; i++) {
          if (_wordList[i].contains(
              DateFormat("yyyy/M/d").format(DateTime.now()))) {
            ref
                .watch(searchIndexListProvider.notifier)
                .state
                .add(i); // 今回の問題はここ！！！
          }
        }
      }
    });

    _wordList.clear();
    for (int i = 0; i < data.year.length; i++) {
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
        .top+MediaQuery
        .of(context)
        .padding
        .bottom;
    const sidePadding = .0;

    return WillPopScope(child:
      Focus(
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
                                height: deviceHeight - appBarHeight * 2 -
                                    statusBarHeight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 16,),
                                    TableCalendar(
                                      headerStyle: HeaderStyle(
                                        leftChevronVisible: false,
                                        rightChevronVisible: false,
                                        titleCentered: true,
                                        titleTextStyle: TextStyle(
                                            fontFamily: 'f${ref.watch(
                                                fontIndexProvider)}',
                                            color: ref.watch(theme3Provider)),
                                        formatButtonTextStyle: TextStyle(
                                            fontFamily: 'f${ref.watch(
                                                fontIndexProvider)}',
                                            color: ref.watch(theme3Provider)),
                                      ),
                                        eventLoader: (date) {
                                          return sampleEvents[date] ?? [];
                                        },
                                      locale: Localizations
                                          .localeOf(context)
                                          .languageCode,
                                      firstDay: DateTime.utc(2022, 4, 1),
                                      lastDay: DateTime.utc(2032, 12, 31),
                                      calendarFormat: ref.watch(
                                          calendarFormatProvider),
                                      calendarStyle: CalendarStyle(
                                        markerDecoration: BoxDecoration(color: ref.watch(darkMord)?Colors.white:Colors.black,shape: BoxShape.circle),
                                      ),
                                      calendarBuilders: CalendarBuilders(
                                          dowBuilder: (_, day) {
                                            final text = DateFormat.E(
                                                Localizations
                                                    .localeOf(context)
                                                    .languageCode).format(
                                                day);
                                            return Center(
                                              child: Text(
                                                text,
                                                style: TextStyle(
                                                    fontFamily: 'f${ref.watch(
                                                        fontIndexProvider)}',
                                                    color: ref.watch(
                                                        theme3Provider)),
                                              ),
                                            );
                                          },
                                          todayBuilder: (_, day, __) {
                                            final text = day.day.toString();
                                            const margin = EdgeInsets.all(6.0);
                                            const padding = EdgeInsets.all(0);
                                            const alignment = Alignment.center;
                                            const duration = Duration(
                                                milliseconds: 250);
                                            return AnimatedContainer(
                                              duration: duration,
                                              margin: margin,
                                              padding: padding,
                                              decoration: BoxDecoration(
                                                  color: ref.watch(
                                                      theme1Provider),
                                                  border: Border.all(
                                                      color: ref.watch(
                                                          theme6Provider),
                                                      width: 1),
                                                  shape: BoxShape.circle
                                              ),
                                              alignment: alignment,
                                              child: Text(
                                                text,
                                                style: TextStyle(
                                                    fontFamily: 'f${ref.watch(
                                                        fontIndexProvider)}',
                                                    color: ref.watch(
                                                        theme3Provider)),
                                              ),
                                            );
                                          },
                                          selectedBuilder: (_, DateTime day,
                                              DateTime focusedDay) {
                                            final text = day.day.toString();
                                            const margin = EdgeInsets.all(6.0);
                                            const padding = EdgeInsets.all(0);
                                            const alignment = Alignment.center;
                                            const duration = Duration(
                                                milliseconds: 250);
                                            return AnimatedContainer(
                                              duration: duration,
                                              margin: margin,
                                              padding: padding,
                                              decoration: BoxDecoration(
                                                color: ref.watch(
                                                    theme6Provider),
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: alignment,
                                              child: Text(
                                                text,
                                                style: TextStyle(
                                                    fontFamily: 'f${ref.watch(
                                                        fontIndexProvider)}',
                                                    color: ref.watch(
                                                        theme3Provider)),
                                              ),
                                            );
                                          },
                                          defaultBuilder: (_, day, day2) {
                                            final text = day.day.toString();
                                            return Center(
                                              child: Text(
                                                text,
                                                style: TextStyle(
                                                    fontFamily: 'f${ref.watch(
                                                        fontIndexProvider)}',
                                                    color: ref.watch(
                                                        theme3Provider)),
                                              ),
                                            );
                                          }

                                      ),
                                      onFormatChanged: (format) {
                                        ref
                                            .watch(
                                            calendarFormatProvider.notifier)
                                            .state = format;
                                      },
                                      selectedDayPredicate: (day) {
                                        return isSameDay(_selected, day);
                                      },
                                      onDaySelected: (selected, focused) {
                                        _selected = selected;

                                        ref
                                            .watch(
                                            calenderDateProvider.notifier)
                                            .state = selected;
                                        ref
                                            .watch(
                                            searchIndexListProvider.notifier)
                                            .state = [];
                                        for (int i = 0; i < _wordList.length; i++) {
                                          if (_wordList[i].contains(
                                              DateFormat("yyyy/M/d").format(
                                                  selected))) {
                                            ref
                                                .watch(searchIndexListProvider
                                                .notifier)
                                                .state
                                                .add(i); // 今回の問題はここ！！！
                                          }
                                        }
                                      },
                                      focusedDay: ref.watch(
                                          calenderDateProvider),
                                    ),
                                    const SizedBox(height: 16,),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ref.watch(theme2Provider),
                                          borderRadius: BorderRadius.circular(
                                              10),),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Flexible(child: Container(
                                                child: _initialized
                                                    ? _searchListView(ref)
                                                    : _defaultListView(ref)
                                            ),
                                            ),
                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                    ),
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
            )
        )
      ),
      onWillPop: ()async{
        showDialog<void>(
            context: context,
            builder: (_) {
              return AlertQuit(null, ref.watch(fontIndexProvider));
            });
        return true;
      },
    );
  }


  Widget _searchListView(WidgetRef ref) {
    if(ref.watch(searchIndexListProvider).isEmpty){
      return Container();
    }
    return ScrollablePositionedList.builder(
        itemCount: ref
            .watch(searchIndexListProvider)
            .length,
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
                          File(data.image[index][0])
                      ),
                      colorFilter: ColorFilter.mode(
                        ref.watch(darkMord)?Colors.black.withOpacity(0.5):Colors.white.withOpacity(0.5), BlendMode.srcATop,),
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
      m = ref
          .watch(searchIndexListProvider).length - m - 1;
      if (m >= 0) {
          m =
          ref
              .watch(searchIndexListProvider)[m];
        if (m != _lastM) {
          ref
              .watch(currentDateProvider.notifier)
              .state = DateTime(data.year[m], data.month[m], data.day[m]);
          _lastM = m;
        }
      }
    });
    for (int i = 0; i < _wordList.length; i++) {
    if (_wordList[i].contains(
    DateFormat("yyyy/M/d").format(
    _selected))) {
    ref
        .watch(searchIndexListProvider
        .notifier)
        .state
        .add(i); // 今回の問題はここ！！！
    }
    }
    _initialized = true;
    if(ref.watch(searchIndexListProvider).isEmpty){
      return Container();
    }
    return ScrollablePositionedList.builder(
        itemCount: ref
            .watch(searchIndexListProvider)
            .length,
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemBuilder: (context, int index) {
          index = ref
              .watch(searchIndexListProvider)
              .length - index - 1;
          index = ref
              .watch(searchIndexListProvider)[index];
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
                        ref.watch(darkMord)?Colors.black.withOpacity(0.5):Colors.white.withOpacity(0.5), BlendMode.srcATop,),
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