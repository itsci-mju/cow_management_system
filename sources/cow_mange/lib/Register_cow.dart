import 'dart:convert';
import 'dart:io';

import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/Mainpage.dart';
import 'package:cow_mange/class/Breeder.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Species.dart';
import 'package:cow_mange/firebase/storage.dart';
import 'package:cow_mange/url/URL.dart';
import 'package:cow_mange/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class Register_Cow extends StatefulWidget {
  final Employee? emp;
  final Farm? fm;

  const Register_Cow({Key? key, this.emp, this.fm}) : super(key: key);

  @override
  State<Register_Cow> createState() => _Register_CowState();
}

class _Register_CowState extends State<Register_Cow> {
  //map
  List<dynamic>? list;
  Map? mapResponse;

  //List
  List<String> cow = [];
  List<String> bull = [];
  Species? sp = Species();
  Breeder? bd = Breeder();

  Cow? co = Cow();

  //List id
  List<String> listcow = [];
  List<String> listbull = [];

  //Listcaretaker
  List<String> listcaretaker = [];
  List<String> listcaretaker_defult = [""];

  //
  late DateTime _dateTime;
  File? file;
  String id_species = "";
  DateTime? birthday;
  DateTime? registration_date;
  String? gender = "เพศ";
  String? img = "ไม่มีรูปภาพ";
  String? father = "";
  String? mother = "";
  String? status = "";
  String? color = "";
  String? species = "";
  String? country = "";
  String? caretaker = "";

  //class
  Employee employee = Employee();

  //list cow
  List<Cow> list_cow = [];
  List<Farm> listFarm = [];
  List<Employee> listemployee = [];

  //file
  String fileName = "";
  String filePath = "";

  //error text
  String texterror = "";
  String texterror_img = "ไม่มีรูป";
  String error_img = "";
  final _formKey = GlobalKey<FormState>();

  Future registercow(Cow cow) async {
    final JsonRegisterCow = cow.tocow();
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Addcow.toString()),
      body: jsonEncode(JsonRegisterCow),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200 && mapResponse['result'] == '0') {
      return 0;
    } else if (response.statusCode == 200 && mapResponse['result'] != '0') {
      dynamic cow = mapResponse['result'];

      return Cow.fromJson(cow);
    } else {
      throw Exception('Failed to load album');
    }
  }

//query species and add species
  Future queryspecies({country, species_breed}) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_queryspecies.toString()),
      body: jsonEncode({"species_breed": species_breed, "country": country}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      dynamic species = mapResponse!['result'];

      return Species.fromJson(species);
    } else {
      throw Exception('Failed to load album');
    }
  }
////////////////////////////////////////////////

//Add and querybreeder
  Future querybreeder({f, m}) async {
    final response = await http.post(
      Uri.parse(
          url.URL.toString() + url.URL_querybreeder_and_Addbreeder.toString()),
      body: jsonEncode({"f": father, "m": mother}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      dynamic breeder = mapResponse!['result'];

      return Breeder.fromJson(breeder);
    } else {
      throw Exception('Failed to load album');
    }
  }
/////////////////////////////////////////////////////////////

  Future init() async {
    if (widget.emp != null) {
      final co =
          await Cow_data().fetchCow(widget.emp!.farm!.id_Farm.toString());
      final bu =
          await Cow_data().fetchbull(widget.emp!.farm!.id_Farm.toString());

      final employee = await Employee_data().List_employee(widget.emp!.farm!);
      listcaretaker_defult = [];
      listcaretaker_defult
          .add("${widget.emp!.firstname} ${widget.emp!.lastname}");
      listcaretaker = [];
      setState(() {
        listemployee = employee;

        for (int i = 0; i < listemployee.length; i++) {
          listcaretaker
              .add("${listemployee[i].firstname} ${listemployee[i].lastname}");
        }
        cow = co;
        bull = bu;
      });
    } else {
      final co = await Cow_data().fetchCow(widget.fm!.id_Farm.toString());
      final bu = await Cow_data().fetchbull(widget.fm!.id_Farm.toString());

      setState(() {
        cow = co;
        bull = bu;
      });
    }
  }

//clean_number
  Future clean_number() async {
    cow_id.addListener(() {
      setState(() {
        _showClearButton_cow_id = cow_id.text.isNotEmpty;
      });
    });
    namecow.addListener(() {
      setState(() {
        _showClearButton_namecow = namecow.text.isNotEmpty;
      });
    });
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
////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    init();
    clean_number();
  }

  Future chooseImage() async {
    final image =
        await ImagePicker.pickImage(source: ImageSource.gallery) as File?;
    setState(() {
      file = image;
    });
    if (file == null) {
      filePath = "";
    } else {
      filePath = file!.path;
    }

    //fileName = file!.path.split('/').last;
  }

  /// text Controller
  final cow_id = TextEditingController();
  final namecow = TextEditingController();
  final birth = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();
////////////////////////////////////////////

//  button clear
  bool _showClearButton_cow_id = false;
  bool _showClearButton_namecow = false;
  bool _showClearButton_date = false;
  bool _showClearButton_weight = false;
  bool _showClearButton_height = false;
//////////////////////////////////////

  RegExp regExp = RegExp(r'[A-Z]{5}$');

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    registration_date = now;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: cow == null
          ? SingleChildScrollView(
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  child: Column(
                    children: const [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("widget"),
                      ),
                      Center(
                        child: Text(
                          "ลงทะเบียนโค",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.5),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(child: Text("กรอกข้อมูลให้ถูกต้องก่อนลงทะเบียน"))
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.houseUser,
                            color: Color(0XFF397D54),
                            size: 20,
                          )),
                    )),
              ],
            ))
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                          children: const [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text("ลงทะเบียนโค",
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
                              child: Text("กรอกข้อมูลให้ถูกต้องก่อนลงทะเบียน",
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
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: cow_id,
                        decoration: InputDecoration(
                            label: const Text("รหัสประจำตัวโค"),
                            hintStyle: const TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            suffixIcon: _getClearButton_idcow(),
                            icon: const Icon(
                              FontAwesomeIcons.cow,
                              color: Color(0XFF397D54),
                              size: 20,
                            )),
                        validator: Validators.compose([
                          Validators.required_isempty("กรุณากรอก รหัสโค"),
                          Validators.text(
                              "กรอกรหัสโค เป็นภาษาไทย อังกฤษ และตัวเลขเท่านั้น"),
                          Validators.minLength(
                              5, "กรุณากรอกรหัสโคให้มากกว่า 5 ตัว"),
                          Validators.maxLength(
                              10, "กรุณากรอกรหัสโคให้น้อยกว่า 10 ตัว"),
                        ]),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: namecow,
                        decoration: InputDecoration(
                            label: const Text("ชื่อโค"),
                            hintStyle: const TextStyle(color: Colors.black),
                            suffixIcon: _getClearButton_namecow(),
                            border: InputBorder.none,
                            icon: const Icon(
                              FontAwesomeIcons.cow,
                              color: Color(0XFF397D54),
                              size: 20,
                            )),
                        validator: Validators.compose([
                          Validators.required_isempty("กรุณากรอก ชื่อโค"),
                          Validators.text_namecow(
                              "กรอกรหัสโค เป็นภาษาไทย อังกฤษ และตัวเลขเท่านั้น"),
                          Validators.minLength(
                              10, "กรุณากรอกชื่อโคให้มากกว่า 10 ตัว"),
                          Validators.maxLength(
                              50, "กรุณากรอกชื่อโคให้น้อยกว่า 50 ตัว"),
                        ]),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: birth,
                        readOnly: true,
                        decoration: InputDecoration(
                            label: const Text(
                              "เลือกวันเกิดโค",
                              style: TextStyle(color: Colors.black),
                            ),
                            suffixIcon: _getClearButton_date(),
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 219, 41, 41)),
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
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now());

                          if (birthday != null) {
                            DateTime d = DateTime(birthday!.year + 543,
                                birthday!.month, birthday!.day);

                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(d);

                            setState(() {
                              birth.text = formattedDate;
                            });
                          } else {
                            print("กรุณาเลือกวันเกิดโค");
                          }
                        },
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: Column(children: [
                      DropdownButtonFormField(
                        items: ['ผู ้', 'เมีย'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            gender = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: gender,
                          hintStyle: const TextStyle(color: Colors.black),
                          icon: const Icon(
                            FontAwesomeIcons.venusMars,
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
                      width: size.width * 0.9,
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
                            "กรุณากรอก น้ำหนัก(กิโลกรัม)"),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: height,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          LengthLimitingTextInputFormatter(3),
                          FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
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
                            "กรุณากรอก ส่วนสูง(เซนติเมตร)"),
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Center(
                            child: file == null
                                ? Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        Text(img! == texterror_img
                                            ? ""
                                            : texterror_img),
                                        Text(
                                          error_img,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        )
                                      ],
                                    ))
                                : Image.file(file!)),
                        const SizedBox(
                          height: 20,
                        ),
                        OutlinedButton(
                            onPressed: chooseImage,
                            child: const Text(
                              "เลือกรูปภาพโค",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  /* Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.lightGreen.withAlpha(50)),
                        child: TextField(
                          controller: Recording,
                          readOnly: true,
                          decoration: InputDecoration(
                              label: Text(
                                formattedDate,
                                style: TextStyle(color: Colors.black),
                              ),
                              hintText: "Date is not selected",
                              suffixIcon: _getClearButton_Recording(),
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.calendar,
                                color: Color(0XFF397D54),
                                size: 20,
                              )),
                          enabled: false,
                        )),*/
                  /*
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.lightGreen.withAlpha(50)),
                        child: TextField(
                          controller: treatmentHistory,
                          decoration: InputDecoration(
                              label: Text("ประวัติการรักษา"),
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.bookMedical,
                                color: Color(0XFF397D54),
                                size: 20,
                              )),
                        )),*/
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
                                  "ผู้ดูแลโค ",
                                ),
                              ))
                        ],
                      )),
                  widget.emp == null
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.lightGreen.withAlpha(50)),
                          child: Column(children: [
                            DropdownButtonFormField(
                              items: listcaretaker.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  caretaker = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: listcaretaker_defult[0],
                                hintStyle: const TextStyle(color: Colors.black),
                                icon: const Icon(
                                  FontAwesomeIcons.userLarge,
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
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: Column(children: [
                      DropdownButtonFormField(
                          items: ['ดำ', 'แดง'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              color = newValue;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'สี',
                            hintStyle: TextStyle(color: Colors.black),
                            icon: Icon(
                              FontAwesomeIcons.brush,
                              color: Color(0XFF397D54),
                              size: 20,
                            ),
                            border: InputBorder.none,
                          ),
                          validator:
                              Validators.required_isnull("กรุณาเลือกสีของโค")),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: Column(children: [
                      DropdownButtonFormField(
                          items: [
                            'Beefmaster',
                            'brahman',
                            'Brangus',
                            'Gyr',
                            'Wagyu'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              species = newValue;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'สายพันธุ์',
                            hintStyle: TextStyle(color: Colors.black),
                            icon: Icon(
                              FontAwesomeIcons.cow,
                              color: Color(0XFF397D54),
                              size: 20,
                            ),
                            border: InputBorder.none,
                          ),
                          validator: Validators.required_isnull(
                              "กรุณากรอก สายพันธุ์โค")),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: Column(children: [
                      DropdownButtonFormField(
                          items: [
                            'Australia',
                            'New Zealand',
                            'South Africa',
                            'Namibia',
                            'United Kingdom',
                            'Canada',
                            'USA',
                            'Argentina',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              country = newValue;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'ประเทศ',
                            hintStyle: TextStyle(color: Colors.black),
                            icon: Icon(
                              FontAwesomeIcons.flag,
                              color: Color(0XFF397D54),
                              size: 20,
                            ),
                            border: InputBorder.none,
                          ),
                          validator:
                              Validators.required_isnull("กรุณาเลือกประเทศโค")),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: Column(children: [
                      DropdownButtonFormField(
                          isExpanded: true,
                          items: cow.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              mother = newValue;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'แม่พันธุ์',
                            hintStyle: TextStyle(color: Colors.black),
                            icon: Icon(
                              FontAwesomeIcons.cow,
                              color: Color(0XFF397D54),
                              size: 20,
                            ),
                            border: InputBorder.none,
                          ),
                          validator: Validators.required_isnull(
                              "กรุณาเลือกแม่พันธุ์")),
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
                                  "พ่อพันธุ์ ",
                                ),
                              ))
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: Column(children: [
                      DropdownButtonFormField(
                          items: bull.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValueSelected) {
                            setState(() {
                              father = newValueSelected;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'พ่อพันธุ์',
                            hintStyle: TextStyle(color: Colors.black),
                            icon: Icon(
                              FontAwesomeIcons.cow,
                              color: Color(0XFF397D54),
                              size: 20,
                            ),
                            border: InputBorder.none,
                          ),
                          validator: Validators.required_isnull(
                              "กรุณาเลือกพ่อพันธุ์โค")),
                    ]),
                  ),
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
                        if (file == null) {
                          setState(() {
                            texterror_img = "";
                            error_img = "กรุณากรอกรูปโค";
                          });
                        } else {
                          setState(() {
                            texterror_img = "ไม่มีรูป";
                            error_img = "";
                          });
                        }
                      }
                      if (error_img == "" && validate != false) {
                        setState(() {
                          texterror = "";
                        });
                        var imageCow = "";
                        if (file == null) {
                        } else {
                          imageCow = await Storage().uploadFile(file, null);
                        }
                        setState(() {
                          co?.species = Species.Newid_Specie2(
                              id_species: id_species,
                              species_breed: species,
                              country: country);

                          co?.species =
                              Species.Newid_Species(id_species: species);
                          co?.cow_id = cow_id.text;
                          co?.namecow = namecow.text;
                          co?.birthday = birthday;

                          if (gender == "ผู ้") {
                            gender = "ผู้";
                            co?.gender = gender;
                          } else {
                            co?.gender = gender;
                          }
                          if (imageCow == null) {
                            co?.picture = "-";
                          } else {
                            co?.picture = imageCow;
                          }

                          co?.weight = double.parse(weight.text);
                          co?.height = double.parse(height.text);
                          co?.registration_date = registration_date;
                          co?.caretaker = caretaker;
                          co?.status = "มีชีวิต";
                          co?.color = color;
                          co?.species!.country = country;
                          co?.species!.species_breed = species;

                          co?.farm = Farm.Newid_farm(
                              id_Farm: widget.emp!.farm!.id_Farm);
                        });
                        final querysp = await queryspecies(
                            species_breed: species, country: country);
                        setState(() {
                          sp = querysp;
                          co?.species = Species.Newid_Species(
                              id_species: sp!.id_species.toString());
                        });

                        final querybd =
                            await querybreeder(f: father, m: mother);
                        setState(() {
                          bd = querybd;
                          co?.breeder = Breeder.New_idBreeder(
                              idBreeder: bd!.idBreeder.toString());
                        });
                        final cow2 = await registercow(co!);
                        final lc = await Cow_data().listMaincow(widget.emp!);

                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: ((context) {
                          return MainpageEmployee(
                            emp: widget.emp,
                            cow: lc,
                          );
                        })));
                      } else {
                        setState(() {
                          texterror = "กรุณากรอกข้อมูลให้ครบถ้วน";
                        });
                      }

                      /*
                        storage
                            .uploadimage(fileName, filePath)
                            .then(((value) => print("done")));*/
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color.fromARGB(255, 1, 35, 3)
                              .withAlpha(50)),
                      alignment: Alignment.center,
                      child: const Text('ลงทะเบียนโค',
                          style: TextStyle(
                              color: Color(0xff235d3a), fontSize: 18)),
                    ),
                  ),
                ],
              )),
            ),
    );
  }

  Widget? _getClearButton_idcow() {
    if (!_showClearButton_cow_id) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          cow_id.clear();
        });
  }

  Widget? _getClearButton_namecow() {
    if (!_showClearButton_namecow) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          namecow.clear();
        });
  }

  Widget? _getClearButton_date() {
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
