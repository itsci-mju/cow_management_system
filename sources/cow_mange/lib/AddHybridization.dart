// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cow_mange/DetailCow.dart';
import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Hybridization.dart';
import 'package:cow_mange/class/Typehybridization.dart';
import 'package:cow_mange/validators.dart';
import 'package:flutter/material.dart';

import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cow_mange/url/URL.dart';
import 'package:intl/intl.dart';

class AddHybridization extends StatefulWidget {
  final Cow cow;
  final Employee? emp;
  final Farm? fm;
  const AddHybridization({Key? key, required this.cow, this.emp, this.fm})
      : super(key: key);

  @override
  State<AddHybridization> createState() => _AddHybridizationState();
}

class _AddHybridizationState extends State<AddHybridization> {
  //class
  Cow? co = Cow();
  Hybridization? hyb = Hybridization();

  String id_bul_cow = "";
  String id_cow_cow = "";
  String text_result = "";
  List<String> listcow = [];
  DateTime? progress_date;
  String name_typeHybridization = "";

  // list_id_cow
  List<String> listcow_id = [];

  final birth = TextEditingController();
  final result = TextEditingController();
  final date_Hybirdzation_controller = TextEditingController();
  //  button clear
  final bool _showClearButton_date = false;
  final bool _showClearButton_weight = false;
  final bool _showClearButton_height = false;

  //map
  List<dynamic>? list;
  Map? mapResponse;

  DateTime? dute_to_Brith;
  DateTime? date_Hybirdzation;

  List<String> typeHybridization = [];

  //class
  List<Cow> cow = [];

  //List
  List<String> list_cow = [""];
  List<String> list_bull = [""];
  List<String> Result = ["สำเร็จ", "ไม่สำเร็จ"];

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

  Future AddHybridization(Hybridization hybridization) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_hybridization_add.toString()),
      body: jsonEncode(hybridization.tojson_Hybridization()),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic progress = mapResponse['result'];

      return Hybridization.fromJson(progress);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future list_typehybridization() async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_list_typehybridization.toString()),
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      mapResponse = json.decode(response.body);

      list = map['result'];

      for (dynamic l in list!) {
        typeHybridization.add(l['name_typehybridization']);
      }

      return typeHybridization;
    }
  }

  Future init() async {
    if (widget.cow.gender == "เมีย") {
      if (widget.emp != null) {
        final bu =
            await Cow_data().fetchbull(widget.emp!.farm!.id_Farm.toString());
        setState(() {
          list_cow = [];
          list_cow.add(widget.cow.cow_id.toString());
          list_bull = bu;
        });
      } else {
        final bu = await Cow_data().fetchbull(widget.fm!.id_Farm.toString());
        setState(() {
          list_cow = [];
          list_cow.add(widget.cow.cow_id.toString());
          list_bull = bu;
        });
      }
    } else {
      if (widget.emp != null) {
        final co =
            await Cow_data().fetchCow(widget.emp!.farm!.id_Farm.toString());
        setState(() {
          list_cow = co;
          list_bull = [];
          list_bull.add(widget.cow.cow_id.toString());
        });
      } else {
        final co = await Cow_data().fetchCow(widget.fm!.id_Farm.toString());
        setState(() {
          list_cow = co;
          list_bull = [];
          list_bull.add(widget.cow.cow_id.toString());
        });
      }
    }

    final typehybrid = await list_typehybridization();

    setState(() {
      typeHybridization = typehybrid;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    //clean_number();
  }

  @override
  final _formKey = GlobalKey<FormState>();
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
                        child: Text("ข้อมูลการผสมพันธุ์โค ",
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
                            "กรอกข้อมูลให้ถูกต้องก่อนเพิ่มข้อมูลการผสมพันธุ์โค",
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
                margin: EdgeInsets.fromLTRB(30, 30, 0, 0),
                child: Row(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: const Text("*** ",
                              style: TextStyle(color: Colors.red)),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: const Text(
                            " พ่อพันธุ์ ",
                          ),
                        ))
                  ],
                )),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: Column(children: [
                DropdownButtonFormField(
                  items: list_bull.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      id_bul_cow = newValue!;
                    });
                  },
                  validator:
                      Validators.contains_1text("----", "กรุณาเลือกพ่อพันธุ์"),
                  decoration: InputDecoration(
                    hintText: list_bull[0].toString(),
                    hintStyle: const TextStyle(color: Colors.black),
                    icon: const Icon(
                      FontAwesomeIcons.cow,
                      color: Color(0XFF397D54),
                      size: 20,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ]),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: const Text("*** ",
                              style: TextStyle(color: Colors.red)),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: const Text(
                            "แม่พันธุ์ ",
                          ),
                        ))
                  ],
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: Column(children: [
                DropdownButtonFormField(
                  items: list_cow.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      id_cow_cow = newValue!;
                    });
                  },
                  validator:
                      Validators.contains_1text("----", "กรุณาเลือกแม่พันธุ์"),
                  decoration: InputDecoration(
                    hintText: list_cow[0].toString(),
                    hintStyle: const TextStyle(color: Colors.black),
                    icon: const Icon(
                      FontAwesomeIcons.cow,
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
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: Column(children: [
                DropdownButtonFormField(
                  items: Result.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      text_result = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'ผลลัพธ์',
                    hintStyle: TextStyle(color: Colors.black),
                    icon: Icon(
                      FontAwesomeIcons.checkToSlot,
                      color: Color(0XFF397D54),
                      size: 20,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ]),
            ),
            date_of_birth(text_result),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.lightGreen.withAlpha(50)),
                child: TextField(
                  controller: date_Hybirdzation_controller,
                  readOnly: true,
                  decoration: InputDecoration(
                      label: const Text(
                        "เลือกวันผสมพันธุ์  ",
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
                    date_Hybirdzation = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now());

                    if (date_Hybirdzation != null) {
                      DateTime d = DateTime(date_Hybirdzation!.year + 543,
                          date_Hybirdzation!.month, date_Hybirdzation!.day);

                      String formattedDate = DateFormat('dd-MM-yyyy').format(d);

                      setState(() {
                        date_Hybirdzation_controller.text = formattedDate;
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: Column(children: [
                DropdownButtonFormField(
                  items: typeHybridization.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      name_typeHybridization = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'ประเภทการผสมพันธุ์',
                    hintStyle: TextStyle(color: Colors.black),
                    icon: Icon(
                      FontAwesomeIcons.list,
                      color: Color(0XFF397D54),
                      size: 20,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ]),
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  if (dute_to_Brith != null) {
                    hyb!.date_of_birthday = dute_to_Brith;
                    hyb!.date_Hybridization = date_Hybirdzation;
                    hyb!.result = text_result;
                    hyb!.typebridization = Typebridization.nameTypebridization(
                        name_typebridization: name_typeHybridization);

                    hyb?.bull_cow = Cow.Idcow(cow_id: id_bul_cow);
                    hyb?.cow_cow = Cow.Idcow(cow_id: id_cow_cow);
                  } else {
                    hyb!.date_Hybridization = date_Hybirdzation;
                    hyb!.result = text_result;
                    hyb!.typebridization = Typebridization.nameTypebridization(
                        name_typebridization: name_typeHybridization);
                    hyb?.bull_cow = Cow.Idcow(cow_id: id_bul_cow);
                    hyb?.cow_cow = Cow.Idcow(cow_id: id_cow_cow);
                  }
                });
                final hybridization = await AddHybridization(hyb!);
                if (hybridization != null) {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: ((context) {
                    return DetailCow(
                      cow: widget.cow,
                      fm: widget.fm,
                    );
                  })));
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
          color: Colors.green,
        ),
        onTap: () {
          birth.clear();
        });
  }

  date_of_birth(textResult) {
    Size size = MediaQuery.of(context).size;
    if (textResult == "สำเร็จ") {
      return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.lightGreen.withAlpha(50)),
          child: TextField(
            controller: birth,
            readOnly: true,
            decoration: InputDecoration(
                label: const Text(
                  "เลือกวันที่คลอด",
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
              dute_to_Brith = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101));

              if (dute_to_Brith != null) {
                DateTime d = DateTime(dute_to_Brith!.year + 543,
                    dute_to_Brith!.month, dute_to_Brith!.day);

                String formattedDate = DateFormat('dd-MM-yyyy').format(d);

                setState(() {
                  birth.text = formattedDate;
                });
              } else {
                print("Date is not selected");
              }
            },
          ));
    } else {
      return Container();
    }
  }
}
