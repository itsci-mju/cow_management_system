import 'dart:convert';

import 'package:cow_mange/DetailCow.dart';
import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/url/URL.dart';

import 'class/Progress.dart';

class AddProgress extends StatefulWidget {
  final Cow cow;
  final Employee? emp;
  final Farm? fm;
  const AddProgress({Key? key, required this.cow, this.emp, this.fm})
      : super(key: key);

  @override
  State<AddProgress> createState() => _AddProgressState();
}

class _AddProgressState extends State<AddProgress> {
  //class
  Progress? pg = Progress();
  Cow? co = Cow();
  List<Progress> listprogress = [];

  DateTime? progress_date;

  DateTime? birthday;
  Cow? cow = Cow();
  Employee emp = Employee();

  final birth = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();
  final age = TextEditingController();

  //  button clear
  bool _showClearButton_date = false;
  bool _showClearButton_weight = false;
  bool _showClearButton_height = false;

  //error text
  String texterror = "";

  //map
  List<dynamic>? list;
  Map? mapResponse;

  Future clean_number() async {
    birth.addListener(() {
      setState(() {
        _showClearButton_date = birth.text.isNotEmpty;
      });
    });
    weight.addListener(() {
      setState(() {
        _showClearButton_weight = weight.text.isNotEmpty;
      });
    });
    height.addListener(() {
      setState(() {
        _showClearButton_height = height.text.isNotEmpty;
      });
    });
  }

  Future listMaincow(Employee emp) async {
    final JsonlistMaincow = emp.toJsoncow();

    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Listmaincow),
      body: jsonEncode({"Farm_id_Farm": emp.farm!.id_Farm}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Cow.fromJson(e)).toList();
    }
  }

  Future init() async {
    setState(() {
      cow = widget.cow;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    clean_number();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //date
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    progress_date = now;

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
                        child: Text("การพัฒนาโค รหัส :${cow!.cow_id}",
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
                        child: Text(
                            "กรอกข้อมูลให้ถูกต้องก่อนเพิ่มข้อมูลการพัฒนาโค",
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
            SizedBox(height: 10),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.lightGreen.withAlpha(50)),
                child: TextFormField(
                  controller: birth,
                  readOnly: true,
                  validator: Validators.required_isempty("กรุณาเลือกวันเกิดโค"),
                  decoration: InputDecoration(
                      label: const Text(
                        "เลือกวันพัฒนาการโค",
                        style: TextStyle(color: Colors.black),
                      ),
                      hintText: "Date is not selected",
                      suffixIcon: _getClearButton_date(),
                      hintStyle: const TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      icon: const Icon(
                        FontAwesomeIcons.calendar,
                        color: Color(0XFF397D54),
                        size: 20,
                      )),
                  onTap: () async {
                    birthday = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: cow!.birthday!,
                        lastDate: DateTime.now());

                    if (birthday != null) {
                      DateTime d = DateTime(
                          birthday!.year + 543, birthday!.month, birthday!.day);

                      String formattedDate = DateFormat('dd-MM-yyyy').format(d);

                      setState(() {
                        birth.text = formattedDate;
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                )),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.lightGreen.withAlpha(50)),
                child: TextFormField(
                    controller: weight,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                      MaskedInputFormatter('###.##')
                    ],
                    decoration: InputDecoration(
                        label: const Text("น้ำหนัก (กิโลกรัม)"),
                        hintStyle: const TextStyle(color: Colors.black),
                        suffixIcon: _getClearButton_weight(),
                        border: InputBorder.none,
                        icon: const Icon(
                          FontAwesomeIcons.weightHanging,
                          color: Color(0XFF397D54),
                          size: 20,
                        )),
                    validator: Validators.required_isempty(
                        "กรุณากรอก น้ำหนัก(กิโลกรัม)"))),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.lightGreen.withAlpha(50)),
                child: TextFormField(
                    controller: height,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                    ],
                    decoration: InputDecoration(
                        label: const Text("ส่วนสูง (เซนติเมตร)"),
                        suffixIcon: _getClearButton_height(),
                        hintStyle: const TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        icon: const Icon(
                          FontAwesomeIcons.textHeight,
                          color: Color(0XFF397D54),
                          size: 20,
                        )),
                    validator: Validators.required_isempty(
                        "กรุณากรอก ส่วนสูง(เซนติเมตร)"))),
            Text(
              texterror,
              style: const TextStyle(color: Colors.red),
            ),
            InkWell(
              onTap: () async {
                bool validate = _formKey.currentState!.validate();
                if (validate == false) {
                  setState(() {
                    texterror = "กรุณากรอกข้อมูลให้ครบถ้วน";
                  });
                } else {
                  setState(() {
                    texterror = "";
                  });
                  pg?.progress_date = birthday;
                  pg?.weight = double.parse(weight.text);
                  pg?.height = double.parse(height.text);
                  pg?.cow = Cow.Idcow(cow_id: cow!.cow_id);

                  final progress = await Progress_data().AddProgresscow(pg!);

                  if (progress != null) {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: ((context) {
                      return DetailCow(
                        cow: widget.cow,
                        fm: widget.fm,
                      );
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
                child: const Text('เพิ่มข้อมูลการพัฒนาโค',
                    style: TextStyle(color: Color(0xff235d3a), fontSize: 18)),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget? _getClearButton_date() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_date) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          birth.clear();
        });
  }

  Widget? _getClearButton_weight() {
    if (!_showClearButton_weight) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          weight.clear();
        });
  }

  Widget? _getClearButton_height() {
    if (!_showClearButton_height) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          height.clear();
        });
  }
}
