import 'dart:convert';
import 'dart:io';

import 'package:cow_mange/DetailCow.dart';
import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/Breeder.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Species.dart';
import 'package:cow_mange/url/URL.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as Img;
import 'package:intl/intl.dart';

import 'validators.dart';

class EditCow extends StatefulWidget {
  final Cow cow;
  final Employee? emp;
  final Farm? fm;
  const EditCow({Key? key, required this.cow, this.emp, this.fm})
      : super(key: key);

  @override
  State<EditCow> createState() => _EditCowState();
}

class _EditCowState extends State<EditCow> {
  Cow? cow;
  bool isMount = true;

  //  button clear
  bool _showClearButton_econ_cow_id = false;
  bool _showClearButton_econ_cowname = false;
  bool _showClearButton_height = false;
  bool _showClearButton_date = false;
  bool _showClearButton_weight = false;

// controller
  final econ_cowid = TextEditingController();
  final econ_cowname = TextEditingController();
  TextEditingController econ_birth = TextEditingController();
  final econ_cow_weight = TextEditingController();
  final econ_cow_height = TextEditingController();

// date
  DateTime? birthday;

//fire
  File? file;

  //file
  String fileName = "";
  String filePath = "";

  //error text
  String texterror = "";
  String texterror_img = "ไม่มีรูป";
  String error_img = "";
  String? img = "ไม่มีรูปภาพ";

// Listdropdown
  List<String> gender = [];
  List<String> status = [];
  List<String> color = [];
  List<String> species = [];
  List<String> country = [];
  List<String> cow_bull = [];
  List<String> cow_cow = [];

//List id
  List<String> listcow = [];
  List<String> listbull = [];

//Listcaretaker
  List<String> listcaretaker = [];
  List<String> listcaretaker_defult = [""];

  List<Employee> listemployee = [];

//text
  String textgender = "";
  String textstatus = "";
  String textcolor = "";
  String textspecies = "";
  String textcountry = "";
  String textcow_bull = "";
  String textcow_cow = "";
  String? caretaker = "";

//map
  List<dynamic>? list;
  Map? mapResponse;

//cow
  Cow? co = Cow();
  Farm? fm = Farm();
  Species? sp = Species();
  Breeder? bd = Breeder();
  UploadTask? task;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setState(() {
      cow = widget.cow;
      fm = widget.fm;
    });

    init();
    clean_number();
  }

  List<PlatformFile>? _files;
  Future uploadfile() async {
    var url_ = (Uri.parse(url.URL + url.URL_cow_uploadimage));
    var request = http.MultipartRequest('Post', url_);

    final fileName = File(pickedFile!.path!);

    final fileExtension = fileName.path.split(".").last;
    final fileName_id_cow = co!.cow_id!;

    int sizeInBytes = fileName.lengthSync();
    Img.Image? image_temp = Img.decodeImage(fileName.readAsBytesSync());
    Img.Image? resized_img =
        Img.copyResize(image_temp!, width: 300, height: 300);

    request.files.add(http.MultipartFile.fromBytes(
        'file', Img.encodeJpg(resized_img),
        filename: pickedFile!.path.toString(),
        contentType: MediaType.parse('image/jpeg')));

    request.files
        .add(await http.MultipartFile.fromString('cow', fileName_id_cow));
    var response = await request.send();

    final res = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print('Uploaded ...');
      return fileName_id_cow + "." + fileExtension;
    } else {
      print('Something went wrong');
    }
  }

  Future fetchCow(String idFarm, String cowId) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Listbreedercow.toString()),
      body: jsonEncode({"Farm_id_Farm": idFarm, "cow_id": cowId}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    List? list;

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      mapResponse = json.decode(response.body);

      list = map['result'];
      listcow = [];
      listcow.add("-");
      for (dynamic l in list!) {
        listcow.add(l['cow_id']);
      }
      return listcow;
    } else {
      throw Exception('Failed to load album');
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

  Future fetchbull(idfarm, cowid) async {
    final jsoneditCow = cow!.tolistcow_edit();
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_edit_Listbreederbull.toString()),
      body: jsonEncode(jsoneditCow),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    List? list;

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      mapResponse = json.decode(response.body);
      list = map['result'];
      listbull = [];
      listbull.add("-");
      for (dynamic l in list!) {
        listbull.add(l['cow_id']);
      }
      return listbull;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future init() async {
    final co =
        await fetchCow(cow!.farm!.id_Farm.toString(), cow!.cow_id.toString());
    final bull =
        await fetchbull(cow!.farm!.id_Farm.toString(), cow!.cow_id.toString());
    setState(() {
      listcow = co;
      listbull = bull;
    });

    if (widget.emp != null) {
      final employee = await Employee_data().List_employee(widget.emp!.farm!);
      setState(() {
        listemployee = [];
        listemployee = employee;

        //set_caretaker
        listcaretaker = [];
        for (int i = 0; i < listemployee.length; i++) {
          listcaretaker
              .add("${listemployee[i].firstname} ${listemployee[i].lastname}");
        }
        //set_defultcaretaker
        listcaretaker_defult = [];
        listcaretaker_defult
            .add("${widget.emp!.firstname} ${widget.emp!.lastname}");
        //cow_id
        econ_cowid.text = cow!.cow_id.toString();
        //cow_name
        econ_cowname.text = cow!.namecow.toString();
        // birthday
        var outputFormat = DateFormat('dd/MM/yyyy');
        DateTime d = DateTime(cow!.birthday!.year + 543, cow!.birthday!.month,
            cow!.birthday!.day);
        var Date = "";
        econ_birth = TextEditingController()
          ..text = Date = outputFormat.format(d);
        //gender
        textgender = cow!.gender.toString();
        gender = ["เมีย", "ผู ้"];

        birthday = cow!.birthday;
        //weight
        econ_cow_weight.text = cow!.weight.toString();
        //height
        econ_cow_height.text = cow!.height.toString();
        //status
        textstatus = cow!.status.toString();
        status = ["เสียชีวิต", "มีชีวิต"];
        //colors
        textcolor = cow!.color.toString();
        color = ["ดำ", "แดง"];

        textspecies = cow!.species!.species_breed.toString();
        species = ["Beefmaster", "brahman", "Brangus", "Gyr", "Wagyu"];
        textcountry = cow!.species!.country.toString();
        country = [
          "Australia",
          "New Zealand",
          "South Africa",
          "Namibia",
          "United Kingdom",
          "Canada",
          "USA",
          "Argentina"
        ];

        // breeder_bull
        textcow_bull = cow!.breeder!.father.toString();

        //breeder_cow
        textcow_cow = cow!.breeder!.mother.toString();
      });
    } else {
      final farm = await Employee_data().List_employee(fm!);
      setState(() {
        listemployee = [];
        listemployee = farm;

        //set_caretaker
        listcaretaker = [];
        for (int i = 0; i < listemployee.length; i++) {
          listcaretaker
              .add("${listemployee[i].firstname} ${listemployee[i].lastname}");
        }
        //set_defultcaretaker
        listcaretaker_defult = [];
        listcaretaker_defult.add(cow!.caretaker.toString());
        //cow_id

        econ_cowid.text = cow!.cow_id.toString();
        //cow_name
        econ_cowname.text = cow!.namecow.toString();
        // birthday
        var outputFormat = DateFormat('dd/MM/yyyy');
        DateTime d = DateTime(cow!.birthday!.year + 543, cow!.birthday!.month,
            cow!.birthday!.day);
        var Date = "";
        econ_birth = TextEditingController()
          ..text = Date = outputFormat.format(d);
        //gender
        textgender = cow!.gender.toString();
        gender = ["เมีย", "ผู ้"];

        birthday = cow!.birthday;

        //weight
        econ_cow_weight.text = cow!.weight.toString();
        //height
        econ_cow_height.text = cow!.height.toString();
        //status
        textstatus = cow!.status.toString();
        status = ["เสียชีวิต", "มีชีวิต"];
        //colors
        textcolor = cow!.color.toString();
        color = ["ดำ", "แดง"];

        textspecies = cow!.species!.species_breed.toString();
        species = ["Beefmaster", "brahman", "Brangus", "Gyr", "Wagyu"];
        textcountry = cow!.species!.country.toString();
        country = [
          "Australia",
          "New Zealand",
          "South Africa",
          "Namibia",
          "United Kingdom",
          "Canada",
          "USA",
          "Argentina"
        ];

        // breeder_bull
        textcow_bull = cow!.breeder!.father.toString();

        //breeder_cow
        textcow_cow = cow!.breeder!.mother.toString();
      });
    }
  }

  Future clean_number() async {
    econ_cowid.addListener(() {
      setState(() {
        _showClearButton_econ_cow_id = econ_cowid.text.isNotEmpty;
      });
    });
    econ_cowname.addListener(() {
      setState(() {
        _showClearButton_econ_cowname = econ_cowname.text.isNotEmpty;
      });
    });
    econ_birth.addListener(() {
      setState(() {
        _showClearButton_date = econ_birth.text.isNotEmpty;
      });
    });

    econ_cow_weight.addListener(() {
      setState(() {
        _showClearButton_weight = econ_cow_weight.text.isNotEmpty;
      });
    });
    econ_cow_height.addListener(() {
      setState(() {
        _showClearButton_height = econ_cow_height.text.isNotEmpty;
      });
    });
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

  Future querybreeder({father, mother}) async {
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

  Future edit_cow({required Cow cow}) async {
    final jsonreditCow = cow.tocow();

    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Editcow.toString()),
      body: jsonEncode(jsonreditCow),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic cow = mapResponse['result'];

      return Cow.fromJson(cow);
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: cow == null
          ? null
          : Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
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
                            children: const [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text("แก้ไขข้อมูลโค",
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
                                    "กรอกข้อมูลให้ถูกต้องก่อนแก้ไขข้อมูล",
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
                    widget.emp == null
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.lightGreen.withAlpha(50)),
                            child: TextFormField(
                                controller: econ_cowid,
                                decoration: InputDecoration(
                                    label: const Text("หมายเลขประจำตัวโค"),
                                    suffixIcon: _getClearButton_econ_cowid(),
                                    hintStyle:
                                        const TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                    icon: const Icon(
                                      FontAwesomeIcons.cow,
                                      color: Color(0XFF397D54),
                                      size: 20,
                                    )),
                                validator: Validators.compose([
                                  Validators.required_isempty(
                                      "กรุณากรอก รหัสโค"),
                                  Validators.text(
                                      "กรอกรหัสโค เป็นภาษาไทย อังกฤษ และตัวเลขเท่านั้น"),
                                  Validators.minLength(
                                      5, "กรุณากรอกรหัสโคให้มากกว่า 5 ตัว"),
                                  Validators.maxLength(
                                      10, "กรุณากรอกรหัสโคให้น้อยกว่า 10 ตัว"),
                                ])),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.lightGreen.withAlpha(50)),
                            child: TextFormField(
                                controller: econ_cowid,
                                decoration: InputDecoration(
                                    label: const Text("หมายเลขประจำตัวโค"),
                                    suffixIcon: _getClearButton_econ_cowid(),
                                    hintStyle:
                                        const TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                    icon: const Icon(
                                      FontAwesomeIcons.cow,
                                      color: Color(0XFF397D54),
                                      size: 20,
                                    )),
                                validator: Validators.compose([
                                  Validators.required_isempty(
                                      "กรุณากรอก รหัสโค"),
                                  Validators.text(
                                      "กรอกรหัสโค เป็นภาษาไทย อังกฤษ และตัวเลขเท่านั้น"),
                                  Validators.minLength(
                                      5, "กรุณากรอกรหัสโคให้มากกว่า 5 ตัว"),
                                  Validators.maxLength(
                                      10, "กรุณากรอกรหัสโคให้น้อยกว่า 10 ตัว"),
                                ])),
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
                          controller: econ_cowname,
                          decoration: InputDecoration(
                              label: const Text("ชื่อโค"),
                              suffixIcon: _getClearButton_econ_cow_name(),
                              hintStyle: const TextStyle(color: Colors.black),
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
                                5, "กรุณากรอกรหัสโคให้มากกว่า 5 ตัว"),
                            Validators.maxLength(
                                100, "กรุณากรอกรหัสโคให้น้อยกว่า 10 ตัว"),
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
                          controller: econ_birth,
                          readOnly: true,
                          validator: Validators.required_isempty(
                              "กรุณาเลือกวันเกิดโค"),
                          decoration: InputDecoration(
                              label: const Text(
                                "เลือกวันเกิดโค",
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
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now());

                            if (birthday != null) {
                              DateTime d = DateTime(birthday!.year + 543,
                                  birthday!.month, birthday!.day);

                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(d);
                              DateTime date =
                                  DateTime(d.year - 543, d.month, d.day);

                              setState(() {
                                birthday = date;
                                econ_birth.text = formattedDate;
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
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: Column(children: [
                        DropdownButtonFormField(
                          items: gender.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              textgender = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: textgender,
                            hintStyle: const TextStyle(color: Colors.black),
                            icon: const Icon(
                              FontAwesomeIcons.mars,
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
                          controller: econ_cow_weight,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]')),
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
                            controller: econ_cow_height,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]')),
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
                                "กรุณากรอก ส่วนสูง(เซนติเมตร)"))),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 20),
                          Center(
                            child: pickedFile == null
                                ? Image.network(
                                    url.URL_IMAGE +
                                        widget.cow.picture.toString(),
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(File(pickedFile!.path!)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          OutlinedButton(
                              onPressed: chooseImage,
                              child: Text(
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
                        ? Container(
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
                                  hintStyle:
                                      const TextStyle(color: Colors.black),
                                  icon: const Icon(
                                    FontAwesomeIcons.userLarge,
                                    color: Color(0XFF397D54),
                                    size: 20,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ]),
                          )
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
                                  hintStyle:
                                      const TextStyle(color: Colors.black),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: Column(children: [
                        DropdownButtonFormField(
                          items: status.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              textstatus = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: textstatus,
                            hintStyle: const TextStyle(color: Colors.black),
                            icon: const Icon(
                              FontAwesomeIcons.gratipay,
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
                      child: Column(children: [
                        DropdownButtonFormField(
                          items: color.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              textcolor = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: textcolor,
                            hintStyle: const TextStyle(color: Colors.black),
                            icon: const Icon(
                              FontAwesomeIcons.brush,
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
                      child: Column(children: [
                        DropdownButtonFormField(
                          items: species.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              textspecies = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: textspecies,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: Column(children: [
                        DropdownButtonFormField(
                          items: country.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              textcountry = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: textcountry,
                            hintStyle: const TextStyle(color: Colors.black),
                            icon: const Icon(
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
                        margin: const EdgeInsets.symmetric(horizontal: 60),
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
                                    "หมายเลขประจำตัวแม่พันธุ์ ",
                                  ),
                                ))
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: Column(children: [
                        DropdownButtonFormField(
                          isExpanded: true,
                          items: listcow.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              textcow_cow = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: textcow_cow,
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
                        margin: const EdgeInsets.symmetric(horizontal: 60),
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
                                    "หมายเลขประจำตัวพ่อพันธุ์ ",
                                  ),
                                ))
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: Column(children: [
                        DropdownButtonFormField(
                          items: listbull.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValueSelected) {
                            setState(() {
                              textcow_bull = newValueSelected!;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: textcow_bull,
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
                          //error
                          setState(() {
                            texterror = "";
                          });

                          //cow_id
                          co!.cow_id = econ_cowid.text;
                          //cow_name
                          co!.namecow = econ_cowname.text;
                          //birthday
                          co!.birthday = birthday;
                          //gender
                          if (textgender == "ผู ้") {
                            textgender = "ผู้";
                            co!.gender = textgender;
                          } else {
                            co!.gender = textgender;
                          }

                          if (pickedFile == null) {
                            co!.picture = widget.cow.picture.toString();
                          } else {
                            co?.picture = await uploadfile();
                          }

                          co?.registration_date = cow!.registration_date;
                          co!.weight = double.parse(econ_cow_weight.text);
                          co!.height = double.parse(econ_cow_height.text);
                          if (caretaker == "") {
                            co?.caretaker = listcaretaker_defult[0];
                          } else {
                            co?.caretaker = caretaker;
                          }

                          co!.status = textstatus;
                          co!.color = textcolor;

                          co?.farm =
                              Farm.Newid_farm(id_Farm: cow!.farm!.id_Farm);

                          final queryIdSpecies = await queryspecies(
                              species_breed: textspecies, country: textcountry);

                          co?.species = Species.Newid_Species(
                              id_species:
                                  queryIdSpecies!.id_species.toString());

                          final querybd = await querybreeder(
                              father: textcow_bull, mother: textcow_cow);
                          setState(() {
                            bd = querybd;
                            co?.breeder =
                                Breeder.New_idBreeder(idBreeder: bd!.idBreeder);
                          });

                          final editcow = await edit_cow(cow: co!);

                          if (widget.emp != null) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: ((context) {
                              return DetailCow(
                                cow: editcow,
                                emp: widget.emp,
                              );
                            })));
                          } else {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: ((context) {
                              return DetailCow(
                                cow: editcow,
                                fm: widget.fm,
                              );
                            })));
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color.fromARGB(255, 34, 120, 37)
                                .withAlpha(50)),
                        alignment: Alignment.center,
                        child: const Text('แก้ไขข้อมูลโค',
                            style: TextStyle(
                                color: Color(0xff235d3a), fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget? _getClearButton_econ_cowid() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_econ_cow_id) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Color.fromARGB(255, 236, 16, 16),
        ),
        onTap: () {
          econ_cowid.clear();
        });
  }

  Widget? _getClearButton_econ_cow_name() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_econ_cowname) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Color.fromARGB(255, 236, 16, 16),
        ),
        onTap: () {
          econ_cowname.clear();
        });
  }

  Widget? _getClearButton_date() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_date) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Color.fromARGB(255, 236, 16, 16),
        ),
        onTap: () {
          econ_birth.clear();
        });
  }

  Widget? _getClearButton_weight() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_weight) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Color.fromARGB(255, 236, 16, 16),
        ),
        onTap: () {
          econ_cow_weight.clear();
        });
  }

  Widget? _getClearButton_height() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_height) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Color.fromARGB(255, 236, 16, 16),
        ),
        onTap: () {
          econ_cow_height.clear();
        });
  }
}
