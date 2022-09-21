import 'dart:io';

import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Farmtype.dart';
import 'package:cow_mange/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cow_mange/firebase/storage.dart';

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
  Future chooseImage() async {
    final image =
        await ImagePicker.pickImage(source: ImageSource.gallery) as File?;
    setState(() {
      file = image;
    });
    filePath = file!.path;

    fileName = file!.path.split('/').last;
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

  //address
  final address = TextEditingController();
  final village = TextEditingController();
  final alley = TextEditingController();
  final road = TextEditingController();
  final district = TextEditingController();
  final canton = TextEditingController();
  final province = TextEditingController();
  final zip_code = TextEditingController();

  //farm infomation
  final farmname = TextEditingController();
  String? farmcategory = "";

  //
  String? name_title = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Storage storage = Storage();
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 60, 0, 0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      )),
                ),
                SizedBox(
                  child: Column(
                    children: const [
                      Text(
                        "สมัครสมาชิกเจ้าของฟาร์ม",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.5),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text("กรอกข้อมูลให้ถูกต้องก่อนสมัครสมาชิก")
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Text("ข้อูลส่วนตัว"),
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
                decoration: const InputDecoration(
                  hintText: 'คำนำหน้า',
                  hintStyle: TextStyle(color: Colors.black),
                  icon: Icon(
                    FontAwesomeIcons.venusMars,
                    color: Color(0XFF397D54),
                    size: 20,
                  ),
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
                  width: size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.lightGreen.withAlpha(50)),
                  child: TextField(
                    controller: firstname,
                    decoration: const InputDecoration(
                        label: Text("ชื่อ"),
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.user,
                          color: Color(0XFF397D54),
                          size: 20,
                        )),
                  )),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.lightGreen.withAlpha(50)),
                  child: TextField(
                    controller: lastname,
                    decoration: const InputDecoration(
                        label: Text("นามสกุล"),
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.user,
                          color: Color(0XFF397D54),
                          size: 20,
                        )),
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
                  child: TextField(
                    controller: username,
                    decoration: const InputDecoration(
                        label: Text("ชื่อผู้ใช้"),
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.user,
                          color: Color(0XFF397D54),
                          size: 20,
                        )),
                  )),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.lightGreen.withAlpha(50)),
                  child: TextField(
                    controller: password,
                    decoration: const InputDecoration(
                        label: Text("รหัสผู้ใช้"),
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.user,
                          color: Color(0XFF397D54),
                          size: 20,
                        )),
                  )),
            ],
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.93,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: TextField(
                controller: email,
                decoration: const InputDecoration(
                    label: Text("อีเมล์"),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.93,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: TextField(
                controller: tel,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                  MaskedInputFormatter('##.##')
                ],
                decoration: const InputDecoration(
                    label: Text("เบอร์โทร"),
                    hintStyle: TextStyle(color: Colors.black),
                    //suffixIcon: _getClearButton_weight(),
                    border: InputBorder.none,
                    icon: Icon(
                      FontAwesomeIcons.mobileScreen,
                      color: Color(0XFF397D54),
                      size: 20,
                    )),
              )),
          const Text("ที่อยู่"),
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
                  child: TextField(
                    controller: address,
                    decoration: const InputDecoration(
                      label: Text("ที่อยู่"),
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
                  child: TextField(
                    controller: village,
                    decoration: const InputDecoration(
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
                  child: TextField(
                    controller: alley,
                    decoration: const InputDecoration(
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
                  child: TextField(
                    controller: road,
                    decoration: const InputDecoration(
                      label: Text("ถนน"),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  )),
            ],
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.93,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: TextField(
                controller: district,
                decoration: const InputDecoration(
                  label: Text("ตำบล"),
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
              child: TextField(
                controller: canton,
                decoration: const InputDecoration(
                  label: Text("อำเภอ"),
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
              child: TextField(
                controller: province,
                decoration: const InputDecoration(
                  label: Text("จังหวัด"),
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
              child: TextField(
                controller: zip_code,
                decoration: const InputDecoration(
                  label: Text("รหัสไปรษณีย์"),
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              )),
          const Text("ข้อมูลฟาร์ม"),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.93,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: TextField(
                controller: farmname,
                decoration: const InputDecoration(
                    label: Text("ชื่อฟาร์ม"),
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    icon: Icon(
                      FontAwesomeIcons.house,
                      color: Color(0XFF397D54),
                      size: 20,
                    )),
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
                decoration: const InputDecoration(
                  hintText: 'ประเภทฟาร์ม',
                  hintStyle: TextStyle(color: Colors.black),
                  icon: Icon(
                    FontAwesomeIcons.flag,
                    color: Color(0XFF397D54),
                    size: 20,
                  ),
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
                      child: file == null
                          ? Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: const Text("ไม่มีรูปภาพ"))
                          : Image.file(file!)),
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
              //final image_farm = await Storage().uploadFile(file);
/*
                    storage
                        .uploadimage(fileName, filePath)
                        .then(((value) => print("done")));*/

              setState(() {
                String owername =
                    "$name_title${firstname.text} ${lastname.text}";
                farm.owner_name = owername;
                farm.username = username.text;
                farm.password = password.text;
                farm.email = email.text;
                farm.tel = tel.text;

                String testAddress =
                    "${address.text}/${village.text} ${alley.text} ${road.text} ${district.text} ${canton.text} ${province.text} ${zip_code.text}";
                farm.addressFarm = testAddress;
                farm.name_Farm = farmname.text;
                Farmtype newFarmtype = Farmtype(name_FarmType: farmcategory);
                farm.farmtype = newFarmtype;
                farm.photo = "-";
              });
              final farm2 = await Farm_data().registerfarm(farm);

              if (farm2 != null) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: ((context) {
                  return const LoginScreen();
                })));
              }
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 34, 120, 37).withAlpha(50)),
              alignment: Alignment.center,
              child: const Text('ลงทะเบียนโค',
                  style: TextStyle(color: Color(0xff235d3a), fontSize: 18)),
            ),
          ),
        ],
      )),
    );
  }
}
