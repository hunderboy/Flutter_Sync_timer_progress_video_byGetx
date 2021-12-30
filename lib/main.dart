import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/bio_auth.dart';
import 'views/bio_auth_page.dart';
import 'views/countdown_page.dart';
import 'views/getx_countdown_page.dart';
import 'views/getx_sync_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Countdown app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: CountdownPage(), // StatefulWidget 을 이용한 카운트 다운
      // home: GetxCountdownPage(), // Getx 를 이용한 카운트 다운 + progressIndicator Sync 맞춤
      // home: GetxSyncPlayer(),   // Getx 를 이용한 카운트 다운 + progressIndicator + Video_player Sync 맞춤
      home: BioAuth(),   // 생체인식 화면
    );
  }
}
