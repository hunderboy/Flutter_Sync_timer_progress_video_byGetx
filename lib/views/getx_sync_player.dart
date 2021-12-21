import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_progressbar_getx_sycn/controller/controller_test.dart';
import 'package:timer_progressbar_getx_sycn/controller/controller_video_player.dart';
import 'package:timer_progressbar_getx_sycn/widgets/round_button.dart';
import 'package:video_player/video_player.dart';



class GetxSyncPlayer extends StatelessWidget {
  const GetxSyncPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ControllerVideoPlayer());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(
            child: AspectRatio(
              aspectRatio: 16 / 9, // 영상 비율에 맞춤 : Get.find<ControllerVideoPlayer>().controller.value.aspectRatio
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(Get.find<ControllerVideoPlayer>().controller),
                  _ControlsOverlay(controller: Get.find<ControllerVideoPlayer>().controller),
                  // VideoProgressIndicator(Get.find<ControllerVideoPlayer>().controller, allowScrubbing: true), // 하단 프로그래스바
                ],
              ),
            ),
          ),


        ]),
      ),
    );


  }



}


/// 비디오 컨트롤러
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
