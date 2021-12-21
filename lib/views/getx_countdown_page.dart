import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_progressbar_getx_sycn/controller/controller_test.dart';
import 'package:timer_progressbar_getx_sycn/widgets/round_button.dart';

class GetxCountdownPage extends GetView<ControllerTestPlayVideo> {
  const GetxCountdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ControllerTestPlayVideo());

    return Scaffold(
      backgroundColor: Color(0xfff5fbff),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [

                /// 중앙 원형 프로그래스바
                Obx(() {
                  return SizedBox(
                      width: 300,
                      height: 300,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey.shade300,
                        value: controller.progress.value,
                        strokeWidth: 16,
                      ),
                    );
                }),

                /// 쿠퍼티노 타임 피커
                GestureDetector(
                  onTap: () {
                  },
                  /// 선택한 타임 보여지는 Text
                  child: AnimatedBuilder(
                    animation: controller.animation_controller,
                    builder: (context, child) => Text(
                      controller.countText,
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

          Obx(() {
            return Container(
              width: double.infinity,
              height: 100,
              child: LinearProgressIndicator(
                value: controller.progress.value,
                color: Color(0x6607BEB8),
                backgroundColor: Colors.transparent,
              ),
            );
          }),



          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 재생, 일시정지 버튼
                GestureDetector(
                  onTap: () {
                    if (controller.animation_controller.isAnimating) {
                      controller.animation_controller.stop();
                      controller.stopTimer();
                    } else {
                      /// 거꾸로
                      // controller.animation_controller.reverse(
                      //     from: controller.animation_controller.value == 0 ? 1.0 : controller.animation_controller.value);
                      /// 정방향
                      controller.animation_controller.forward(
                          from: controller.animation_controller.value == 0 ? 0.0 : controller.animation_controller.value);

                      controller.playTimer();
                    }
                  },
                  child: Obx(() {
                    return RoundButton(
                        icon: controller.isPlaying.value == true ? Icons.pause : Icons.play_arrow,
                      );
                  }),
                ),
                /// 리셋 버튼
                GestureDetector(
                  onTap: () {
                    controller.animation_controller.reset();
                    controller.stopTimer();
                  },
                  child: const RoundButton(
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
