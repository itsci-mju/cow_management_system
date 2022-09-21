import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;

  @override
  Widget build(BuildContext context) {

    var inputusernameEmployee = TextEditingController();
    return AnimatedOpacity(
      opacity: isLogin ? 0.0 : 1.0,
      duration: animationDuration * 5,
      child: Visibility(
        visible: !isLogin,
        child: Align(
          alignment: Alignment.center,
          child: Container(
              child: SingleChildScrollView(
            child: Column(
              //crossAxisAlignment ซ้าย-กลาง-ขวา
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment กำหนดบน-กลาง-ล่าง
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  "images/cow-01.png",
                  height: 150,
                  width: size.width * 0.6,
                ),
                const SizedBox(
                  height: 15,
                ),

              ],
            ),
          )),
        ),
      ),
    );
  }
}