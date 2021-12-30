
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';


class BioAuth extends StatefulWidget {
  const BioAuth({Key? key}) : super(key: key);

  @override
  _BioAuthState createState() => _BioAuthState();
}

class _BioAuthState extends State<BioAuth> {

  bool isLocalAuthText = false;
  String authorized = "";


  @override
  initState() {
    super.initState();
    checkBio();
  }

  checkBio() async {
    var isLocalAuth;
    isLocalAuth = await LocalAuthentication().canCheckBiometrics;
    setState(() {
      isLocalAuthText = isLocalAuth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(isLocalAuthText ? "생체인식 장치 존재 여부 : Yes" : "생체인식 장치 존재 여부 : No"),
              Text(authorized),
              OutlineButton(
                  child: Text('Authenticate'),
                  onPressed: () async {
                    bool authenticated = false;
                    authenticated = await LocalAuthentication()
                        .authenticateWithBiometrics(
                        localizedReason: '지문 인식을 진행해주십시오.');
                    setState(() {
                      authorized = authenticated ? '생체 인식 : 통과' : '생체 인식 : 안됨';
                    });
                  })
            ],
          ),
        )
      ),



    );
  }

}
