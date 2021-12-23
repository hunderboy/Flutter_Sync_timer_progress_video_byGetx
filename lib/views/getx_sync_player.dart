import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_progressbar_getx_sycn/controller/controller_video_player.dart';
import 'package:video_player/video_player.dart';



class GetxSyncPlayer extends GetView<ControllerVideoPlayer> {
  const GetxSyncPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ControllerVideoPlayer());

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
                      _ControlsOverlay(GetxController: controller),
                      // _ControlsOverlay(controller: controller.playerController),
                      // VideoProgressIndicator(controller.playerController, allowScrubbing: true), // 하단 프로그래스바
                    ],
                  ),
                ),
              ),

              /// 프로그래스바
              Obx(() {
                return Column(
                  children: <Widget>[
                    Stack(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 100,
                            child: LinearProgressIndicator(
                              value: controller.progress.value,
                              color: Color(0x6607BEB8),
                              backgroundColor: Colors.transparent,
                            ),
                          ),  // 운동 progress
                          Container(
                            width: double.infinity,
                            height: 100,
                            child: LinearProgressIndicator(
                              value: 0.00,
                              color: Color(0x66c8c8c8),
                              backgroundColor: Colors.transparent,
                            ),
                          ),  // 준비 progress
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child:
                                  Text("${controller.countText.value}", style: TextStyle(fontSize: 18)),  // 운동 타이머
                                ),  // 메인 이미지 운동 제목
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text("운동 타이틀", style: TextStyle(fontSize: 15)), // 운동 제목
                                        ),  // 메인 이미지 운동 제목
                                        // Container(
                                        //   child: Text("오른발", style: TextStyle(fontSize: 12)), // 운동 서브 타이틀
                                        // ),  // 메인 이미지 운동 시간
                                      ]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                    ),
                    const Divider(color: Colors.black38, height: 1,),
                  ],
                );
              }),


            ]
        ),
      ),
    );

  }

}


/// 비디오플레이어 컨트롤러
class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.GetxController}) : super(key: key);

  // final VideoPlayerController playerController;
  final ControllerVideoPlayer GetxController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 10),
          child: Align(
            alignment: Alignment.topRight,
            child:

            Obx(() {
              return
                IconButton(
                  onPressed: () {
                    // playerController.value.isPlaying ? controller.pause() : controller.play();
                    GetxController.SetPlayerState();
                  },
                  icon: Icon(
                    GetxController.isTimerPlaying.value == true ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40.0,
                    semanticLabel: 'Play',
                  ),
                );
            }),

          ),
        ),
      ],
    );
  }

}
