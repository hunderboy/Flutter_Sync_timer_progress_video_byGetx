

import 'package:local_auth/local_auth.dart';
import 'package:get/get.dart';

class ControllerBioAuth extends GetxController {

  bool _isLocalAuth = false;
  String _authorized = "";

  bool get isLocalAuth => _isLocalAuth;
  String get authorized => _authorized;

  @override
  void onInit() {
    /// initState를 오버라이딩하여 앱이 구동했을 때에 checkBio라는 함수를 수행하게 합니다.
    /// 이로 인하여 해당 앱이 켜지면서 생체 인증을 할 수 있는 수단이 기기에 존재하는 지 확인할 수 있습니다.
    checkBio();
  }

  checkBio() async {
    var isLocalAuth;
    isLocalAuth = await LocalAuthentication().canCheckBiometrics;
    _isLocalAuth = isLocalAuth;
  }


}