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
import 'package:google_fonts/google_fonts.dart';

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

  bool _isObscure = true;

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
  String? texterror_img = "????????????????????????";
  String? error_img = "";
  String? img = "?????????????????????????????????";

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
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
                        child: Text("?????????????????????????????????????????????????????????????????????",
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
                        child: Text("?????????????????????????????????????????????????????????????????????????????????????????????????????????",
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
                    "???????????????????????????????????????",
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
                          "??????????????????????????? ????????????",
                        ),
                        Validators.text_eng_thai(
                            "?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????"),
                        Validators.minLength(
                            2, "?????????????????????????????????????????????????????? 2 ????????????????????????"),
                        Validators.maxLength(30, "???????????????????????????????????????????????? 30 ????????????????????????")
                      ]),
                      decoration: InputDecoration(
                        suffixIcon: _getClearButton_firstname(),
                        label: Text("????????????"),
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
                          "??????????????????????????? ?????????????????????",
                        ),
                        Validators.text_eng_thai(
                            "?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????"),
                        Validators.minLength(
                            3, "?????????????????????????????????????????????????????? 3 ????????????????????????"),
                        Validators.maxLength(30, "???????????????????????????????????????????????? 30 ????????????????????????")
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
                          "??????????????????????????? Username",
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextFormField(
                      controller: password,
                      obscureText: _isObscure,
                      validator: Validators.compose([
                        Validators.required_isempty("??????????????????????????? Password"),
                        Validators.text_eng_only("?????????????????????????????????????????????????????????????????????????????????"),
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
                  Row(
                    children: <Widget>[
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: '?????????????????????',
                          style: GoogleFonts.mitr(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        )
                      ])),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: '* ?????????????????????????????????????????? -',
                            style: GoogleFonts.mitr(
                              textStyle:
                                  TextStyle(color: Colors.red, fontSize: 16),
                            ))
                      ])),
                    ],
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
                          "??????????????????????????? ?????????????????????",
                        ),
                      ]),
                      decoration: InputDecoration(
                        label: Text("?????????????????????"),
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
                          "??????????????????????????? ?????????????????????",
                        ),
                      ]),
                      decoration: InputDecoration(
                        suffixIcon: _getClearButton_village(),
                        label: Text("????????????????????????/???????????????"),
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
                          "??????????????????????????? ?????????",
                        ),
                      ]),
                      decoration: InputDecoration(
                        suffixIcon: _getClearButton_alley(),
                        label: Text("?????????"),
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
                          "??????????????????????????? ?????????",
                        ),
                      ]),
                      decoration: InputDecoration(
                        suffixIcon: _getClearButton_road(),
                        label: Text("?????????"),
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
                      "??????????????????????????? ????????????",
                    ),
                  ]),
                  decoration: InputDecoration(
                    label: Text("????????????"),
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
                      "??????????????????????????? ???????????????",
                    ),
                  ]),
                  decoration: InputDecoration(
                    label: Text("???????????????"),
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
                      "??????????????????????????? ?????????????????????",
                    ),
                  ]),
                  decoration: InputDecoration(
                    label: Text("?????????????????????"),
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
                  keyboardType: TextInputType.number,
                  validator: Validators.compose([
                    Validators.required_isempty(
                      "??????????????????????????? ????????????????????????????????????",
                    ),
                  ]),
                  decoration: InputDecoration(
                    label: Text("????????????????????????????????????"),
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
                    "?????????????????????????????????",
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
                      "??????????????????????????? ???????????????????????????",
                    ),
                  ]),
                  decoration: InputDecoration(
                    label: Text("???????????????????????????"),
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
                    '??????????????????',
                    '??????????????????',
                    '??????????????????',
                    '???????????????',
                    '?????????????????????',
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
                      Validators.required_isnull("???????????????????????????????????????????????????????????????"),
                  decoration: const InputDecoration(
                    hintText: '?????????????????????????????????',
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
                          "????????????????????????????????????????????????",
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
                      error_img = "???????????????????????????????????????????????????";
                    });
                  } else {
                    setState(() {
                      texterror_img = "????????????????????????";
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
                        "${address.text}/${village.text} ???.${district.text} ???.${canton.text} ???.${province.text} ${zip_code.text}";
                  } else if ("${alley.text}" == "-") {
                    testAddress =
                        "${address.text}/${village.text} ${road.text} ???.${district.text} ???.${canton.text} ???.${province.text} ${zip_code.text}";
                  } else {
                    testAddress =
                        "${address.text}/${village.text} ${alley.text}  ???.${district.text} ???.${canton.text} ???.${province.text} ${zip_code.text}";
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

                  if (farm2 != null) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return const LoginScreen();
                    })));
                  }
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
                child: Text('??????????????????????????????????????????',
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
