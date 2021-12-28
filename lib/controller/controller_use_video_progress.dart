import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';



class ControllerUseVideoProgress extends GetxController with GetSingleTickerProviderStateMixin {

  /// Player code ------------------------------------------------------------------------------------------------
  late VideoPlayerController playerController;
  late Future<void> initializeVideoPlayerFuture;

  /// Animation code ------------------------------------------------------------------------------------------------
  late AnimationController animationController; // 프로그래스바 애니메이션 컨트롤

  /// RxString countText
  /// 값이 변화 될때만 아래 코드가 동작한다.
  // RxString get countText {
  //   // ( playerController.value.position.inSeconds/playerController.value.duration.inSeconds )
  //   // 현재 : playerController.value.position.inSeconds
  //   // 총 : playerController.value.duration.inSeconds
  //   /// 여기서 count의 의미는 무었인가?
  //   /// count는 계속 변한다.
  //
  //   Duration count = animationController.duration! * animationController.value;
  //   print("비디오 플레이 중?? = "+playerController.value.isPlaying.toString());
  //
  //   /// 영상이 재생중인지 true or false
  //   // return playerController.value.isPlaying
  //   //     ? '${(playerController.value.position.inMinutes % 60).toString().padLeft(2, '0')}:${(playerController.value.position.inSeconds % 60).toString().padLeft(2, '0')}'.obs
  //   //     : '${(playerController.value.duration.inMinutes % 60).toString().padLeft(2, '0')}:${(playerController.value.duration.inSeconds % 60).toString().padLeft(2, '0')}'.obs;
  //
  //   return
  //   '${(playerController.value.position.inMinutes % 60).toString().padLeft(2, '0')}:${(playerController.value.position.inSeconds % 60).toString().padLeft(2, '0')}'.obs;
  // }
  RxString countText = ''.obs;

  RxDouble progress = 0.0.obs;  // progressIndicator 가 진행될때 적용될 값
  RxBool isTimerPlaying = false.obs; // CountDown 이 실행중인지 아닌지

  // 끝나는 타이밍에 소리내는 알람을 울린다.
  void notify() {
    print("countText == 00:00");
    FlutterRingtonePlayer.playNotification(); // '띵' 하는 소리 울림
    isTimerPlaying.value = false;  // 플레잉 중지
    progress.value = 0.0;     // 100% 다 채워지게 한다.
    playerController.pause();
  }


  bool progressbarSwich = false;







  @override
  void onInit() {

    /// Player code ------------------------------------------------------------------------------------------------
    // VideoPlayerController를 저장하기 위한 변수를 만듭니다. VideoPlayerController는
    // asset, 파일, 인터넷 등의 영상들을 제어하기 위해 다양한 생성자를 제공합니다.
    // controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',); // 외부 영상 재생
    playerController = VideoPlayerController.asset('assets/video/sample_abdominal_stretching_cobra.mp4');  // 내부 asset 영상 재생
    // 컨트롤러를 초기화하고 추후 사용하기 위해 Future를 변수에 할당합니다.
    initializeVideoPlayerFuture = playerController.initialize();
    // 비디오를 반복 재생하기 위해 컨트롤러를 사용합니다.
    // playerController.setLooping(true);

    playerController.addListener(() {
      // print("현재 재생 inSeconds  = "+playerController.value.position.inSeconds.toString());

      countText.value = '${(playerController.value.position.inMinutes % 60).toString().padLeft(2, '0')}:${(playerController.value.position.inSeconds % 60).toString().padLeft(2, '0')}';
      print("현재 재생 inSeconds  = "+ countText.value);

    });


    /// Animation code ------------------------------------------------------------------------------------------------
    /// 애니메이션 컨트롤러 초기화
    animationController = AnimationController(
      vsync: this,
      // duration: Duration(seconds: 20), // 초기 60초 설정
      duration: playerController.value.duration
    );


    animationController.addListener(() {
      if (animationController.isAnimating) {
        /// 역방향 value = (1.0 -> 0.0)
        // progress.value = (-(animationController.value-1)); /// 프로그래스 바에 연결된 value 변경 실행
        progress.value = 1-animationController.value; /// 프로그래스 바에 연결된 value 변경 실행
        /// 정방향 value = (0.0 -> 1.0)
        // progress.value = animationController.value; /// 프로그래스 바에 연결된 value 변경 실행
      }
      // else{
      //   // 스위치 on off
      //   if(progressbarSwich){ // true 이면
      //     progressbarSwich = false;
      //     notify();
      //   } else {
      //     progressbarSwich = true;
      //   }
      // }

      print(animationController.status.toString());

    });


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
    if (playerController.value.isPlaying) { // 플레이어가 플레이 중인가?
      isTimerPlaying.value = false;
      playerController.pause(); // 일시정지
      animationController.stop();
    } else {
      // 만약 영상이 일시 중지 상태였다면, 재생합니다.
      isTimerPlaying.value = true;
      playerController.play();  // 재생
      /// 프로그래스바 역방향 진행
      animationController.reverse(
          from: animationController.value == 0 ? 1.0 : animationController.value);
    }
  }

}