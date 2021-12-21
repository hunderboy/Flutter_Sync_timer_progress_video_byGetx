import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_progressbar_getx_sycn/controller/controller_video_player.dart';
import 'package:video_player/video_player.dart';



class GetxSyncPlayer extends GetView<ControllerVideoPlayer> {
  const GetxSyncPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 비디오 플레이어
              Container(
                child: AspectRatio(
                  aspectRatio: 16 / 9, // 영상 비율에 맞춤 : controller.playerController.value.aspectRatio
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(controller.playerController),
                      _ControlsOverlay(controller: controller.playerController),
                      // VideoProgressIndicator(controller.playerController, allowScrubbing: true), // 하단 프로그래스바
                    ],
                  ),
                ),
              ),

              /// 프로그래스바
              // Obx(() {
              //   return Container(
              //     width: double.infinity,
              //     height: 100,
              //     child: LinearProgressIndicator(
              //       value: controller.progress.value,
              //       color: Color(0x6607BEB8),
              //       backgroundColor: Colors.transparent,
              //     ),
              //   );
              // }),



            ]
        ),
      ),
    );

  }

}


/// 비디오플레이어 컨트롤러
class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 10),
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                controller.value.isPlaying ? controller.pause() : controller.play();
              },
              icon: const Icon(
                Icons.pause,
                color: Colors.white,
                size: 40.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
      ],
    );
  }

}
