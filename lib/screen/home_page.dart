import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:keep_diary/main.dart';
import 'package:keep_diary/screen/calender_screen.dart';
import 'package:keep_diary/screen/settings_screen.dart';

import 'bookcover_screen.dart';
import 'diary_edit_screen.dart';
import 'diary_re_edit_screen.dart';
import 'gpt_input.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const appBarHeight = 60.0;
  int _selectedIndex = 0;

// 表示する Widget の一覧
  static final List<Widget> _pageList = [
    const BookCoverPage(),
    const CalenderPage(),
    const SettingsPage()
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
            },)
        );
        if(prefs.getBool("e_gpt_editing")??false) {
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (context, animation,
                    secondaryAnimation) {
                  return HomeScreen(
                    null,
                    prefs.getString('e_gpt_title') ?? '',
                    prefs.getString('e_gpt_text') ?? '',
                    lst,
                    true,
                    prefs.getString('e_gpt') ?? '',
                  );
                }),
          );
        }
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
      if(prefs.getBool("e_gpt_editing")??false) {
        Navigator.of(context).push(
          PageRouteBuilder(
              pageBuilder: (context, animation,
                  secondaryAnimation) {
                return HomeScreen(
                  null,
                  prefs.getString('e_gpt_title') ?? '',
                  prefs.getString('e_gpt_text') ?? '',
                  lst,
                  true,
                  prefs.getString('e_gpt') ?? '',
                );
              }),
        );
      }
    });

    return Scaffold(
      body: _pageList[_selectedIndex],
      bottomNavigationBar: SizedBox(

        child: BottomNavigationBar(
          backgroundColor:  ref.watch(theme1Provider),
          showSelectedLabels: false,
          showUnselectedLabels: false,
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