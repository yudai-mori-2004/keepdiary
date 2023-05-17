import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:keep_diary/main.dart';
import 'package:keep_diary/screen/calender_screen.dart';
import 'package:keep_diary/screen/settings_screen.dart';

import 'bookcover_screen.dart';
import 'diary_edit_screen.dart';
import 'diary_re_edit_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const appBarHeight = 60.0;
  int _selectedIndex = 0;

// 表示する Widget の一覧
  static final List<Widget> _pageList = [
    BookCoverPage(),
    CalenderPage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      int eInd = (prefs.getInt('e_index') ?? -10);
      var lst = prefs.getStringList('e_image') ?? [];
      ref
          .watch(currentPickImageProvider.notifier)
          .state = [...lst];
      if (eInd == -10) {} else if (eInd == -1) {
        Navigator.of(context).push(
          PageRouteBuilder(
            settings: const RouteSettings(
                name: 'edit'),
            pageBuilder: (context,
                animation,
                secondaryAnimation) {
              return DiaryEditPage(
                  null,
                  prefs.getString('e_title') ?? '',
                  prefs.getString('e_text') ?? '',
                  lst,
                  true,
                  prefs.getString('e_gpt') ?? '',
                  prefs.getString('e_gpt_text') ?? '',
                  prefs.getString('e_gpt_title') ?? '');
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
      } else {
        ref
            .watch(currentDiaryProvider.notifier)
            .state = eInd;
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: 'edit'),
            builder: (context) {
              return DiaryReEditPage(
                  null,
                  prefs.getString('e_title') ?? '',
                  prefs.getString('e_text') ?? '',
                  lst,
                  true,
                  prefs.getString('e_gpt') ?? '',
                  prefs.getString('e_gpt_text') ?? '',
                  prefs.getString('e_gpt_title') ?? '');
            }
            ,),
        );
      }
    });

    return Scaffold(
      body: _pageList[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: appBarHeight,
        child: BottomNavigationBar(
          backgroundColor:  ref.watch(theme1Provider),
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: ref.watch(theme3Provider),),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month,color: ref.watch(theme3Provider)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: ref.watch(theme3Provider)),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}