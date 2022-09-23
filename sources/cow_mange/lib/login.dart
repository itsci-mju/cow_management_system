import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/Mainpage.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/mainfarm.dart';
import 'package:cow_mange/Register_farm.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:cow_mange/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late Animation<double> containerSize;
  Duration animationDuration = const Duration(milliseconds: 270);

  final username = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Employee employee = Employee();
  Farm farm = Farm();
  String? name;

  late int selectedRadio;

  @override
  void initState() {
    super.initState();

    setState(() {
      selectedRadio = 1;
    });
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  String status = "1";
  String texterror = "";

  @override
  void dispose() {
    super.dispose();
  }

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context).size;  คือ ฟังชัน  MediaQuery จะใช้ในการดึงขนาดหน้าจอ
    Size size = MediaQuery.of(context).size;
    //MediaQuery.of(context).viewInsets.bottom; คือฟังชัน viewInsets จะใช้เกี่ยวกับแป้นพิม

    return Scaffold(
      body: SingleChildScrollView(
        //  NeverScrollableScrollPhysics(), ทำให้หน้าจอเลื่อนไมไ่ด้
        //physics: NeverScrollableScrollPhysics(),
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8.0)),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 20,
                            )),
                      )
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: isLogin ? 1.0 : 0.0,
                  duration: animationDuration * 4,
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Container(
                          child: Column(
                            //crossAxisAlignment ซ้าย-กลาง-ขวา
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment กำหนดบน-กลาง-ล่าง
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "ยินดีตอนรับ ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Image.asset(
                                "images/cow-01.png",
                                height: 170,
                                width: size.width * 0.9,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Radio(
                                        value: 1,
                                        groupValue: selectedRadio,
                                        activeColor: Colors.green,
                                        onChanged: (val) {
                                          setSelectedRadio(
                                              val = int.parse(val.toString()));
                                          status = val.toString();
                                        },
                                      ),
                                      const Text(
                                        'พนักงาน',
                                        style: TextStyle(fontSize: 17.0),
                                      ),
                                      Radio(
                                        value: 2,
                                        groupValue: selectedRadio,
                                        activeColor: Colors.green,
                                        onChanged: (val) {
                                          setSelectedRadio(
                                              val = int.parse(val.toString()));

                                          status = val.toString();
                                        },
                                      ),
                                      const Text(
                                        'เจ้าของฟาร์ม',
                                        style: TextStyle(fontSize: 17.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  width: size.width * 0.8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.lightGreen.withAlpha(50)),
                                  child: TextFormField(
                                    controller: username,
                                    decoration: const InputDecoration(
                                      hintText: "ชื่อผู้ใช้",
                                      hintStyle: TextStyle(color: Colors.black),
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.userLarge,
                                        color: Color(0XFF397D54),
                                        size: 20,
                                      ),
                                    ),
                                    validator: Validators.compose([
                                      Validators.required_isempty(
                                        "**กรุณากรอก Username",
                                      ),
                                      Validators.text_eng_only(
                                          "**กรุณาชื่อผู้ใช้เป็นภาษาอังกฤษและตัวเลขเท่านั้น"),
                                    ]),
                                  )),
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  width: size.width * 0.8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.lightGreen.withAlpha(50)),
                                  child: TextFormField(
                                    obscureText: _isObscure,
                                    controller: password,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            color: Colors.green,
                                            icon: Icon(_isObscure
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            }),
                                        hintText: "รหัสผ่าน",
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        border: InputBorder.none,
                                        icon: const Icon(
                                          FontAwesomeIcons.unlock,
                                          color: Color(0XFF397D54),
                                          size: 20,
                                        )),
                                    validator: Validators.compose([
                                      Validators.required_isempty(
                                          "กรุณากรอก Password"),
                                      Validators.text_eng_only(
                                          "กรุณาชื่อรหัสผ่านให้ถูกต้อง"),
                                    ]),
                                  )),
                              Text(
                                texterror,
                                style: const TextStyle(color: Colors.red),
                              ),
                              InkWell(
                                onTap: () async {
                                  String position = "";
                                  setState(() {
                                    if (status == "1") {
                                      position = "พนักงาน";
                                      employee.username = username.text;
                                      employee.password = password.text;
                                    } else {
                                      position = "เจ้าของฟาร์ม";
                                      farm.username = username.text;
                                      farm.password = password.text;
                                    }
                                  });
                                  if (position == "พนักงาน") {
                                    final employee2 = await Employee_data()
                                        .LoginEmployee(employee);
                                    String e;
                                    if (employee2 != 0) {
                                      final co = await Cow_data()
                                          .listMaincow(employee2);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainpageEmployee(
                                                  emp: employee2,
                                                  cow: co,
                                                )),
                                      );
                                    } else {
                                      bool validate =
                                          _formKey.currentState!.validate();
                                      if (validate == false) {
                                        setState(() {
                                          texterror =
                                              "กรุณากรอกข้อมูลให้ครบถ้วน";
                                        });
                                      } else {
                                        setState(() {
                                          texterror = "";
                                        });
                                        e = "เกิดข้อผิดพลาด";
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                content: Stack(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      height: 90,
                                                      decoration: const BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                              width: 48),
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                e,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              const Text(
                                                                "กรุณาตรวจสอบ username และ password ให้ถูกต้องก่อนเข้าสู่ระบบ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )));
                                      }
                                    }
                                  } else {
                                    final farm2 =
                                        await Farm_data().LoginFarm(farm);
                                    String e;
                                    if (farm2 != 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Mainfarm(fm: farm2)),
                                      );
                                    } else {
                                      bool validate =
                                          _formKey.currentState!.validate();
                                      if (validate == false) {
                                        setState(() {
                                          texterror =
                                              "**กรุณากรอกข้อมูลให้ครบถ้วน";
                                        });
                                      } else {
                                        setState(() {
                                          texterror = "";
                                        });
                                        e = "เกิดข้อผิดพลาด";
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                content: Stack(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      height: 90,
                                                      decoration: const BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                              width: 48),
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                e,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              const Text(
                                                                "กรุณาตรวจสอบ username และ password ให้ถูกต้องก่อนเข้าสู่ระบบ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )));
                                      }
                                    }
                                  }
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  width: size.width * 0.8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color:
                                          const Color.fromARGB(255, 34, 120, 37)
                                              .withAlpha(50)),
                                  alignment: Alignment.center,
                                  child: const Text('เข้าสู่ระบบ',
                                      style: TextStyle(
                                          color: Color(0xff235d3a),
                                          fontSize: 18)),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                buildRegisterContainer(status)
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildRegisterContainer(status) {
    Size size = MediaQuery.of(context).size;
    if (status == "2") {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Register_farm()),
          );
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: size.height * 0.10,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
                color: Color(0XFF397D54)),
            alignment: Alignment.center,
            child: GestureDetector(
              child: isLogin
                  ? const Text(
                      "ยังไม่ได้สมัครสมาชิก? สมัครคลิกตรงนี้",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18),
                    )
                  : null,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
