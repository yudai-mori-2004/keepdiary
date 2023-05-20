import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keep_diary/custom_widget/gallary_photo.dart';
import 'package:keep_diary/screen/bookcover_screen.dart';
import 'package:keep_diary/structure/data_structure.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../custom_widget/alert_dialog.dart';
import '../custom_widget/alert_dialog_edit.dart';
import '../custom_widget/alert_dialog_re_back.dart';
import '../custom_widget/custom_carousel.dart';
import '../helper/file_helper.dart';
import '../main.dart';
import '../screen/settings_screen.dart';
import 'gpt_input.dart';
import 'home_page.dart';


late String e_title;
late String e_text;
late List<String>e_image;
late int e_day;
late int e_month;
late int e_year;
late int e_height=80;

bool _imageSaved=true;

class DiaryEditPage extends HookConsumerWidget with WidgetsBindingObserver {
  DiaryEditPage(Key? key,String title,String text,List<String> images,bool changed,this.gptMessage,this.gptText,this.gptTitle) : super(key: key){
    e_title=title;
    e_text=text;
    e_image=images;
    isChanged=changed;
  }
  static const appBarHeight = 60.0;
  bool isChanged=false;
  late String gptMessage;
  late String gptTitle;
  late String gptText;

  bool isThisScreenEnable=true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (DateTime
        .now()
        .hour < ref.watch(dateUpdateTimeProvider)) {
      final t = DateTime.now().add(const Duration(days: -1));
      e_day = t.day;
      e_month = t.month;
      e_year = t.year;
    } else {
      final t = DateTime.now();
      e_day = t.day;
      e_month = t.month;
      e_year = t.year;
    }

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

    final controller0 = useTextEditingController();
    controller0.value = controller0.value.copyWith(text: e_title);

    final controller1 = useTextEditingController();
    controller1.value = controller1.value.copyWith(text: e_text);

    WidgetsBinding.instance.removeObserver(this);
    WidgetsBinding.instance.addObserver(this);

    return WillPopScope(
        onWillPop: ()async {
          if (isChanged) {
            showDialog<void>(
                context: context,
                builder: (_) {
                  return AlertReBack(key,
                          () {
                        data.addDiary(
                            e_year,
                            e_month,
                            e_day,
                            DateTime.now(),
                            e_height,
                            e_title,
                            e_text,
                            ref.watch(currentPickImageProvider)
                        );
                        dataBox.put(dataBoxName, data);
                        removeEditing();

                        isThisScreenEnable=false;
                        Navigator.of(context)
                            .pushAndRemoveUntil(
                            PageRouteBuilder(
                              settings: const RouteSettings(name: 'book'),
                              pageBuilder: (context,
                                  animation,
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
                                (_) => false
                        );
                      },
                      ref.watch(
                          fontIndexProvider));
                });
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
                                          if(isChanged) {
                                            showDialog<void>(
                                              context: context,
                                              builder: (_) {
                                                return AlertReBack(key,
                                                        () {
                                                          data.addDiary(
                                                              e_year,
                                                              e_month,
                                                              e_day,
                                                              DateTime.now(),
                                                              e_height,
                                                              e_title,
                                                              e_text,
                                                              ref.watch(
                                                                  currentPickImageProvider)
                                                          );
                                                          dataBox.put(
                                                              dataBoxName,
                                                              data);
                                                          removeEditing();

                                                          isThisScreenEnable=false;
                                                          Navigator.of(context)
                                                              .pushAndRemoveUntil(
                                                              PageRouteBuilder(
                                                                settings: const RouteSettings(
                                                                    name: 'book'),
                                                                pageBuilder: (
                                                                    context,
                                                                    animation,
                                                                    secondaryAnimation) {
                                                                  return HomePage();
                                                                },
                                                                transitionsBuilder: (
                                                                    context,
                                                                    animation,
                                                                    secondaryAnimation,
                                                                    child) {
                                                                  const Offset begin = Offset(
                                                                      0.0,
                                                                      1.0); // 下から上
                                                                  // final Offset begin = Offset(0.0, -1.0); // 上から下
                                                                  const Offset end = Offset
                                                                      .zero;
                                                                  final Animatable<
                                                                      Offset> tween = Tween(
                                                                      begin: begin,
                                                                      end: end)
                                                                      .chain(
                                                                      CurveTween(
                                                                          curve: Curves
                                                                              .easeInOut));
                                                                  final Animation<
                                                                      Offset> offsetAnimation = animation
                                                                      .drive(
                                                                      tween);
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
                                                        },
                                                    ref.watch(
                                                        fontIndexProvider));
                                              });
                                          }else{
                                            isThisScreenEnable=false;
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                      flexibleSpace: FlexibleSpaceBar(
                                        title:Text('${textString?.write}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: ref.watch(appBarTitleColorProvider),
                                              fontSize: 24,
                                              fontWeight: FontWeight
                                                  .w400,
                                              fontFamily: 'f${ref.watch(fontIndexProvider)}',)),
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
                                                  return AlertDeleteEdit(key,
                                                          () {
                                                        removeEditing();
                                                      },
                                                      ref.watch(
                                                          fontIndexProvider));
                                                });
                                          }
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
                                                      e_year, e_month, e_day)),
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
                                      keyboardType: TextInputType.multiline,
                                      controller: controller0,
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
                                        e_title = s;
                                        isChanged=true;
                                      },
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
                                      cursorColor: ref.watch(theme6Provider),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      controller: controller1,
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
                                        e_text = s;
                                        isChanged=true;
                                      },
                                    )),
                              ),
                            ]
                        )
                    )),
                if(ref
                    .watch(currentPickImageProvider)
                    .isNotEmpty)
    Container(
    height: 100,
    width: deviceWidth,
    color: ref.watch(theme2Provider),
    child:
    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for(int i = 0; i < ref
                                    .watch(currentPickImageProvider)
                                    .length; i++)
                                  MaterialButton(
                                    padding: const EdgeInsets.all(8.0),
                                    textColor: Colors.black,
                                    elevation: 8.0,
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius
                                            .all(
                                          Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: FileImage(File(ref.watch(
                                              currentPickImageProvider)[i])),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                            Colors.white.withOpacity(0.4),
                                            BlendMode.srcATop,),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(.0),
                                        child: Icon(Icons.close_outlined,
                                          color: ref.watch(theme3Provider),),
                                      ),
                                    ),
                                    onPressed: () {
                                      var vs = ref.watch(
                                          currentPickImageProvider);
                                      vs.removeAt(i);
                                      ref
                                          .watch(
                                          currentPickImageProvider.notifier)
                                          .state = [...vs];
                                      e_image=[...vs];
                                      isChanged=true;
                                    },
                                  ),
                              ])
                      ),),
                Container(
                    color: ref.watch(theme2Provider),
                    width: deviceWidth,
                    child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                pickImageAndSave(ref);
                              },
                              iconSize: 35,
                              icon: Icon(
                                Icons.photo_rounded,
                                color: ref.watch(theme3Provider),
                              )
                          ),
                          const Expanded(child: SizedBox(height: 10,)),
                          IconButton(
                              onPressed: (){
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return HomeScreen(key,
                                          gptTitle.isEmpty ? e_title : gptTitle,
                                          gptText.isEmpty ? e_text : gptText,
                                          e_image, false, gptMessage);
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const double begin = 0.0;
                                      const double end = 1.0;
                                      final Animatable<double> tween = Tween(
                                          begin: begin, end: end)
                                          .chain(
                                          CurveTween(curve: Curves.linear));
                                      final Animation<
                                          double> doubleAnimation = animation
                                          .drive(
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
                              },
                              iconSize: 35,
                              icon: Icon(
                                Icons.psychology,
                                color: ref.watch(theme3Provider),
                              )
                          ),
                          const Expanded(child: SizedBox(height: 10,)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ref.watch(theme2Provider),
                              backgroundColor: ref.watch(theme6Provider),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              data.addDiary(
                                  e_year,
                                  e_month,
                                  e_day,
                                  DateTime.now(),
                                  e_height,
                                  e_title,
                                  e_text,
                                ref.watch(currentPickImageProvider)
                                  );
                              dataBox.put(dataBoxName, data);
                              removeEditing();

                              isThisScreenEnable=false;
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
                            },
                            child: Text('${textString?.save}',
                                style: TextStyle(
                                    color: ref.watch(theme3Provider))),
                          ),
                        ])
                )
              ]),
        )
    ));
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

  Future pickImageAndSave(WidgetRef ref) async {
    try {
      print(_imageSaved);
      _imageSaved = false;
      final localPath = FileHelper.fileHelper.localPath;
      final multi_image = await ImagePicker().pickMultiImage();
      if (multi_image.isEmpty) return;
      for(XFile image in multi_image) {
        final dir = await FileHelper.fileHelper.createDir(
            Directory('$localPath/diary'));
        final im = File(image.path);
        final savedPath = await FileHelper.fileHelper.saveImageAt(im, dir);
        var vs = ref.watch(currentPickImageProvider);
        vs.add(savedPath);
        ref
            .watch(currentPickImageProvider.notifier)
            .state = [...vs];
        e_image = [...vs];
        _imageSaved = true;
        isChanged = true;
        print(_imageSaved);
        print(savedPath);
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        saveEditing();
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }

  Future<void> saveEditing() async {
    print("save executed!!1");
    if( !isThisScreenEnable)return;
    WidgetsBinding.instance.removeObserver(this);
    await prefs.setInt("e_index", -1);

    await prefs.setString("e_title", e_title);
    await prefs.setString('e_text', e_text);
    await prefs.setStringList('e_image',e_image );
    await prefs.setInt('e_height', e_height);
  }

  Future<void> removeEditing() async {
    WidgetsBinding.instance.removeObserver(this);
    await prefs.remove("e_index");

    await prefs.remove("e_title");
    await prefs.remove('e_text');
    await prefs.remove('e_image');
    await prefs.remove('e_height');
    e_title='';
    e_image=[];
    e_text='';
    e_height=80;
  }
}