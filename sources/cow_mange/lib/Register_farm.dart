import 'dart:io';

import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Farmtype.dart';
import 'package:cow_mange/login.dart';
import 'package:cow_mange/validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cow_mange/url/URL.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:cow_mange/class/Cow.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as Img;

class Register_farm extends StatefulWidget {
  const Register_farm({Key? key}) : super(key: key);

  @override
  State<Register_farm> createState() => _Register_farmState();
}

class _Register_farmState extends State<Register_farm> {
  File? file;
  //file
  String fileName = "";
  String filePath = "";
  UploadTask? task;

  List<PlatformFile>? _files;
  Future uploadfile() async {
    var url_ = (Uri.parse(url.URL + url.URL_uploadimage));
    var request = http.MultipartRequest('Post', url_);

    final fileName = File(pickedFile!.path!);
    final fileExtension = fileName.path.split(".").last;
    final filename_Farm = farm.name_Farm;

    int sizeInBytes = fileName.lengthSync();
    Img.Image? image_temp = Img.decodeImage(fileName.readAsBytesSync());
    Img.Image? resized_img =
        Img.copyResize(image_temp!, width: 300, height: 300);

    request.files.add(http.MultipartFile.fromBytes(
        'file', Img.encodeJpg(resized_img),
        filename: pickedFile!.path.toString(),
        contentType: MediaType.parse('image/jpeg')));

    request.files.add(http.MultipartFile.fromString('farm', filename_Farm!));
    var response = await request.send();

    final res = await http.Response.fromStream(response);
    print(res);
    if (response.statusCode == 200) {
      print('Uploaded ...');
      return filename_Farm + "." + fileExtension;
    } else {
      print('Something went wrong');
    }
  }

  PlatformFile? pickedFile;
  Future chooseImage() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  void initState() {
    super.initState();
    clean_number();
  }

  //class
  Farm farm = Farm();

  //Controller

  //personal information
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  final tel = TextEditingController();
  //  button clear
  bool _showClearButton_firstname = false;
  bool _showClearButton_lastname = false;
  bool _showClearButton_username = false;
  bool _showClearButton_password = false;
  bool _showClearButton_email = false;
  bool _showClearButton_tel = false;
//////////////////////////////////////

  //address
  final address = TextEditingController();
  final village = TextEditingController();
  final alley = TextEditingController();
  final road = TextEditingController();
  final district = TextEditingController();
  final canton = TextEditingController();
  final province = TextEditingController();
  final zip_code = TextEditingController();
  //  button clear
  bool _showClearButton_address = false;
  bool _showClearButton_village = false;
  bool _showClearButton_alley = false;
  bool _showClearButton_road = false;
  bool _showClearButton_district = false;
  bool _showClearButton_canton = false;
  bool _showClearButton_province = false;
  bool _showClearButton_zip_code = false;
  bool _showClearButton_farmname = false;

//////////////////////////////////////

  //farm infomation
  final farmname = TextEditingController();
  String? farmcategory = "";

  //
  String? name_title = "";

  //clean_number
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

    address.addListener(() {
      setState(() {
        _showClearButton_address = address.text.isNotEmpty;
      });
    });
    village.addListener(() {
      setState(() {
        _showClearButton_village = village.text.isNotEmpty;
      });
    });
    alley.addListener(() {
      setState(() {
        _showClearButton_alley = alley.text.isNotEmpty;
      });
    });
    road.addListener(() {
      setState(() {
        _showClearButton_road = road.text.isNotEmpty;
      });
    });
    district.addListener(() {
      setState(() {
        _showClearButton_district = district.text.isNotEmpty;
      });
    });
    canton.addListener(() {
      setState(() {
        _showClearButton_canton = canton.text.isNotEmpty;
      });
    });
    province.addListener(() {
      setState(() {
        _showClearButton_province = province.text.isNotEmpty;
      });
    });
    zip_code.addListener(() {
      setState(() {
        _showClearButton_zip_code = zip_code.text.isNotEmpty;
      });
    });
    farmname.addListener(() {
      setState(() {
        _showClearButton_farmname = farmname.text.isNotEmpty;
      });
    });
  }

  //error_img
  String? texterror_img = "ไม่มีรูป";
  String? error_img = "";
  String? img = "ไม่มีรูปภาพ";

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
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
                                  color:
                                      const Color.fromARGB(255, 224, 242, 228),
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
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("สมัครสมาชิกเจ้าของฟาร์ม",
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.5)),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text("กรอกข้อมูลให้ถูกต้องก่อนสมัครสมาชิก",
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
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      FontAwesomeIcons.addressCard,
                      color: Color(0XFF397D54),
                      size: 20,
                    ),
                  ),
                  Text(
                    "ข้อมูลส่วนตัว",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.45,
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
                        Validators.maxLength(30, "กรุณากรอกไม่เกิน 30 ตัวอักษร")
                      ]),
                      decoration: InputDecoration(
                        suffixIcon: _getClearButton_firstname(),
                        label: Text("ชื่อ"),
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.45,
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
                        Validators.maxLength(30, "กรุณากรอกไม่เกิน 30 ตัวอักษร")
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextFormField(
                      controller: username,
                      validator: Validators.compose([
                        Validators.required_isempty(
                          "กรุณากรอก Username",
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextFormField(
                      controller: password,
                      validator: Validators.compose([
                        Validators.required_isempty("กรุณากรอก Password"),
                        Validators.text_eng_only("กรุณาชื่อรหัสผ่านให้ถูกต้อง"),
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
                      hintStyle: TextStyle(color: Colors.black),
                      suffixIcon: _getClearButton_tel(),
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.mobileScreen,
                        color: Color(0XFF397D54),
                        size: 20,
                      )),
                )),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      FontAwesomeIcons.addressBook,
                      color: Color(0XFF397D54),
                      size: 20,
                    ),
                  ),
                  Text(
                    "ที่อยู่ * ถ้าไม่มีให้ใส่ -",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextFormField(
                      controller: address,
                      validator: Validators.compose([
                        Validators.required_isempty(
                          "กรุณากรอก ที่อยู่",
                        ),
                      ]),
                      decoration: InputDecoration(
                        label: Text("ที่อยู่"),
                        suffixIcon: _getClearButton_address(),
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextFormField(
                      controller: village,
                      validator: Validators.compose([
                        Validators.required_isempty(
                          "กรุณากรอก ที่อยู่",
                        ),
                      ]),
                      decoration: InputDecoration(
                        suffixIcon: _getClearButton_village(),
                        label: Text("หมู่บ้าน/อาคาร"),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextFormField(
                      controller: alley,
                      validator: Validators.compose([
                        Validators.required_isempty(
                          "กรุณากรอก ซอย",
                        ),
                      ]),
                      decoration: InputDecoration(
                        suffixIcon: _getClearButton_alley(),
                        label: Text("ซอย"),
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                    )),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextFormField(
                      controller: road,
                      validator: Validators.compose([
                        Validators.required_isempty(
                          "กรุณากรอก ถนน",
                        ),
                      ]),
                      decoration: InputDecoration(
                        suffixIcon: _getClearButton_road(),
                        label: Text("ถนน"),
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
                  controller: district,
                  validator: Validators.compose([
                    Validators.required_isempty(
                      "กรุณากรอก ตำบล",
                    ),
                  ]),
                  decoration: InputDecoration(
                    label: Text("ตำบล"),
                    suffixIcon: _getClearButton_district(),
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
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
                  controller: canton,
                  validator: Validators.compose([
                    Validators.required_isempty(
                      "กรุณากรอก อำเภอ",
                    ),
                  ]),
                  decoration: InputDecoration(
                    label: Text("อำเภอ"),
                    suffixIcon: _getClearButton_canton(),
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
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
                  controller: province,
                  validator: Validators.compose([
                    Validators.required_isempty(
                      "กรุณากรอก จังหวัด",
                    ),
                  ]),
                  decoration: InputDecoration(
                    label: Text("จังหวัด"),
                    suffixIcon: _getClearButton_province(),
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
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
                  controller: zip_code,
                  validator: Validators.compose([
                    Validators.required_isempty(
                      "กรุณากรอก รหัสไปรษณีย์",
                    ),
                  ]),
                  decoration: InputDecoration(
                    label: Text("รหัสไปรษณีย์"),
                    suffixIcon: _getClearButton_zip_code(),
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
                )),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      FontAwesomeIcons.wheatAwn,
                      color: Color(0XFF397D54),
                      size: 20,
                    ),
                  ),
                  Text(
                    "ข้อมูลฟาร์ม",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.93,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.lightGreen.withAlpha(50)),
                child: TextFormField(
                  controller: farmname,
                  validator: Validators.compose([
                    Validators.required_isempty(
                      "กรุณากรอก ชื่อฟาร์ม",
                    ),
                  ]),
                  decoration: InputDecoration(
                    label: Text("ชื่อฟาร์ม"),
                    suffixIcon: _getClearButton_farmname(),
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.93,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: Column(children: [
                DropdownButtonFormField(
                  items: [
                    'บริษัท',
                    'ประกัน',
                    'ราชการ',
                    'อิสระ',
                    'ไม่ระบุ',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      farmcategory = newValue;
                    });
                  },
                  validator:
                      Validators.required_isnull("กรุณาเลือกประเภทฟาร์ม"),
                  decoration: const InputDecoration(
                    hintText: 'ประเภทฟาร์ม',
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
                ),
              ]),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.93,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: pickedFile == null
                          ? Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Text(img == texterror_img
                                      ? ""
                                      : texterror_img!),
                                  Text(
                                    error_img!,
                                    style: const TextStyle(color: Colors.red),
                                  )
                                ],
                              ))
                          : Image.file(File(pickedFile!.path!)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                        onPressed: chooseImage,
                        child: const Text(
                          "เลือกรูปภาพฟาร์ม",
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                bool validate = _formKey.currentState!.validate();
                if (validate == false) {
                  if (file == null) {
                    setState(() {
                      texterror_img = "";
                      error_img = "กรุณากรอกรูปฟาร์ม";
                    });
                  } else {
                    setState(() {
                      texterror_img = "ไม่มีรูป";
                      error_img = "";
                    });
                  }
                } else {
                  String owername =
                      "$name_title${firstname.text} ${lastname.text}";
                  farm.owner_name = owername;
                  farm.username = username.text;
                  farm.password = password.text;
                  farm.email = email.text;
                  farm.tel = tel.text;

                  String testAddress = "";
                  if ("${alley.text}" == "-" && "${road.text}" == "-") {
                    testAddress =
                        "${address.text}/${village.text} ต.${district.text} อ.${canton.text} จ.${province.text} ${zip_code.text}";
                  } else if ("${alley.text}" == "-") {
                    testAddress =
                        "${address.text}/${village.text} ${road.text} ต.${district.text} อ.${canton.text} จ.${province.text} ${zip_code.text}";
                  } else {
                    testAddress =
                        "${address.text}/${village.text} ${alley.text}  ต.${district.text} อ.${canton.text} จ.${province.text} ${zip_code.text}";
                  }

                  farm.addressFarm = testAddress;
                  setState(() {
                    farm.name_Farm = farmname.text;
                  });

                  Farmtype newFarmtype = Farmtype(name_FarmType: farmcategory);
                  farm.farmtype = newFarmtype;

                  if (pickedFile != null) {
                    farm.photo = await uploadfile();
                  }

                  final farm2 = await Farm_data().registerfarm(farm);
/*
                  if (farm2 != null) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return const LoginScreen();
                    })));
                  }*/
                }
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color:
                        const Color.fromARGB(255, 34, 120, 37).withAlpha(50)),
                alignment: Alignment.center,
                child: Text('ลงทะเบียนฟาร์ม',
                    style: TextStyle(color: Color(0xff235d3a), fontSize: 18)),
              ),
            ),
          ],
        ),
      )),
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

  Widget? _getClearButton_address() {
    if (!_showClearButton_address) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          address.clear();
        });
  }

  Widget? _getClearButton_village() {
    if (!_showClearButton_village) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          village.clear();
        });
  }

  Widget? _getClearButton_alley() {
    if (!_showClearButton_alley) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          alley.clear();
        });
  }

  Widget? _getClearButton_road() {
    if (!_showClearButton_road) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          road.clear();
        });
  }

  Widget? _getClearButton_district() {
    if (!_showClearButton_district) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          district.clear();
        });
  }

  Widget? _getClearButton_canton() {
    if (!_showClearButton_canton) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          canton.clear();
        });
  }

  Widget? _getClearButton_province() {
    if (!_showClearButton_province) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          province.clear();
        });
  }

  Widget? _getClearButton_zip_code() {
    if (!_showClearButton_zip_code) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          zip_code.clear();
        });
  }

  Widget? _getClearButton_farmname() {
    if (!_showClearButton_farmname) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          farmname.clear();
        });
  }
}
