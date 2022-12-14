import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/mainfarm.dart';
import 'package:cow_mange/validators.dart';
import 'package:flutter/material.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddEmployee extends StatefulWidget {
  final Farm fm;
  const AddEmployee({
    Key? key,
    required this.fm,
  }) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  Employee emp = Employee();
  String? name_title = "";
  String? position = "";

  //error_text
  String error_text = "";

  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  final tel = TextEditingController();

  @override
  void initState() {
    super.initState();
    clean_number();
  }

  Future clean_number() async {
    firstname.addListener(() {
      setState(() {
        _showClearButton_firstname = firstname.text.isNotEmpty;
      });
    });
    lastname.addListener(() {
      setState(() {
        _showClearButton_lastname = lastname.text.isNotEmpty;
      });
    });
    username.addListener(() {
      setState(() {
        _showClearButton_username = username.text.isNotEmpty;
      });
    });
    password.addListener(() {
      setState(() {
        _showClearButton_password = password.text.isNotEmpty;
      });
    });
    email.addListener(() {
      setState(() {
        _showClearButton_email = email.text.isNotEmpty;
      });
    });
    tel.addListener(() {
      setState(() {
        _showClearButton_tel = tel.text.isNotEmpty;
      });
    });
  }

  //  button clear
  bool _showClearButton_firstname = false;
  bool _showClearButton_lastname = false;
  bool _showClearButton_username = false;
  bool _showClearButton_password = false;
  bool _showClearButton_email = false;
  bool _showClearButton_tel = false;

  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Container(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 224, 242, 228),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 30,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text("??????????????????????????????????????????????????????",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1.5)),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              "??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  height: 1.5)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.93,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.lightGreen.withAlpha(50)),
                child: Column(children: [
                  DropdownButtonFormField(
                    items: ['?????????', '?????????', '??????????????????'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        name_title = newValue;
                      });
                    },
                    validator: Validators.required_isnull("??????????????????????????????????????????????????????"),
                    decoration: const InputDecoration(
                      hintText: '????????????????????????',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ]),
              ),
              Row(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: firstname,
                        validator: Validators.compose([
                          Validators.required_isempty(
                            "??????????????????????????? ????????????",
                          ),
                          Validators.text_eng_thai(
                              "?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????"),
                          Validators.minLength(
                              2, "?????????????????????????????????????????????????????? 2 ????????????????????????"),
                          Validators.maxLength(
                              30, "???????????????????????????????????????????????? 30 ????????????????????????")
                        ]),
                        decoration: InputDecoration(
                          label: Text("????????????"),
                          suffixIcon: _getClearButton_firstname(),
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: lastname,
                        validator: Validators.compose([
                          Validators.required_isempty(
                            "??????????????????????????? ?????????????????????",
                          ),
                          Validators.text_eng_thai(
                              "?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????"),
                          Validators.minLength(
                              3, "?????????????????????????????????????????????????????? 3 ????????????????????????"),
                          Validators.maxLength(
                              30, "???????????????????????????????????????????????? 30 ????????????????????????")
                        ]),
                        decoration: InputDecoration(
                          label: Text("?????????????????????"),
                          suffixIcon: _getClearButton_lastname(),
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      )),
                ],
              ),
              Row(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: username,
                        validator: Validators.compose([
                          Validators.required_isempty(
                            "??????????????????????????? ??????????????????????????????",
                          ),
                          Validators.text_eng_only(
                              "??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????"),
                        ]),
                        decoration: InputDecoration(
                          label: Text("??????????????????????????????"),
                          suffixIcon: _getClearButton_username(),
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: password,
                        obscureText: _isObscure,
                        validator: Validators.compose([
                          Validators.required_isempty("??????????????????????????? ????????????????????????"),
                          Validators.text_eng_only(
                              "?????????????????????????????????????????????????????????????????????????????????"),
                        ]),
                        decoration: InputDecoration(
                          label: Text("??????????????????????????????"),
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
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      )),
                ],
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.93,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.lightGreen.withAlpha(50)),
                  child: TextFormField(
                    controller: email,
                    validator: Validators.compose([
                      Validators.required_isempty(
                        "??????????????????????????? ??????????????????",
                      ),
                      Validators.email("???????????????????????????????????????????????????????????????????????????"),
                      Validators.minLength(6, "?????????????????????????????????????????????????????? 6 ????????????????????????"),
                      Validators.maxLength(30, "???????????????????????????????????????????????? 30 ????????????????????????")
                    ]),
                    decoration: InputDecoration(
                        label: Text("??????????????????"),
                        suffixIcon: _getClearButton_email(),
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.squareEnvelope,
                          color: Color(0XFF397D54),
                          size: 20,
                        )),
                  )),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.93,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.lightGreen.withAlpha(50)),
                  child: TextFormField(
                    controller: tel,
                    validator: Validators.compose([
                      Validators.required_isempty(
                        "??????????????????????????? ????????????????????????",
                      ),
                      Validators.number("?????????????????????????????????????????????????????????????????????????????????"),
                      Validators.minLength(12, "?????????????????????????????????????????????????????? 10 ?????????"),
                      Validators.maxLength(12, "?????????????????????????????????????????????????????? 10 ?????????")
                    ]),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                      MaskedInputFormatter('###-###-####')
                    ],
                    decoration: InputDecoration(
                        label: Text("????????????????????????"),
                        suffixIcon: _getClearButton_tel(),
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.phone,
                          color: Color(0XFF397D54),
                          size: 20,
                        )),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.93,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.lightGreen.withAlpha(50)),
                child: Column(children: [
                  DropdownButtonFormField(
                    items: ['??????????????????????????????????????????', '?????????????????????'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        position = newValue;
                      });
                    },
                    validator: Validators.required_isnull("???????????????????????????????????????????????????"),
                    decoration: const InputDecoration(
                      hintText: '?????????????????????',
                      hintStyle: TextStyle(color: Colors.black),
                      icon: Icon(
                        FontAwesomeIcons.userTie,
                        color: Color(0XFF397D54),
                        size: 20,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              Text(
                error_text,
                style: TextStyle(color: Colors.red),
              ),
              InkWell(
                onTap: () async {
                  bool validate = _formKey.currentState!.validate();
                  if (validate == false) {
                    setState(() {
                      error_text = "???????????????????????????????????????????????????????????????????????????";
                    });
                  } else {
                    setState(() {
                      error_text = "";
                    });
                    emp.username = username.text;
                    emp.password = password.text;
                    String firstnameTitle = name_title! + firstname.text;
                    emp.firstname = firstnameTitle;
                    emp.lastname = lastname.text;
                    emp.email = email.text;
                    emp.tel = tel.text;
                    emp.position = position;
                    Farm idFarm = Farm(id_Farm: widget.fm.id_Farm);
                    emp.farm = idFarm;

                    final employee = Employee_data().RegisterEmployee(emp);

                    if (employee != null) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: ((context) {
                        return Mainfarm(
                          fm: widget.fm,
                        );
                      })));
                    } else {
                      setState(() {
                        error_text = "fail to upload";
                      });
                    }
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  width: size.width * 0.97,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color:
                          const Color.fromARGB(255, 34, 120, 37).withAlpha(50)),
                  alignment: Alignment.center,
                  child: const Text('??????????????????????????????????????????????????????',
                      style: TextStyle(color: Color(0xff235d3a), fontSize: 18)),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  Widget? _getClearButton_firstname() {
    if (!_showClearButton_firstname) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          firstname.clear();
        });
  }

  Widget? _getClearButton_lastname() {
    if (!_showClearButton_lastname) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          lastname.clear();
        });
  }

  Widget? _getClearButton_username() {
    if (!_showClearButton_username) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          username.clear();
        });
  }

  Widget? _getClearButton_password() {
    if (!_showClearButton_password) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          password.clear();
        });
  }

  Widget? _getClearButton_email() {
    if (!_showClearButton_email) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          email.clear();
        });
  }

  Widget? _getClearButton_tel() {
    if (!_showClearButton_tel) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          tel.clear();
        });
  }
}
