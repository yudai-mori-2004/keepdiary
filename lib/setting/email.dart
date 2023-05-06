import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../../main.dart';
import '../../screen/settings_screen.dart';

class SendMailSetting extends HookConsumerWidget {
  SendMailSetting({Key? key}) : super(key: key);
  static const appBarHeight = 60.0;

  final TextEditingController _bodyController=TextEditingController(text: '');
  final TextEditingController _subjectController=TextEditingController(text:'Title : Keep Diary');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textString = AppLocalizations.of(context);
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: ref.watch(theme1Provider),
        body:
        SizedBox(
            height: deviceHeight,
            child: Column(
                children: [
                  CustomScrollView(
                      shrinkWrap: true,
                      primary: false,
                      slivers: [
                        SliverAppBar(
                          backgroundColor: Colors.blueAccent.withOpacity(0.3),
                          floating: true,
                          pinned: true,
                          snap: false,
                          expandedHeight: appBarHeight,
                          toolbarHeight: appBarHeight,
                          leading: BackButton(
                            color: ref.watch(
                                appBarTitleColorProvider), // <-- SEE HERE
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                                '${textString?.format_of_week}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ref.watch(appBarTitleColorProvider),
                                  fontSize: 24,
                                  fontWeight: FontWeight
                                      .w400,
                                  fontFamily: 'f${ref.watch(
                                      fontIndexProvider)}',)
                            ),
                            background: SizedBox(
                              width: double.infinity,
                              child:
                              File(ref.watch(appBarImagePath)).existsSync()
                                  ? Image.file(
                                File(ref.watch(appBarImagePath)),
                                fit: BoxFit.cover,)
                                  : Image.asset(
                                ref.watch(appBarImageDefaultPath),
                                fit: BoxFit.cover,),
                            ),
                          ),
                        )
                      ]),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text('${textString?.mail}'
                              ,style: TextStyle(color: ref.watch(theme4Provider))),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _subjectController
                              ,style: TextStyle(color: ref.watch(theme4Provider)),
                            decoration: InputDecoration(hintText: '${textString?.title_mail}'),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _bodyController
                              ,style: TextStyle(color: ref.watch(theme4Provider)),
                            decoration: InputDecoration(hintText: '${textString?.content_mail}'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: _sendEmail, child: Text( '${textString?.send}',style: TextStyle(color: ref.watch(theme4Provider)))),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  )
                ]
            )
        )
    );
  }

  Future<void> _sendEmail() async {
    final email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: ['jukai.reviews@gmail.com'],
      cc: [],
      bcc: [],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}