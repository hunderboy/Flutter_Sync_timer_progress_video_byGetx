import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';



class ControllerVideoPlayer extends GetxController with SingleGetTickerProviderMixin {

/// Player code ------------------------------------------------------------------------------------------------
  late VideoPlayerController playerController;
  late Future<void> initializeVideoPlayerFuture;

/// Animation code ------------------------------------------------------------------------------------------------
  late AnimationController animation_controller; // 프로그래스바 애니메이션 컨트롤

  // CountDown Text : 00:02 형태로 카운트 다운
  RxString get countText {
    Duration count = animation_controller.duration! * animation_controller.value;
    return animation_controller.isDismissed
        ? '${(animation_controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(animation_controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'.obs
        : '${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}'.obs;
  }

  RxDouble progress = 0.0.obs;  // progressIndicator 가 진행될때 적용될 값
  RxBool isPlaying = false.obs; // CountDown 이 실행중인지 아닌지

  // 끝나는 타이밍에 소리내는 알람을 울린다.
  void notify() {
    if (countText == '00:00') {
      FlutterRingtonePlayer.playNotification(); // '띵' 하는 소리 울림
    }
  }

  // 값 변경은 컨트롤러에 요청하거나, 파라미터로 값을 넘기고 컨트롤러에서 변경한다.
  void playTimer() => isPlaying.value = true;
  void stopTimer() => isPlaying.value = false;






  @override
  void onInit() {
/// Animation code ------------------------------------------------------------------------------------------------
    /// 애니메이션 컨트롤러 초기화
    animation_controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30), // 초기 60초 설정
    );

    /// 컨트롤러 리스너 설정. 타이머 돌아가는 동안 계속 리스너 내부코드 실행됨
    animation_controller.addListener(() {
      notify(); /// 타이머 끝나면 알림 발생

      /// 타이머 진행중
      if (animation_controller.isAnimating) {
        /// 꺼꾸로 value = (1.0 -> 0.0)
        // progress.value = (-(animation_controller.value-1)); /// 프로그래스 바에 연결된 value 변경 실행
        /// 정방향 value = (0.0 -> 1.0)
        progress.value = animation_controller.value; /// 프로그래스 바에 연결된 value 변경 실행
      }
      /// 타이머 종료
      else {
        isPlaying.value = false;  // 플레잉 중지
        progress.value = 0.0;     // 100% 다 채워지게 한다.
      }
    });


/// Player code ------------------------------------------------------------------------------------------------
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
    // 자원을 반환하기 위해 Controller 들은 dispose 시키세요.
    playerController.dispose();
    animation_controller.dispose();
    super.dispose();
  }

  void SetPlayerState() {
    if (playerController.value.isPlaying) {
      playerController.pause(); // 일시정지
      animation_controller.stop();

    } else {
      // 만약 영상이 일시 중지 상태였다면, 재생합니다.
      playerController.play();  // 재생
      /// 정방향
      animation_controller.forward(
          from: animation_controller.value == 0 ? 0.0 : animation_controller.value);

    }
  }

}