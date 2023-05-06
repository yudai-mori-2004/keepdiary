import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:keep_diary/main.dart';
import 'package:keep_diary/screen/calender_screen.dart';
import 'package:keep_diary/screen/settings_screen.dart';

import 'bookcover_screen.dart';

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
    return Scaffold(
      body: _pageList[_selectedIndex],
      bottomNavigationBar: Container(
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