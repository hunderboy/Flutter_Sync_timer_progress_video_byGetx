import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/round_button.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> with TickerProviderStateMixin {
  late AnimationController controller; // 프로그래스바 애니메이션 컨트롤
  bool isPlaying = false; // 재생 여부
  double progress = 0.0; // 프로그래스 바 value


  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
? '${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
: '${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }


  /// 끝나는 타이밍에 소리내는 알람을 울린다.
  void notify() {
    if (countText == '00:00') {
      FlutterRingtonePlayer.playNotification(); // '띵' 하는 소리 울림
    }
  }

  @override
  void initState() {
    super.initState();
    /// 애니메이션 컨트롤러 초기화
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60), // 초기 60초 설정
    );

    /// 컨트롤러 리스너 설정. 타이머 돌아가는 동안 계속 리스너 내부코드 실행됨
    controller.addListener(() {
      notify(); /// 타이머 끝나면 알림 발생

      /// 타이머 진행중
      if (controller.isAnimating) {
        setState(() {
          progress = -(controller.value-1); /// 프로그래스 바에 연결된 value 변경 실행
        });
      }
      /// 타이머 종료
      else {
        setState(() {
          progress = 0.0;     // 100% 다 채워지게 한다.
          isPlaying = false;  // 플레잉 중지
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5fbff),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// 중앙 원형 프로그래스바
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey.shade300,
                    value: progress,
                    strokeWidth: 16,
                  ),
                ),
                /// 쿠퍼티노 타임 피커
                GestureDetector(
                  onTap: () {
                    if (controller.isDismissed) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 300,
                          child: CupertinoTimerPicker(
                            initialTimerDuration: controller.duration!,
                            onTimerDurationChanged: (time) {
                              setState(() {
                                controller.duration = time;
                              });
                            },
                          ),
                        ),
                      );
                    }
                  },
                  /// 선택한 타임 보여지는 Text
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) => Text(
                      countText,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            height: 100,
            child: LinearProgressIndicator(
              value: progress,
              color: Color(0x6607BEB8),
              backgroundColor: Colors.transparent,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 재생, 일시정지 버튼
                GestureDetector(
                  onTap: () {
                    if (controller.isAnimating) {
                      controller.stop();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      controller.reverse(
                          from: controller.value == 0 ? 1.0 : controller.value);
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  child: RoundButton(
                    icon: isPlaying == true ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                /// 리셋 버튼
                GestureDetector(
                  onTap: () {
                    controller.reset();
                    setState(() {
                      isPlaying = false;
                    });
                  },
                  child: RoundButton(
                    icon: Icons.stop,
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }


}
