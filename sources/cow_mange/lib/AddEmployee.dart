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

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
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
                          child: Text("เพิ่มข้อมูลพนักงาน",
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
                              "กรอกข้อมูลให้ถูกต้องก่อนเพิ่มข้อมูลพนักงาน",
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
                    items: ['นาง', 'นาย', 'นางสาว'].map((String value) {
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
                    validator: Validators.required_isnull("กรุณาเลือกคำนำหน้า"),
                    decoration: const InputDecoration(
                      hintText: 'คำนำหน้า',
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
                            "กรุณากรอก ชื่อ",
                          ),
                          Validators.text_eng_thai(
                              "กรุณาชื่อผู้ใช้เป็นภาษาไทยและภาษาอังกฤษเท่านั้น"),
                          Validators.minLength(
                              2, "กรุณากรอกอย่างน้อย 2 ตัวอักษร"),
                          Validators.maxLength(
                              30, "กรุณากรอกไม่เกิน 30 ตัวอักษร")
                        ]),
                        decoration: InputDecoration(
                          label: Text("ชื่อ"),
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
                            "กรุณากรอก นามสกุล",
                          ),
                          Validators.text_eng_thai(
                              "กรุณาชื่อผู้ใช้เป็นภาษาไทยและภาษาอังกฤษเท่านั้น"),
                          Validators.minLength(
                              3, "กรุณากรอกอย่างน้อย 3 ตัวอักษร"),
                          Validators.maxLength(
                              30, "กรุณากรอกไม่เกิน 30 ตัวอักษร")
                        ]),
                        decoration: InputDecoration(
                          label: Text("นามสกุล"),
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
                            "กรุณากรอก ชื่อผู้ใช้",
                          ),
                          Validators.text_eng_only(
                              "กรุณาชื่อผู้ใช้เป็นภาษาอังกฤษและตัวเลขเท่านั้น"),
                        ]),
                        decoration: InputDecoration(
                          label: Text("ชื่อผู้ใช้"),
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
                        validator: Validators.compose([
                          Validators.required_isempty("กรุณากรอก รหัสผ่าน"),
                          Validators.text_eng_only(
                              "กรุณาชื่อรหัสผ่านให้ถูกต้อง"),
                        ]),
                        decoration: InputDecoration(
                          label: Text("รหัสผู้ใช้"),
                          suffixIcon: _getClearButton_password(),
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
                        "กรุณากรอก อีเมล์",
                      ),
                      Validators.email("กรุณาชื่ออีเมล์ให้ถูกต้อง"),
                      Validators.minLength(6, "กรุณากรอกอย่างน้อย 6 ตัวอักษร"),
                      Validators.maxLength(30, "กรุณากรอกไม่เกิน 30 ตัวอักษร")
                    ]),
                    decoration: InputDecoration(
                        label: Text("อีเมล์"),
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
                        "กรุณากรอก เบอร์โทร",
                      ),
                      Validators.number("กรุณาชื่อเบอร์โทรให้ถูกต้อง"),
                      Validators.minLength(12, "กรุณากรอกอย่างน้อย 10 ตัว"),
                      Validators.maxLength(12, "กรุณากรอกอย่างน้อย 10 ตัว")
                    ]),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                      MaskedInputFormatter('###-###-####')
                    ],
                    decoration: InputDecoration(
                        label: Text("เบอร์โทร"),
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
                    items: ['หัวหน้าพนักงาน', 'พนักงาน'].map((String value) {
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
                    validator: Validators.required_isnull("กรุณาเลือกตำแหน่ง"),
                    decoration: const InputDecoration(
                      hintText: 'ตำแหน่ง',
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
                      error_text = "กรุณากรอกข้อมูลให้ครบถ้วน";
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
                  child: const Text('เพิ่มข้อมูลพนักงาน',
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
