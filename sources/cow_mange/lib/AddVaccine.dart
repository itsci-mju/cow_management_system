import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:cow_mange/DetailCow.dart';
import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Vaccine.dart';
import 'package:cow_mange/class/vaccination.dart';
import 'package:cow_mange/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cow_mange/url/URL.dart';
import 'package:intl/intl.dart';

class AddVaccine extends StatefulWidget {
  final Cow cow;
  final Farm? fm;
  final Employee? emp;
  const AddVaccine({Key? key, required this.cow, this.emp, this.fm})
      : super(key: key);

  @override
  State<AddVaccine> createState() => _AddVaccineState();
}

class _AddVaccineState extends State<AddVaccine> {
  //map
  List<dynamic>? list;
  Map? mapResponse;

  //String
  String id_cow = "";
  String name_vaccine = "";
  String injection_program = "";
  List<String> list_injection_program = [];

  String day = "";
  String month = "";
  String year = "";
  String text_date_vaccine = "";
  String text_date_vaccine2 = "";
  String error_text = "";

  //int
  int int_countvaccine = 0;

  //list_String
  List<String> listcow = [];
  List<String> listcow_id = [];
  List<String> list_String_vaccine = [];

  //list_class
  List<Vaccine> listvaccine = [];
  List<Vaccination> listVaccination = [];
  List<Cow> cow = [];

  //date
  DateTime? dateVaccine;
  DateTime? date_vaccine;
  DateTime? startDate = DateTime(DateTime.now().year - 10);
  DateTime? startDate_type1 = DateTime(DateTime.now().year - 10);

  //object
  Vaccination vct = Vaccination();
  Cow co = Cow();

  // controller
  final vaccine = TextEditingController();
  final date_vaccine_c = TextEditingController();
  final countvaccine = TextEditingController();
  final doctorname = TextEditingController();
  final price = TextEditingController();

  //  button clear
  bool _showClearButton_name_doctor = false;

  Future clean_number() async {
    doctorname.addListener(() {
      setState(() {
        _showClearButton_name_doctor = doctorname.text.isNotEmpty;
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
    final vc = await Vaccine_data().listvaccine();
    final list_vc = await Vaccination_data()
        .listMainVaccination(widget.cow.cow_id.toString());

    setState(() {
      listvaccine = vc;
      listVaccination = list_vc;
      co = widget.cow;

      for (int i = 0; i < listvaccine.length; i++) {
        setState(() {
          list_String_vaccine.add(listvaccine[i].name_vaccine.toString());
        });
      }
      for (int i = 0; i < listvaccine.length; i++) {
        setState(() {
          list_injection_program
              .add(listvaccine[i].injection_program.toString());
        });
      }
      var int_year = int.parse(year);
      var int_month = int.parse(month);
      var int_day = int.parse(day);

      for (int i = 0; i < list_String_vaccine.length; i++) {
        if (list_String_vaccine[i] == listvaccine[0].name_vaccine) {
          //cheak First Time
          bool isFirst = true;
          for (Vaccination v in listVaccination) {
            if (v.cow!.cow_id == co.cow_id &&
                v.vaccine!.name_vaccine == list_String_vaccine[i]) {
              isFirst = false;
              break;
            }
          }
          //First Time
          if (int_month >= 3 && isFirst == true) {
            setState(() {
              startDate = DateTime(
                  co.birthday!.year, co.birthday!.month + 3, co.birthday!.day);
            });
          } else if (isFirst == false) {
            for (Vaccination v in listVaccination) {
              if (v.cow!.cow_id == co.cow_id &&
                  v.vaccine!.name_vaccine == list_String_vaccine[i]) {
                startDate = DateTime(v.dateVaccination!.year,
                    v.dateVaccination!.month, v.dateVaccination!.day);
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(startDate!);
                setState(() {
                  list_String_vaccine[i] = list_String_vaccine[i] +
                      "\nมีการเพิ่มข้อมูลเมือวันที่ : " +
                      formattedDate;
                });
                break;
              }
            }
          }
        } else if (list_String_vaccine[i] == listvaccine[1].name_vaccine) {
          bool isFirst = true;
          for (Vaccination v in listVaccination) {
            if (v.cow!.cow_id == co.cow_id &&
                v.vaccine!.name_vaccine == list_String_vaccine[i]) {
              isFirst = false;
              break;
            }
          }
          if (int_year < 1 && int_month >= 4 && isFirst == true) {
            setState(() {
              startDate = DateTime(
                  co.birthday!.year, co.birthday!.month + 4, co.birthday!.day);
            });
          } else if (isFirst == false) {
            for (Vaccination v in listVaccination) {
              if (v.cow!.cow_id == co.cow_id &&
                  v.vaccine!.name_vaccine == list_String_vaccine[i]) {
                startDate = DateTime(v.dateVaccination!.year,
                    v.dateVaccination!.month + 6, v.dateVaccination!.day);
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(startDate!);
                setState(() {
                  list_String_vaccine[i] = list_String_vaccine[i] +
                      "\nจะเพิ่มข้อมูลได้เมือวันที่ : " +
                      formattedDate;
                });
                break;
              }
            }
          }
        } else if (list_String_vaccine[i] == listvaccine[2].name_vaccine) {
          bool isFirst = true;
          for (Vaccination v in listVaccination) {
            if (v.cow!.cow_id == co.cow_id &&
                v.vaccine!.name_vaccine == list_String_vaccine[i]) {
              isFirst = false;
              break;
            }
          }
          if (int_year < 1 && int_month >= 4 && isFirst == true) {
            setState(() {
              startDate = DateTime(
                  co.birthday!.year, co.birthday!.month + 4, co.birthday!.day);
            });
          } else if (isFirst == false) {
            for (Vaccination v in listVaccination) {
              if (v.cow!.cow_id == co.cow_id &&
                  v.vaccine!.name_vaccine == list_String_vaccine[i]) {
                startDate = DateTime(v.dateVaccination!.year,
                    v.dateVaccination!.month + 6, v.dateVaccination!.day);
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(startDate!);
                setState(() {
                  list_String_vaccine[i] = list_String_vaccine[i] +
                      "\nจะเพิ่มข้อมูลได้เมือวันที่ : " +
                      formattedDate;
                });

                break;
              }
            }
          }
        } else if (list_String_vaccine[i] == listvaccine[3].name_vaccine) {
          bool isFirst = true;
          for (Vaccination v in listVaccination) {
            if (v.cow!.cow_id == co.cow_id &&
                v.vaccine!.name_vaccine == list_String_vaccine[i]) {
              isFirst = false;
              break;
            }
          }
          if (int_year < 1 && int_month >= 3 && isFirst == true) {
            setState(() {
              startDate = DateTime(
                  co.birthday!.year, co.birthday!.month + 3, co.birthday!.day);
            });
          } else if (isFirst == false) {
            for (Vaccination v in listVaccination) {
              if (v.cow!.cow_id == co.cow_id &&
                  v.vaccine!.name_vaccine == list_String_vaccine[i]) {
                startDate = DateTime(v.dateVaccination!.year + 1,
                    v.dateVaccination!.month, v.dateVaccination!.day);
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(startDate!);
                setState(() {
                  list_String_vaccine[i] = list_String_vaccine[i] +
                      "\nจะเพิ่มข้อมูลได้เมือวันที่ : " +
                      formattedDate;
                });
                break;
              }
            }
          }
        } else if (list_String_vaccine[i] == listvaccine[4].name_vaccine) {
          bool isFirst = true;
          for (Vaccination v in listVaccination) {
            if (v.cow!.cow_id == co.cow_id &&
                v.vaccine!.name_vaccine == list_String_vaccine[i]) {
              isFirst = false;
              break;
            }
          }
          if (int_year < 1 && int_month >= 4 && isFirst == true) {
            setState(() {
              startDate = DateTime(
                  co.birthday!.year, co.birthday!.month + 4, co.birthday!.day);
            });
          } else if (isFirst == false) {
            for (Vaccination v in listVaccination) {
              if (v.cow!.cow_id == co.cow_id &&
                  v.vaccine!.name_vaccine == list_String_vaccine[i]) {
                startDate = DateTime(v.dateVaccination!.year + 1,
                    v.dateVaccination!.month, v.dateVaccination!.day);
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(startDate!);
                setState(() {
                  list_String_vaccine[i] = list_String_vaccine[i] +
                      "\nจะเพิ่มข้อมูลได้เมือวันที่ : " +
                      formattedDate;
                });
                break;
              }
            }
          }
        }
      }
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

    return Scaffold(
      body: listvaccine == null
          ? Column(children: const <Widget>[])
          : SingleChildScrollView(
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
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
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
                              child: Text("การเพิ่มข้อมูลวัคซีน ",
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
                                  "กรอกข้อมูลให้ถูกต้องก่อนเพิ่มข้อมูลวัคซีน",
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
                  Text(
                    "รหัสโค : ${widget.cow.cow_id}",
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  SizedBox(height: 05),
                  _birthdayCow(widget.cow),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.93,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: Column(children: [
                      DropdownButtonFormField(
                        isExpanded: true,
                        items: list_String_vaccine.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            enabled: !value
                                    .contains("มีการเพิ่มข้อมูลเมือวันที่") &&
                                !value.contains("จะเพิ่มข้อมูลได้เมือวันที่"),
                            child: Text(
                              "$value \n--------------",
                              style: TextStyle(
                                  color: !value.contains(
                                              "มีการเพิ่มข้อมูลเมือวันที่") &&
                                          !value.contains(
                                              "จะเพิ่มข้อมูลได้เมือวันที่")
                                      ? Colors.black
                                      : Colors.red),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            name_vaccine = newValue!;
                          });
                          var int_year = int.parse(year);
                          var int_month = int.parse(month);
                          var int_day = int.parse(day);
                          if (name_vaccine == listvaccine[0].name_vaccine) {
                            bool isFirst = true;
                            for (Vaccination v in listVaccination) {
                              if (v.cow!.cow_id == co.cow_id &&
                                  v.vaccine!.name_vaccine == name_vaccine) {
                                isFirst = false;
                                break;
                              }
                            }
                            if (int_month >= 3 && isFirst == true) {
                              setState(() {
                                startDate = DateTime(co.birthday!.year,
                                    co.birthday!.month + 3, co.birthday!.day);
                              });
                            } else if (isFirst == false) {
                              for (Vaccination v in listVaccination) {
                                if (v.cow!.cow_id == co.cow_id &&
                                    v.vaccine!.name_vaccine == name_vaccine) {
                                  setState(() {
                                    startDate = DateTime(
                                        v.dateVaccination!.year + 1,
                                        v.dateVaccination!.month,
                                        v.dateVaccination!.day);
                                  });
                                  break;
                                }
                              }
                            }
                          } else if (name_vaccine ==
                              listvaccine[1].name_vaccine) {
                            bool isFirst = true;
                            for (Vaccination v in listVaccination) {
                              if (v.cow!.cow_id == co.cow_id &&
                                  v.vaccine!.name_vaccine == name_vaccine) {
                                isFirst = false;
                                break;
                              }
                            }
                            if (int_year < 1 &&
                                int_month >= 4 &&
                                isFirst == true) {
                              setState(() {
                                startDate = DateTime(co.birthday!.year,
                                    co.birthday!.month + 4, co.birthday!.day);
                              });
                            } else if (isFirst == false) {
                              for (Vaccination v in listVaccination) {
                                if (v.cow!.cow_id == co.cow_id &&
                                    v.vaccine!.name_vaccine == name_vaccine) {
                                  setState(() {
                                    startDate = DateTime(
                                        v.dateVaccination!.year,
                                        v.dateVaccination!.month + 6,
                                        v.dateVaccination!.day);
                                  });
                                  break;
                                }
                              }
                            }
                          } else if (name_vaccine ==
                              listvaccine[2].name_vaccine) {
                            bool isFirst = true;
                            for (Vaccination v in listVaccination) {
                              if (v.cow!.cow_id == co.cow_id &&
                                  v.vaccine!.name_vaccine == name_vaccine) {
                                isFirst = false;
                                break;
                              }
                            }
                            if (int_year < 1 &&
                                int_month >= 4 &&
                                isFirst == true) {
                              setState(() {
                                startDate = DateTime(co.birthday!.year,
                                    co.birthday!.month + 4, co.birthday!.day);
                              });
                            } else if (isFirst == false) {
                              for (Vaccination v in listVaccination) {
                                if (v.cow!.cow_id == co.cow_id &&
                                    v.vaccine!.name_vaccine == name_vaccine) {
                                  setState(() {
                                    startDate = DateTime(
                                        v.dateVaccination!.year,
                                        v.dateVaccination!.month + 6,
                                        v.dateVaccination!.day);
                                  });

                                  break;
                                }
                              }
                            }
                          } else if (name_vaccine ==
                              listvaccine[3].name_vaccine) {
                            bool isFirst = true;
                            for (Vaccination v in listVaccination) {
                              if (v.cow!.cow_id == co.cow_id &&
                                  v.vaccine!.name_vaccine == name_vaccine) {
                                isFirst = false;
                                break;
                              }
                            }
                            if (int_year < 1 &&
                                int_month >= 3 &&
                                isFirst == true) {
                              setState(() {
                                startDate = DateTime(co.birthday!.year,
                                    co.birthday!.month + 3, co.birthday!.day);
                              });
                            } else if (isFirst == false) {
                              for (Vaccination v in listVaccination) {
                                if (v.cow!.cow_id == co.cow_id &&
                                    v.vaccine!.name_vaccine == name_vaccine) {
                                  setState(() {
                                    startDate = DateTime(
                                        v.dateVaccination!.year + 1,
                                        v.dateVaccination!.month,
                                        v.dateVaccination!.day);
                                  });
                                  break;
                                }
                              }
                            }
                          } else if (name_vaccine ==
                              listvaccine[4].name_vaccine) {
                            bool isFirst = true;
                            for (Vaccination v in listVaccination) {
                              if (v.cow!.cow_id == co.cow_id &&
                                  v.vaccine!.name_vaccine == name_vaccine) {
                                isFirst = false;
                                break;
                              }
                            }
                            if (int_year < 1 &&
                                int_month >= 4 &&
                                isFirst == true) {
                              setState(() {
                                startDate = DateTime(co.birthday!.year,
                                    co.birthday!.month + 4, co.birthday!.day);
                              });
                            } else if (isFirst == false) {
                              for (Vaccination v in listVaccination) {
                                if (v.cow!.cow_id == co.cow_id &&
                                    v.vaccine!.name_vaccine == name_vaccine) {
                                  setState(() {
                                    startDate = DateTime(
                                        v.dateVaccination!.year + 1,
                                        v.dateVaccination!.month,
                                        v.dateVaccination!.day);
                                  });
                                  break;
                                }
                              }
                            }
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'ชื่อวัคซีน',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(
                            FontAwesomeIcons.mars,
                            color: Color(0XFF397D54),
                            size: 20,
                          ),
                          border: InputBorder.none,
                        ),
                        validator:
                            Validators.required_isnull("กรุณาเลือกชื่อวัคซีน"),
                      ),
                    ]),
                  ),
                  // if (startDate!.compareTo(DateTime(2023, 03, 21)) <= 0)

                  detailvaccine(name_vaccine),

                  //if (startDate!.compareTo(DateTime(2023, 03, 21)) <= 0)

                  SizedBox(
                    height: 10,
                  ),

                  //if (startDate!.compareTo(DateTime(2023, 03, 21)) <= 0)

                  _injection_program(name_vaccine),
                  // ปี เดือน วัน

                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.93,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: date_vaccine_c,
                        readOnly: true,
                        validator: Validators.contains_3text(
                            "ไม่สามารถฉีดวัคซีนได้เนืองจากอายุ น้อย",
                            "วัคซีนสามารถฉีดได้ครั้งเดียวเท่านั้น",
                            "วัคซีนสามารถฉีดได้วันละครั้งเดียวเท่านั้น",
                            "กรุณาตรวจสอบวันฉีดวัคซีน"),
                        decoration: InputDecoration(
                            label: Text(
                              "เลือกวันที่ฉัดวัคซีน",
                              style: TextStyle(color: Colors.black),
                            ),
                            hintText: "Date is not selected",
                            //suffixIcon: _getClearButton_date(),
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.calendar,
                              color: Color(0XFF397D54),
                              size: 20,
                            )),
                        onTap: () async {
                          date_vaccine = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              //initialDate: DateTime(2023, 03, 21),
                              //firstDate: DateTime(2023, 03, 21),

                              firstDate: startDate!,
                              lastDate: DateTime.now());
                          //lastDate: DateTime(2023, 03, 21));

                          if (date_vaccine != null) {
                            DateTime d = DateTime(date_vaccine!.year + 543,
                                date_vaccine!.month, date_vaccine!.day);

                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(d);

                            setState(() {
                              date_vaccine_c.text = formattedDate;
                              dateVaccine = d;
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      )),

                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.93,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: doctorname,
                        validator:
                            Validators.required_isempty("กรุณากรอกชื่อหมอ"),
                        decoration: InputDecoration(
                            suffixIcon: _getClearButton_name_doctor(),
                            label: Text("ชื่อหมอ"),
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.userDoctor,
                              color: Color(0XFF397D54),
                              size: 20,
                            )),
                      )),

                  InkWell(
                    onTap: () async {
                      bool validate = _formKey.currentState!.validate();

                      var int_year = int.parse(year);
                      var int_month = int.parse(month);
                      var int_day = int.parse(day);

                      if (name_vaccine == listvaccine[0].name_vaccine) {
                        bool isFirst = true;
                        for (Vaccination v in listVaccination) {
                          if (v.cow!.cow_id == co.cow_id &&
                              v.vaccine!.name_vaccine == name_vaccine) {
                            isFirst = false;
                            break;
                          }
                        }
                        if (int_month >= 3 && isFirst == true ||
                            int_year >= 1) {
                          setState(() {
                            int_countvaccine = 2;
                          });
                        } else if (isFirst == false) {
                          DateTime d = DateTime(
                              listVaccination.last.dateVaccination!.year,
                              listVaccination.last.dateVaccination!.month,
                              listVaccination.last.dateVaccination!.day);
                          if (d.compareTo(DateTime.now()) == 0) {
                            setState(() {
                              date_vaccine_c.text =
                                  "วัคซีนสามารถฉีดได้วันละครั้งเดียวเท่านั้น";
                            });
                          }
                        } else {
                          setState(() {
                            date_vaccine_c.text = isFirst == true
                                ? "ไม่สามารถฉีดวัคซีนได้เนืองจากอายุ น้อย"
                                : "วัคซีนสามารถฉีดได้ครั้งเดียวเท่านั้น";
                          });
                        }
                      } else if (name_vaccine == listvaccine[1].name_vaccine) {
                        bool isFirst = true;
                        for (Vaccination v in listVaccination) {
                          if (v.cow!.cow_id == co.cow_id &&
                              v.vaccine!.name_vaccine == name_vaccine) {
                            isFirst = false;
                            break;
                          }
                        }
                        if (int_year < 1 && int_month >= 4 && isFirst == true) {
                          setState(() {
                            int_countvaccine = 5;
                          });
                        } else if (isFirst == false) {
                          DateTime d = DateTime(
                              listVaccination.last.dateVaccination!.year,
                              listVaccination.last.dateVaccination!.month,
                              listVaccination.last.dateVaccination!.day);

                          if (d.year < 1 && d.month >= 10) {
                            setState(() {
                              int_countvaccine = 5;
                            });
                          } else if ((d.year > 0 && d.month > 0)) {
                            setState(() {
                              int_countvaccine = 5;
                            });
                          } else if (d.compareTo(DateTime.now()) == 0) {
                            setState(() {
                              date_vaccine_c.text =
                                  "ัคซีนสามารถฉีดได้วันละครั้งเดียวเท่านั้น";
                            });
                          } else {
                            setState(() {
                              date_vaccine_c.text = "กรุณาตรวจสอบวันฉีดวัคซีน";
                            });
                          }
                        } else {
                          setState(() {
                            date_vaccine_c.text =
                                "ไม่สามารถฉีดวัคซีนได้เนืองจากอายุ น้อย";
                          });
                        }
                      } else if (name_vaccine == listvaccine[2].name_vaccine) {
                        bool isFirst = true;
                        for (Vaccination v in listVaccination) {
                          if (v.cow!.cow_id == co.cow_id &&
                              v.vaccine!.name_vaccine == name_vaccine) {
                            isFirst = false;
                            break;
                          }
                        }
                        if (int_year < 1 && int_month == 4 && isFirst == true) {
                          setState(() {
                            int_countvaccine = 2;
                          });
                        } else if (isFirst = false) {
                          DateTime d = DateTime(
                              listVaccination.last.dateVaccination!.year,
                              listVaccination.last.dateVaccination!.month,
                              listVaccination.last.dateVaccination!.day);
                          if (((d.year < 1 &&
                              (d.month == 5 ||
                                  (d.month == 4 &&
                                      (d.day >= 20 && d.day <= 32)))))) {
                            int_countvaccine = 2;
                          } else if (d.year > 0 && d.month == 5) {
                            setState(() {
                              int_countvaccine = 2;
                            });
                          } else if (d.compareTo(DateTime.now()) == 0) {
                            setState(() {
                              date_vaccine_c.text =
                                  "ัคซีนสามารถฉีดได้วันละครั้งเดียวเท่านั้น";
                            });
                          } else {
                            setState(() {
                              date_vaccine_c.text = "กรุณาตรวจสอบวันฉีดวัคซีน";
                            });
                          }
                        } else {
                          setState(() {
                            date_vaccine_c.text =
                                "ไม่สามารถฉีดวัคซีนได้เนืองจากอายุ น้อย";
                          });
                        }
                      } else if (name_vaccine == listvaccine[3].name_vaccine) {
                        bool isFirst = true;
                        for (Vaccination v in listVaccination) {
                          if (v.cow!.cow_id == co.cow_id &&
                              v.vaccine!.name_vaccine == name_vaccine) {
                            isFirst = false;
                            break;
                          }
                        }
                        if (int_year < 1 && int_month >= 3 && isFirst == true) {
                          setState(() {
                            int_countvaccine = 1;
                          });
                        } else if (isFirst == false) {
                          DateTime d = DateTime(
                              listVaccination.last.dateVaccination!.year,
                              listVaccination.last.dateVaccination!.month,
                              listVaccination.last.dateVaccination!.day);
                          if (d.year > 0 && d.month == 3) {
                            setState(() {
                              int_countvaccine = 1;
                            });
                          } else if (d.compareTo(DateTime.now()) == 0) {
                            setState(() {
                              date_vaccine_c.text =
                                  "ัคซีนสามารถฉีดได้วันละครั้งเดียวเท่านั้น";
                            });
                          } else {
                            setState(() {
                              date_vaccine_c.text = "กรุณาตรวจสอบวันฉีดวัคซีน";
                            });
                          }
                        } else {
                          setState(() {
                            date_vaccine_c.text =
                                "ไม่สามารถฉีดวัคซีนได้เนืองจากอายุ น้อย";
                          });
                        }
                      } else if (name_vaccine == listvaccine[4].name_vaccine) {
                        bool isFirst = true;
                        for (Vaccination v in listVaccination) {
                          if (v.cow!.cow_id == co.cow_id &&
                              v.vaccine!.name_vaccine == name_vaccine) {
                            isFirst = false;
                            break;
                          }
                        }
                        if (int_year < 1 && int_month >= 4 && isFirst == true) {
                          setState(() {
                            int_countvaccine = 1;
                          });
                        } else if (isFirst == false) {
                          DateTime d = DateTime(
                              listVaccination.last.dateVaccination!.year,
                              listVaccination.last.dateVaccination!.month,
                              listVaccination.last.dateVaccination!.day);
                          if (d.year > 0 && d.month >= 4) {
                            setState(() {
                              int_countvaccine = 1;
                            });
                          } else if (d.compareTo(DateTime.now()) == 0) {
                            setState(() {
                              date_vaccine_c.text =
                                  "วัคซีนสามารถฉีดได้วันละครั้งเดียวเท่านั้น";
                            });
                          } else {
                            setState(() {
                              date_vaccine_c.text = "กรุณาตรวจสอบวันฉีดวัคซีน";
                            });
                          }
                        } else {
                          setState(() {
                            date_vaccine_c.text =
                                "ไม่สามารถฉีดวัคซีนได้เนืองจากอายุ น้อย";
                          });
                        }
                      }

                      vct.cow = Cow.Idcow(cow_id: widget.cow.cow_id);
                      vct.dateVaccination = date_vaccine;

                      vct.countvaccine = int_countvaccine;
                      vct.vaccine = Vaccine.IdVaccine(vaccine_id: name_vaccine);
                      vct.doctorname = doctorname.text;

                      if ((validate == false) ||
                          date_vaccine_c.text == "กรุณาตรวจสอบวันฉีดวัคซีน" ||
                          date_vaccine_c.text ==
                              "ไม่สามารถฉีดวัคซีนได้เนืองจากอายุ น้อย" ||
                          date_vaccine_c.text ==
                              "วัคซีนสามารถฉีดได้วันละครั้งเดียวเท่านั้น" ||
                          date_vaccine_c.text ==
                              "วัคซีนสามารถฉีดได้ครั้งเดียวเท่านั้น") {
                        print(1);
                      } else {
                        final vaccination =
                            await Vaccination_data().AddVaccinationcow(vct);

                        if (vaccination != null &&
                            widget.emp != null &&
                            vaccination != 0) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: ((context) {
                            return DetailCow(
                              cow: widget.cow,
                              emp: widget.emp,
                            );
                          })));
                        } else if (vaccination != null &&
                            widget.fm != null &&
                            vaccination != 0) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: ((context) {
                            return DetailCow(
                              cow: widget.cow,
                              fm: widget.fm,
                            );
                          })));
                        } else if (vaccination == 0) {
                          setState(() {
                            date_vaccine_c.text =
                                "วัคซีนสามารถฉีดได้วันละครั้งเดียวเท่านั้น";
                          });
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      width: size.width * 0.93,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color.fromARGB(255, 34, 120, 37)
                              .withAlpha(50)),
                      alignment: Alignment.center,
                      child: const Text('เพิ่มข้อมูลการพัฒนาโค',
                          style: TextStyle(
                              color: Color(0xff235d3a), fontSize: 18)),
                    ),
                  )
                ],
              ),
            )),
    );
  }

  Widget? _getClearButton_name_doctor() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_name_doctor) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          doctorname.clear();
        });
  }

  detailvaccine(nameVaccine) {
    for (int i = 0; i < listvaccine.length; i++) {
      if (nameVaccine == listvaccine[i].name_vaccine) {
        return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                listvaccine[i].how_to_use.toString(),
                style: TextStyle(fontSize: 15),
              ),
            ));
      }
    }
    return Container();
  }

  _injection_program(listInjectionProgram) {
    for (int i = 0; i < listvaccine.length; i++) {
      if (name_vaccine == listvaccine[i].name_vaccine) {
        return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(listvaccine[i].injection_program.toString(),
                  style: TextStyle(color: Colors.red, fontSize: 15)),
            ));
      }
    }
    return Container();
  }

  _birthdayCow(Cow cow) {
    int textYear = 0;
    String textMonth = " ";
    String textDay = " ";

    String colros = "";
    String nameSpecies = "";
    String gender = "";

    DateTime birthday = DateTime.now();
    DateDuration duration;

//Age
    var numY = int.parse(cow.birthday!.year.toString());
    textYear = numY + 543;

    var numM = int.parse(cow.birthday!.month.toString());

    var numD = int.parse(cow.birthday!.day.toString());

    DateTime dateBirthday = DateTime(numY, numM, numD);

    birthday = dateBirthday;
    duration = AgeCalculator.age(dateBirthday);
//colors
    colros = cow.color.toString();
//name_species
    nameSpecies = cow.species!.species_breed.toString();
//gender
    gender = cow.gender.toString();
    setState(() {
      month = duration.months.toString();
      year = duration.years.toString();
      day = duration.days.toString();
    });

    return Align(
        alignment: Alignment.center,
        child: Text("อายุ : $duration",
            style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 12, 2, 2),
                fontWeight: FontWeight.w600)));
  }
}
