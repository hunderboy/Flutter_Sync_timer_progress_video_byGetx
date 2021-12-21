import 'dart:convert';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ControllerVideoPlayer extends GetxController {

  late VideoPlayerController playerController;
  late Future<void> initializeVideoPlayerFuture;

  // 반응형 트리거 사용
  @override
  void onInit() {
    // VideoPlayerController를 저장하기 위한 변수를 만듭니다. VideoPlayerController는
    // asset, 파일, 인터넷 등의 영상들을 제어하기 위해 다양한 생성자를 제공합니다.
    // controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',); // 외부 영상 재생
    playerController = VideoPlayerController.asset('assets/video/sample_abdominal_stretching_cobra.mp4');  // 내부 asset 영상 재생
    // 컨트롤러를 초기화하고 추후 사용하기 위해 Future를 변수에 할당합니다.
    initializeVideoPlayerFuture = playerController.initialize();
    // 비디오를 반복 재생하기 위해 컨트롤러를 사용합니다.
    playerController.setLooping(true);
    super.onInit();
  }

  @override
  void dispose() {
    // 자원을 반환하기 위해 VideoPlayerController를 dispose 시키세요.
    playerController.dispose();
    super.dispose();
  }

  void SetPlayerState() {
    if (playerController.value.isPlaying) {
      playerController.pause();
    } else {
      // 만약 영상이 일시 중지 상태였다면, 재생합니다.
      playerController.play();
    }
  }

}