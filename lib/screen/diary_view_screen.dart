import 'package:flutter/material.dart';
import 'package:keep_diary/custom_widget/alert_dialog.dart';
import 'package:keep_diary/custom_widget/gallary_photo.dart';
import 'package:keep_diary/screen/diary_re_edit_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../custom_widget/custom_carousel.dart';
import '../helper/file_helper.dart';
import '../main.dart';


class DiaryViewPage extends HookConsumerWidget {
  const DiaryViewPage({Key? key}) : super(key: key);
  static const appBarHeight = 60.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textString = AppLocalizations.of(context);
    final index = ref.watch(currentDiaryProvider);
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;



    return Scaffold(
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
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      flexibleSpace: FlexibleSpaceBar(
                                        title: const Text(''),
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
                                      actions: [
                                        IconButton(
                                            icon: Icon(Icons.delete,
                                              color: ref.watch(
                                                  appBarTitleColorProvider),),
                                            onPressed: () {
                                              showDialog<void>(
                                                  context: context,
                                                  builder: (_) {
                                                    return AlertDelete(key,
                                                        ref.watch(
                                                            currentDiaryProvider),
                                                        ref.watch(
                                                            fontIndexProvider),
                                                            () {});
                                                  });
                                            }
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                            color: ref.watch(
                                                appBarTitleColorProvider),),
                                          onPressed: () =>
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  settings: const RouteSettings(name: 'edit'),
                                                    builder: (context) {
                                                      return DiaryReEditPage(
                                                          key,
                                                          data.title[ref.watch(
                                                              currentDiaryProvider)],
                                                          data.text[ref.watch(
                                                              currentDiaryProvider)],
                                                          data.image[ref.watch(
                                                              currentDiaryProvider)],
                                                          false,
                                                          '',
                                                          '',
                                                          '');
                                                    }
                                                  ,),
                                              ),
                                        ),
                                      ],
                                    )
                                  ]
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                  margin: const EdgeInsets.only(left: 32),
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: FileHelper.fileHelper
                                                  .getFormattedDate(
                                                  ref,
                                                  ref.watch(dateFormatProvider),
                                                  DateTime(
                                                      data.year[index], data
                                                      .month[index],
                                                      data.day[index])),
                                              style: TextStyle(
                                                color: ref.watch(
                                                    theme3Provider),
                                                fontSize: 25,
                                                fontWeight: FontWeight
                                                    .w400,
                                                fontFamily: 'f${ref.watch(
                                                    fontIndexProvider)}',)),
                                        ],
                                      )
                                  )
                              ),
                              if(data.image[index].isNotEmpty)
                                SizedBox(
                                    width: deviceWidth,
                                    height: 250,
                                    child:
                                    Carousel(
                                      indicatorColor: ref.watch(theme6Provider),
                                      // インジケーターの色
                                      indicatorAlignment: const Alignment(
                                          0, .7),
                                      // インジケーターの位置
                                      pages: [
                                        // ここにスクロールさせたい Widget を複数並べる
                                        for(int i = 0; i < data.image[index]
                                            .length; i++)
                                          InkWell(
                                            onTap: () {
                                              open(ref, context, i, index);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 32,
                                                  right: 32,
                                                  bottom: 20,
                                                  top: 20),
                                              decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius
                                                      .all(
                                                    Radius.circular(10),
                                                  ),
                                                  color: ref.watch(
                                                      theme2Provider),
                                                  image: DecorationImage(
                                                      image: Image
                                                          .file(
                                                          File(data
                                                              .image[index][i]))
                                                          .image,
                                                      fit: BoxFit.cover
                                                  )
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                      ],
                                    )
                                ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(
                                    left: 32, right: 32, bottom: 10, top: 10),
                                child: SelectableText(
                                  data.title[index],
                                  style: TextStyle(
                                    fontSize: ref.watch(fontSizeDiaryProvider) *
                                        1.0,
                                    fontFamily: 'f${ref.watch(
                                        fontIndexProvider)}',
                                    fontWeight: FontWeight.w400,
                                    color: ref.watch(theme5Provider),
                                  ),
                                ),
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
                                child: SelectableText(
                                  data.text[index],
                                  style: TextStyle(
                                    fontSize: ref.watch(fontSizeDiaryProvider) *
                                        1.0,
                                    fontFamily: 'f${ref.watch(
                                        fontIndexProvider)}',
                                    fontWeight: FontWeight.w400,
                                    color: ref.watch(theme5Provider),
                                  ),
                                ),
                              ),
                            ]
                        )
                    )),
                Row(
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(
                          Icons.chevron_left,
                          color: ref.watch(theme3Provider),
                        ),
                        label: const Text(''),
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: ref.watch(theme3Provider),
                            backgroundColor: ref.watch(theme2Provider),
                            minimumSize: Size(deviceWidth / 2, 50),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0),
                              ),
                            )
                        ),
                        onPressed: () {
                          int newIndex = index - 1;
                          if (0 <= newIndex && newIndex < data.year.length) {
                            ref
                                .watch(currentDiaryProvider.notifier)
                                .state = newIndex;
                            ref
                                .watch(currentPickImageProvider.notifier)
                                .state = data.image[newIndex];
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                settings: const RouteSettings(name: 'view'),
                                pageBuilder: (context, animation,
                                    secondaryAnimation) {
                                  return DiaryViewPage(key: key,);
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const double begin = 0.0;
                                  const double end = 1.0;
                                  final Animatable<double> tween = Tween(
                                      begin: begin, end: end)
                                      .chain(CurveTween(curve: Curves.linear));
                                  final Animation<
                                      double> doubleAnimation = animation.drive(
                                      tween);
                                  return FadeTransition(
                                    opacity: doubleAnimation,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(
                                    milliseconds: 200),
                              ),
                            );
                          } else {
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(
                              msg: '${textString?.oldest}',
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          }
                        },
                      ),
                      ElevatedButton.icon(
                        icon: Icon(
                          Icons.chevron_right,
                          color: ref.watch(theme3Provider),
                        ),
                        label: const Text(''),
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: ref.watch(theme3Provider),
                            backgroundColor: ref.watch(theme2Provider),
                            minimumSize: Size(deviceWidth / 2, 50),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0),
                              ),
                            )
                        ),
                        onPressed: () {
                          int newIndex = index + 1;
                          if (0 <= newIndex && newIndex < data.year.length) {
                            ref
                                .watch(currentDiaryProvider.notifier)
                                .state = newIndex;
                            ref
                                .watch(currentPickImageProvider.notifier)
                                .state = data.image[newIndex];
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                settings: const RouteSettings(name: 'view'),
                                pageBuilder: (context, animation,
                                    secondaryAnimation) {
                                  return DiaryViewPage(key: key,);
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const double begin = 0.0;
                                  const double end = 1.0;
                                  final Animatable<double> tween = Tween(
                                      begin: begin, end: end)
                                      .chain(CurveTween(curve: Curves.linear));
                                  final Animation<
                                      double> doubleAnimation = animation.drive(
                                      tween);
                                  return FadeTransition(
                                    opacity: doubleAnimation,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(
                                    milliseconds: 200),
                              ),
                            );
                          } else {
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(
                              msg: '${textString?.newest}',
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          }
                        },
                      ),
                    ])
              ]),
        )
    );
  }

  void open(WidgetRef ref, BuildContext context, final int i,
      final int curDiaryIndex) {
    final List<GalleryItem> galleryItems = [];
    for (int n = 0; n < data.image[curDiaryIndex].length; n++) {
      galleryItems.add(
          GalleryItem(path: data.image[curDiaryIndex][n]));
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GalleryPhotoViewWrapper(
              galleryItems: galleryItems,
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              initialIndex: i,
              scrollDirection: Axis.horizontal,
            ),
      ),
    );
  }
}