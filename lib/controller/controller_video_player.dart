import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';



class ControllerVideoPlayer extends GetxController with GetSingleTickerProviderStateMixin {

/// Player code ------------------------------------------------------------------------------------------------
  late VideoPlayerController playerController;
  late Future<void> initializeVideoPlayerFuture;

/// Animation code ------------------------------------------------------------------------------------------------
  late AnimationController animationController; // 프로그래스바 애니메이션 컨트롤

  // CountDown Text : 00:02 형태로 카운트 다운
  RxString get countText {
    Duration count = animationController.duration! * animationController.value;
    return animationController.isDismissed
        ? '${(animationController.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(animationController.duration!.inSeconds % 60).toString().padLeft(2, '0')}'.obs
        : '${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}'.obs;
  }

  RxDouble progress = 0.0.obs;  // progressIndicator 가 진행될때 적용될 값
  RxBool isTimerPlaying = false.obs; // CountDown 이 실행중인지 아닌지

  // 끝나는 타이밍에 소리내는 알람을 울린다.
  void notify() {
    if (countText == "00:00") {
      print("countText == 00:00");
      FlutterRingtonePlayer.playNotification(); // '띵' 하는 소리 울림

    }
  }






  @override
  void onInit() {
/// Animation code ------------------------------------------------------------------------------------------------
    /// 애니메이션 컨트롤러 초기화
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // 초기 60초 설정
    );

    
    animationController.addListener(() {
      notify(); /// 타이머 끝나면 알림 발생


      /// 타이머 진행중
      if (animationController.isAnimating) {
        /// 역방향 value = (1.0 -> 0.0)
        progress.value = (-(animationController.value-1)); /// 프로그래스 바에 연결된 value 변경 실행
        /// 정방향 value = (0.0 -> 1.0)
        // progress.value = animationController.value; /// 프로그래스 바에 연결된 value 변경 실행
      }
      /// 타이머 종료
      else {
        // 타이머 시작하면 무조건 1번은 거친다. (거치면안되는데.. 그래서)
        print("타이머 종료코드 통과");
        print("${progress.value}"); // 무조건 1번 거칠때 progress.value = 0.0 이다.

        /// 그래서 progress.value = 0.0 이 아닐 경우에만 아래 코드가 실행되도록 한다.
        if (progress.value == 1.0){
          print("progress 1.0");
          // isTimerPlaying.value = false;  // 플레잉 중지
          // progress.value = 0.0;     // 100% 다 채워지게 한다.
          // playerController.pause();
        }
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
    // playerController.setLooping(true);
    super.onInit();
  }

  @override
  void dispose() {
    // 자원을 반환하기 위해 Controller 들은 dispose 시키세요.
    playerController.dispose();
    animationController.dispose();
    super.dispose();
  }

  void SetPlayerState() {
    if (playerController.value.isPlaying) {
      playerController.pause(); // 일시정지
      animationController.stop();
      isTimerPlaying.value = false;
    } else {
      // 만약 영상이 일시 중지 상태였다면, 재생합니다.
      playerController.play();  // 재생
      isTimerPlaying.value = true;
      /// 프로그래스바 역방향 진행
      animationController.reverse(
          from: animationController.value == 0 ? 1.0 : animationController.value);
    }
  }

}