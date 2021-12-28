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


  RxString countDownText = ''.obs;    // 카운트 다운 타이머 텍스트
  RxDouble progress = 0.0.obs;        // progressIndicator 가 진행될때 적용될 값
  RxBool isTimerPlaying = false.obs;  // CountDown 이 실행중인지 아닌지

  // 끝나는 타이밍에 소리내는 알람을 울린다.
  void notify() {
    print("countText == 00:00");
    FlutterRingtonePlayer.playNotification(); // '띵' 하는 소리 울림
    isTimerPlaying.value = false;  // 플레잉 중지
    progress.value = 0.0;     // 100% 다 채워지게 한다.
    playerController.pause();
  }


  bool progressbarSwich = false;


  /// 운동 (중:true),(전후:false) 변수
  // 운동 중 : true (운동 일시정지 상태에도 true 이다.)
  // 운동 시작 전, 운동 종료 후 : false
  bool exercieseBegin = false;
  /// 카운트다운 시 남아 있는 시간 정보
  late int remainMinutes;
  late int remainSeconds;






  @override
  void onInit() {

    /// Player code ------------------------------------------------------------------------------------------------
    playerController = VideoPlayerController.asset('assets/video/sample_abdominal_stretching_cobra.mp4');  // 내부 asset 영상 재생
    // 컨트롤러를 초기화하고 추후 사용하기 위해 Future를 변수에 할당합니다.
    initializeVideoPlayerFuture = playerController.initialize();

    // 컨트롤러 리스너 적용 : 재생중에는 계속 리스너 코드 내용이 반복 실행됨.
    playerController.addListener(() {
      if(exercieseBegin){ /// 운동 중
        // print("재생중 = "+playerController.value.isPlaying.toString());
        remainMinutes = playerController.value.duration.inMinutes-playerController.value.position.inMinutes;
        remainSeconds = playerController.value.duration.inSeconds-playerController.value.position.inSeconds;

        // print("duration 재생중 : "+playerController.value.duration.toString());

        countDownText.value = '${(remainMinutes % 60).toString().padLeft(2, '0')}:${(remainSeconds % 60).toString().padLeft(2, '0')}';
        progress.value = 1-playerController.value.position.inSeconds.toDouble();
      }
      else{ /// 운동 전후
        // print("운동 시작전");
        countDownText.value = '${(playerController.value.duration.inMinutes % 60).toString().padLeft(2, '0')}:${(playerController.value.duration.inSeconds % 60).toString().padLeft(2, '0')}';

      }

      /// 운동 끝
      if(playerController.value.position == playerController.value.duration){
        // print("재생이 완료.");
        exercieseBegin = false;
      }
    });




    /// Animation code ------------------------------------------------------------------------------------------------
    /// 애니메이션 컨트롤러 초기화
    animationController = AnimationController(
      vsync: this,
      // duration: Duration(seconds: 20), // 초기 60초 설정
      duration: playerController.value.duration // 값설정을 어떻게 하느냐에 따라.
    );

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
      exercieseBegin = true;

      // 만약 영상이 일시 중지 상태였다면, 재생합니다.
      isTimerPlaying.value = true;
      playerController.play();  // 재생
      /// 프로그래스바 역방향 진행
      animationController.reverse(
          from: animationController.value == 0 ? 1.0 : animationController.value);
    }
  }

  void Setinit() async {
    initializeVideoPlayerFuture = await playerController.initialize();
  }

}