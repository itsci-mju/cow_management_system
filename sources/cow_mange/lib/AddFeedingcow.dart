import 'dart:convert';

import 'package:cow_mange/DetailCow.dart';
import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Feeding.dart';
import 'package:cow_mange/class/Progress.dart';
import 'package:cow_mange/class/food.dart';
import 'package:cow_mange/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cow_mange/url/URL.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AddFeedingcow extends StatefulWidget {
  final Cow? cow;
  final Employee? emp;
  final Farm? fm;
  const AddFeedingcow({Key? key, required this.cow, this.emp, this.fm})
      : super(key: key);

  @override
  State<AddFeedingcow> createState() => _AddFeedingcowState();
}

class _AddFeedingcowState extends State<AddFeedingcow> {
  //map
  List<dynamic>? list;
  Map? mapResponse;
  //cow
  Cow? co = Cow();

  String id_cow = "";

  //food
  String name_food = "";
  String food_supplement = "";

  DateTime? birthday;
  TimeOfDay? timebirthday;

  // list_id_cow
  List<String> listcow_id = [];
  //list namefood
  List<String> list_food = [];
  List<String> list_food_supplement = [];

  //feeding
  Feeding? fd = Feeding();

  //date
  DateTime? record_date;
  DateTime? text_date;

  List<Cow> listcow = [];
  Cow? cow = Cow();

  //Date_time
  List<String> Time = ['เช้า', 'เย็น'];
  String time = "";

  //controller
  final count_c = TextEditingController();
  final date_fedding = TextEditingController();

  //progress
  List<Progress> Listprogress = [];

  //Feeding
  List<Feeding> Listfeeding = [];

  int error_date = 1;

  String error_text = "";
  String error_text_2 = "";
  double? doubleWeight = 0;
  String check_weight = "";

  //text_error
  String error_text3 = "";

  //textweight
  String weight = "0";

  //  button clear
  bool _showClearButton_date_fedding = false;

  //var
  var half = 0.0;

  Future clean_number() async {
    date_fedding.addListener(() {
      setState(() {
        _showClearButton_date_fedding = date_fedding.text.isNotEmpty;
      });
    });
  }

  Future listfood() async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_list_food.toString()),
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      mapResponse = json.decode(response.body);

      list = map['result'];

      for (dynamic l in list!) {
        list_food.add(l['food_name']);
      }

      return list_food;
    }
  }

  Future init() async {
    //final co = await fetchCow(widget.emp!.farm!.id_Farm);
    final f = await listfood();

    // final listcow = await listMaincow(widget.emp!);
    final list_Pg =
        await Progress_data().listMainprogress(widget.cow!.cow_id.toString());
    final list_fd =
        await Feeding_data().listMainFedding(widget.cow!.cow_id.toString());

    setState(() {
      //  listcow_id = co;
      list_food = f;

      cow = widget.cow;
      Listprogress = list_Pg;
      Listfeeding = list_fd;

      // cow = listcow;
    });
    List<double> weight = [];

    for (int i = 0; i < Listprogress.length; i++) {
      setState(() {
        weight.add(Listprogress[i].weight!.toDouble());
      });
    }

    if (weight.isNotEmpty || weight.length > 0) {
      double w = 0.00;

      weight.sort();
      w = weight[weight.length - 1];
      if (w <= 100) {
        setState(() {
          doubleWeight = widget.cow!.weight!.toDouble();
        });
      } else {
        setState(() {
          doubleWeight = weight[weight.length - 1];
        });
      }
    } else {
      setState(() {
        doubleWeight = widget.cow!.weight!.toDouble();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    setState(() {
      id_cow = widget.cow!.cow_id.toString();
    });
    clean_number();
  }

  Future AddFeedingcow(Feeding feeding) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_feeding_add.toString()),
      body: jsonEncode(feeding.tojson_Feeding()),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic feeding = mapResponse['result'];
      return Feeding.fromJson(feeding);
    } else {
      throw Exception('Failed to load album');
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //date_now
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    record_date = now;

    ///////
    return Scaffold(
      body: cow!.weight == null
          ? SingleChildScrollView(
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
                              child: Text("การให้อาหารโค ",
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
                                  "กรอกข้อมูลให้ถูกต้องก่อนเพิ่มข้อมูลการให้อาหารโค",
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
                        items: list_food.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {},
                        decoration: const InputDecoration(
                          hintText: 'ชื่ออาหาร',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(
                            FontAwesomeIcons.bowlFood,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.93,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: date_fedding,
                        readOnly: true,
                        validator: Validators.required_isempty(
                            "กรุณาเลือกวันให้อาหาร"),
                        decoration: InputDecoration(
                            label: Text(
                              "เลือกวันให้อาหาร",
                              style: TextStyle(color: Colors.black),
                            ),
                            hintText: "กรุณาเลือกวันให้อาหาร",
                            suffixIcon: _getClearButton_date_fedding(),
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.calendar,
                              color: Color(0XFF397D54),
                              size: 20,
                            )),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(error_text_2,
                                    style: TextStyle(color: Colors.red)),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  error_text,
                                ),
                              ))
                        ],
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
                        controller: count_c,
                        validator: Validators.required_isempty(
                            "กรุณากรอก จำนวน(กิโลกรัม)"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                          MaskedInputFormatter('#.#')
                        ],
                        decoration: InputDecoration(
                            label: Text("จำนวน (กิโลกรัม)"),
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.weightHanging,
                              color: Color(0XFF397D54),
                              size: 20,
                            )),
                      )),
                  Text(
                    error_text3,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ))
          // ค่าไม่เท่ากับ Null
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
                              child: Text("การให้อาหารโค ",
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
                                  "กรอกข้อมูลให้ถูกต้องก่อนเพิ่มข้อมูลการให้อาหารโค",
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
                  const SizedBox(height: 20),
                  Text(
                    "โค : ${cow!.cow_id} มีน้ำหนัก $doubleWeight กิโลกรัม",
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _amount_feeding(doubleWeight!, name_food),
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
                        items: list_food.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            name_food = newValue!;
                          });
                        },
                        validator:
                            Validators.required_isnull("กรุณาเลือกอาหาร"),
                        decoration: const InputDecoration(
                          hintText: 'ชื่ออาหาร',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(
                            FontAwesomeIcons.bowlFood,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.93,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: Column(children: [
                      DropdownButtonFormField(
                        isExpanded: true,
                        items: [
                          '-',
                          'ร็อคโก้ ',
                          'แร่ธาตุก้อน SK ',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            food_supplement = newValue!;
                          });
                        },
                        validator:
                            Validators.required_isnull("กรุณาเลือกอาหารเสริม"),
                        decoration: const InputDecoration(
                          hintText: 'ชื่ออาหารเสริม',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(
                            FontAwesomeIcons.bowlFood,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.93,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: date_fedding,
                        readOnly: true,
                        validator:
                            Validators.required_isempty("กรุณาเลือกวันเกิดโค"),
                        decoration: InputDecoration(
                            label: Text(
                              "เลือกวันให้อาหาร",
                              style: TextStyle(color: Colors.black),
                            ),
                            hintText: "กรุณาเลือกวันให้อาหาร",
                            suffixIcon: _getClearButton_date_fedding(),
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(
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

                          timebirthday = (await showTimePicker(
                              context: context, initialTime: TimeOfDay.now()));

                          if (birthday != null) {
                            DateTime d = DateTime(birthday!.year + 543,
                                birthday!.month, birthday!.day);
                            TimeOfDay t = TimeOfDay(
                                hour: timebirthday!.hour,
                                minute: timebirthday!.minute);
                            String formattedDate =
                                DateFormat('dd-MM-yyyy : HH:mm').format(
                                    DateTime(d.year, d.month, d.day, t.hour,
                                        t.minute));
                            DateTime s = DateTime(
                                birthday!.year,
                                birthday!.month,
                                birthday!.day,
                                t.hour,
                                t.minute);

                            setState(() {
                              date_fedding.text = formattedDate;
                              text_date = s;
                            });
                          } else {}
                        },
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(error_text_2,
                                    style: TextStyle(color: Colors.red)),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  error_text,
                                ),
                              ))
                        ],
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
                        controller: count_c,
                        validator: Validators.required_isempty(
                            "กรุณากรอก จำนวน(กิโลกรัม)"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                          MaskedInputFormatter('##.##')
                        ],
                        enabled: false,
                        decoration: InputDecoration(
                            label: Text("จำนวน (กิโลกรัม)"),
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.weightHanging,
                              color: Color(0XFF397D54),
                              size: 20,
                            )),
                      )),
                  Text(
                    error_text3,
                    style: TextStyle(color: Colors.red),
                  ),
                  InkWell(
                    onTap: () async {
                      bool validate = _formKey.currentState!.validate();
                      if (validate == false) {
                      } else {
                        int error_ = 0;
                        //date
                        DateTime now = new DateTime.now();
                        DateTime date_input = DateTime(
                          text_date!.year,
                          text_date!.month,
                          text_date!.day,
                          /*text_date!.hour,
                            text_date!.minute*/
                        );
                        DateTime date_time_input = DateTime(
                            text_date!.year,
                            text_date!.month,
                            text_date!.day,
                            text_date!.hour,
                            text_date!.minute);

                        DateTime morning_start = DateTime(text_date!.year,
                            text_date!.month, text_date!.day, 5, 59);
                        DateTime morning_end = DateTime(text_date!.year,
                            text_date!.month, text_date!.day, 12, 00);

                        DateTime afternoon_start = DateTime(text_date!.year,
                            text_date!.month, text_date!.day, 12, 01);
                        DateTime afternoon_end = DateTime(text_date!.year,
                            text_date!.month, text_date!.day, 18, 01);

                        final morning =
                            (date_time_input.isAfter(morning_start)) &&
                                (date_time_input.isBefore(morning_end));

                        final afternoon =
                            (date_time_input.isAfter(afternoon_start)) &&
                                (date_time_input.isBefore(afternoon_end));

                        if (morning == false && afternoon == false) {
                          setState(() {
                            error_text_2 = "***";
                            error_text =
                                "เลือกช่วงเวลาให้ถูกต้อง\nช่วงเช้า 6:00-12:00 ช่วงเย็น 12:01-18:00";
                            error_ = 1;
                            date_fedding.text = "เลือกวันให้ถูกต้อง";
                            error_text3 = "กรุณากรอกข้อมูลให้ถูกต้อง";
                          });
                        } else {
                          for (int i = 0; i < Listfeeding.length; i++) {
                            if (Listfeeding[i].record_date == date_input &&
                                morning == true &&
                                Listfeeding[i].time == "เช้า") {
                              DateTime date = DateTime(
                                  text_date!.year + 543,
                                  text_date!.month,
                                  text_date!.day,
                                  date_time_input.hour,
                                  date_time_input.minute);
                              setState(() {
                                error_text_2 = "***";
                                error_text = "วันที่ " +
                                    date.day.toString() +
                                    "-" +
                                    date.month.toString() +
                                    "-" +
                                    date.year.toString() +
                                    "มีการเพิ่มข้อมูล ในช่วงเช้า ไปแล้ว";

                                error_ = 1;
                                date_fedding.text = "เลือกวันให้ถูกต้อง";
                                error_text3 = "กรุณากรอกข้อมูลให้ถูกต้อง";
                              });
                            } else if ((Listfeeding[i].record_date ==
                                    date_input &&
                                afternoon == true &&
                                Listfeeding[i].time == "เย็น")) {
                              DateTime date = DateTime(
                                  text_date!.year + 543,
                                  text_date!.month,
                                  text_date!.day,
                                  date_time_input.hour,
                                  date_time_input.minute);
                              setState(() {
                                error_text_2 = "***";
                                error_text = "วันที่ " +
                                    date.day.toString() +
                                    "-" +
                                    date.month.toString() +
                                    "-" +
                                    date.year.toString() +
                                    "มีการเพิ่มข้อมูล ในช่วงเย็น ไปแล้ว";
                                error_ = 1;
                                date_fedding.text = "เลือกวันให้ถูกต้อง";
                                error_text3 = "กรุณากรอกข้อมูลให้ถูกต้อง";
                              });
                            }
                          }
                          if (error_ == 0) {
                            setState(() {
                              error_text_2 = "";
                              error_text = "";
                              error_text3 = "";
                            });
                            fd?.record_date = text_date;
                            fd?.food_supplement = food_supplement;

                            fd?.amount = double.parse(count_c.text);
                            fd?.cow = Cow.Idcow(cow_id: widget.cow!.cow_id);
                            if (morning == true && afternoon == false) {
                              fd?.time = "เช้า";
                            } else if (morning == false && afternoon == true) {
                              fd?.time = "เย็น";
                            }

                            fd?.food = Food.Idfood(foodid: name_food);

                            final feeding = await AddFeedingcow(fd!);
                            if (feeding != null && widget.emp != null) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: ((context) {
                                return DetailCow(
                                  cow: widget.cow!,
                                  emp: widget.emp,
                                );
                              })));
                            } else if (feeding != null && widget.fm != null) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: ((context) {
                                return DetailCow(
                                  cow: widget.cow!,
                                  fm: widget.fm,
                                );
                              })));
                            }
                          }
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
                      child: const Text('เพิ่มข้อมูลการให้อาหารโค',
                          style: TextStyle(
                              color: Color(0xff235d3a), fontSize: 18)),
                    ),
                  ),
                ],
              ),
            )),
    );
  }

  Widget? _getClearButton_date_fedding() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_date_fedding) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          date_fedding.clear();
        });
  }

  _amount_feeding(double one, String nameFood) {
    if (nameFood == "อาหารข้น") {
      //สูตรคำนวณ
      one *= 0.01;
      setState(() {
        half = one / 2;
        count_c.text = half.toString();
      });
      return Container(
        margin: const EdgeInsets.only(left: 40),
        child: Row(children: [
          Text(
              "คิดเป็น $one กิโลกรัม ต่อ 1 วัน\n* โดยช่วงเช้าเป็น$half กิโลกรัม \n  โดยแบ่งช่วงเย็นเป็น $half กิโลกรัม",
              style: const TextStyle(
                  fontSize: 15, color: Colors.black, height: 1.5))
        ]),
      );
    } else if (nameFood == "หญ้า") {
      //สูตรคำนวณ
      one *= 0.04;
      setState(() {
        half = one / 2;
        count_c.text = half.toString();
      });
      return Container(
        margin: const EdgeInsets.only(left: 40),
        child: Row(children: [
          Text(
              "คิดเป็น $one กิโลกรัม ต่อ 1 วัน\n* โดยแบ่งช่วงเช้าเป็น$half กิโลกรัม \n  โดยแบ่งช่วงเย็นเป็น $half กิโลกรัม",
              style: const TextStyle(
                  fontSize: 15, color: Colors.black, height: 1.5))
        ]),
      );
    } else if (nameFood == "ฟาง") {
      //สูตรคำนวณ
      one *= 0.03;
      setState(() {
        half = one / 2;
        count_c.text = half.toString();
      });
      return Container(
        margin: const EdgeInsets.only(left: 40),
        child: Row(children: [
          Text(
              "คิดเป็น $one กิโลกรัม ต่อ 1 วัน\n* โดยแบ่งช่วงเช้าเป็น$half กิโลกรัม \n  โดยแบ่งช่วงเย็นเป็น $half กิโลกรัม",
              style: const TextStyle(
                  fontSize: 15, color: Colors.black, height: 1.5))
        ]),
      );
    } else {
      return Container();
    }
  }
}
