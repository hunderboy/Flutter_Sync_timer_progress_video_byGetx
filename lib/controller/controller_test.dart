import 'package:flutter/material.dart';
import '../widgets/round_button.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

// with GetSingleTickerProviderStateMixin
// with SingleGetTickerProviderMixin
class ControllerTestPlayVideo extends GetxController with SingleGetTickerProviderMixin {

  late AnimationController animation_controller; // 프로그래스바 애니메이션 컨트롤

  String get countText {
    Duration count = animation_controller.duration! * animation_controller.value;
    return animation_controller.isDismissed
        ? '${(animation_controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(animation_controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  RxDouble progress = 0.0.obs;
  RxBool isPlaying = false.obs; // 재생 여부


  /// 끝나는 타이밍에 소리내는 알람을 울린다.
  void notify() {
    if (countText == '00:00') {
      FlutterRingtonePlayer.playNotification(); // '띵' 하는 소리 울림
    }
  }

  // 값 변경은 컨트롤러에 요청하거나, 파라미터로 값을 넘기고 컨트롤러에서 변경한다.
  void playTimer() => isPlaying.value = true;
  void stopTimer() => isPlaying.value = false;





  @override
  void onInit() { // initState
    /// 애니메이션 컨트롤러 초기화
    animation_controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 180), // 초기 60초 설정
    );

    /// 컨트롤러 리스너 설정. 타이머 돌아가는 동안 계속 리스너 내부코드 실행됨
    animation_controller.addListener(() {
      notify(); /// 타이머 끝나면 알림 발생

      /// 타이머 진행중
      if (animation_controller.isAnimating) {
        /// 꺼꾸로 value = (1.0 -> 0.0)
        progress.value = (-(animation_controller.value-1)); /// 프로그래스 바에 연결된 value 변경 실행
        /// 정방향 value = (0.0 -> 1.0)
        // progress.value = animation_controller.value; /// 프로그래스 바에 연결된 value 변경 실행
      }
      /// 타이머 종료
      else {
        isPlaying.value = false;  // 플레잉 중지
        progress.value = 0.0;     // 100% 다 채워지게 한다.
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    animation_controller.dispose();
    super.dispose();
  }


}