
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:timer_progressbar_getx_sycn/controller/controller_bio_auth.dart';


class BioAuthPage extends GetView<ControllerBioAuth> {
  const BioAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ControllerBioAuth());

    return Scaffold(
        body: Column(
            children: <Widget>[
              // Text(controller.isLocalAuth.toString()),
              // Text(controller.authorized ?? ""),
              OutlineButton(
                  child: Text('Authenticate'),
                  onPressed: () async {

                    // bool authenticated = false;
                    // authenticated = await LocalAuthentication()
                    //     .authenticateWithBiometrics(
                    //     localizedReason: '지문 인식을 진행해주십시오.');
                    // setState(() {
                    //   _authorized = authenticated ? 'Authorized' : 'Not Authorized';
                    // });

                  })
            ],
        ),
    );

  }// Widget build 끝

}
