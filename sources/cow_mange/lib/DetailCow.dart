import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/Mainpage.dart';
import 'package:cow_mange/class/Cow_has_Hybridization.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Feeding.dart';
import 'package:cow_mange/class/Hybridization.dart';
import 'package:cow_mange/class/Progress.dart';
import 'package:cow_mange/class/vaccination.dart';
import 'package:cow_mange/firebase/storage.dart';
import 'package:cow_mange/mainfarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/url/URL.dart';
import 'package:intl/intl.dart';

class DetailCow extends StatefulWidget {
  final Cow cow;
  final Employee? emp;
  final Farm? fm;

  const DetailCow({Key? key, required this.cow, this.emp, this.fm})
      : super(key: key);

  @override
  State<DetailCow> createState() => _DetailCowState();
}

class _DetailCowState extends State<DetailCow> {
  List tabs = [
    "รายละเอียด",
    "ข้อมูลอื่นๆ",
  ];
  int selectIndex = 0;

  Cow cow = Cow();
  Hybridization hybridization = Hybridization();

  late List<dynamic> list;
  Map? mapResponse;
  List<Cow> listcow = [];
  Cow breeder_cow = Cow();
  Cow breeder_bull = Cow();
  Hybridization hy = Hybridization();
  List<Cow> gender_co = [];
  String cow_id = "";

  //List
  List<Progress> Listprogress = [];
  List<Feeding> ListFeeding = [];
  List<Vaccination> ListVaccination = [];
  List<Cow_has_Hybridization> List_Cow_has_Hybridization = [];

  Future fetchnewcow(Cow cow) async {
    final Cowbreeder = cow.tobreeder();

    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Getcow.toString()),
      body: jsonEncode(Cowbreeder),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      dynamic breeder = mapResponse!['result'];

      return Cow.fromJson(breeder);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future init() async {
    final breederCow = await Breeder_data()
        .fetch_Cow_cow(widget.cow.breeder!.mother.toString());
    final breederBull = await Breeder_data()
        .fetch_Cow_bull(widget.cow.breeder!.father.toString());
    if (widget.emp == null) {
      final co = await Cow_data().listMaincow_farm(widget.fm!);

      setState(() {
        listcow = co;
      });
    } else {
      final lc = await Cow_data().listMaincow(widget.emp!);
      setState(() {
        listcow = lc;
      });
    }

    final listPg =
        await Progress_data().listMainprogress(widget.cow.cow_id.toString());
    final listFd =
        await Feeding_data().listMainFedding_DESC(widget.cow.cow_id.toString());
    final listVc = await Vaccination_data()
        .listMainVaccination(widget.cow.cow_id.toString());
    final list_c__list_hz = await Hybridization_data()
        .listMainCow_has_Hybridization(widget.cow.cow_id.toString());

    final co = await Cow_data().mating_pair(widget.cow.cow_id.toString());
    gender_co = co;

    setState(() {
      if (breederCow == null) {
        breeder_cow = breederCow;
      } else {}

      breeder_bull = breederBull;
      Listprogress = listPg;
      ListFeeding = listFd;
      ListVaccination = listVc;
      List_Cow_has_Hybridization = list_c__list_hz;
    });
  }

  String? data_cow = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: listcow == null
            ? SingleChildScrollView()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    image_cow(widget.cow),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      decoration: const BoxDecoration(
                          color: Color(0XFF397D54),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          )),
                      child: Column(
                        children: [
                          Container(
                            height: 4.0,
                            width: 28.0,
                            margin: const EdgeInsets.only(bottom: 32.0),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 4, 16, 6)),
                          ),
                          Container(
                            child: Text("รหัสโค : ${widget.cow.cow_id}",
                                style: const TextStyle(
                                    fontSize: 28.0,
                                    color: Color.fromARGB(255, 253, 253, 253),
                                    fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: (List.generate(
                                  12,
                                  (index) => Container(
                                    height: 2.0,
                                    width: 2.0,
                                    margin: const EdgeInsets.only(bottom: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white54,
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                  ),
                                )),
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.cow,
                                    size: 55,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "พันธุ์ ",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    widget.cow.species!.species_breed
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color:
                                            Color.fromARGB(255, 255, 253, 253),
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              Column(
                                children: (List.generate(
                                  12,
                                  (index) => Container(
                                    height: 2.0,
                                    width: 2.0,
                                    margin: const EdgeInsets.only(bottom: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white54,
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                  ),
                                )),
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.userLarge,
                                    color: Colors.black,
                                    size: 55,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "ผู้ดูแล",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    widget.cow.caretaker.toString(),
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color:
                                            Color.fromARGB(255, 255, 253, 253),
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 32.0,
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(36.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                tabs.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectIndex = index;
                                    });
                                  },
                                  child: Container(
                                    height: 48,
                                    width: 160,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: selectIndex == index
                                            ? const Color.fromARGB(
                                                255, 29, 103, 31)
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(28.0)),
                                    child: Text(
                                      tabs[index],
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: selectIndex == index
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          selectIndex == 0
                              ? Container(
                                  height: 490,
                                  width: 370,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 16),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 212, 248, 226),
                                      borderRadius:
                                          BorderRadius.circular(24.0)),
                                  child: SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              child: Text(
                                                  "หมายเลขประจำตัวโค : ${widget.cow.cow_id}",
                                                  style: const TextStyle(
                                                      fontSize: 20.0,
                                                      color: Color.fromARGB(
                                                          255, 12, 2, 2),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            child: Text(
                                              "ชื่อโค : ${widget.cow.namecow}",
                                              style: const TextStyle(
                                                  fontSize: 20.0,
                                                  color: Color.fromARGB(
                                                      255, 12, 2, 2),
                                                  fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "ผู้พัฒนาพันธุ์ : ${widget.cow.farm!.name_Farm}",
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    color: Color.fromARGB(
                                                        255, 12, 2, 2),
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "พันธุ์ : ${widget.cow.species!.species_breed}",
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    color: Color.fromARGB(
                                                        255, 12, 2, 2),
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                    "ประเทศ : ${widget.cow.species!.country}",
                                                    style: const TextStyle(
                                                        fontSize: 20.0,
                                                        color: Color.fromARGB(
                                                            255, 12, 2, 2),
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                Icon(Icons.flag),
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "ผู้ดูแล : ${widget.cow.caretaker}",
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    color: Color.fromARGB(
                                                        255, 12, 2, 2),
                                                    fontWeight:
                                                        FontWeight.w600),
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "เลขประจำตัวพ่อ",
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Color.fromARGB(
                                                      255, 12, 2, 2),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Expanded(
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: Column(children: [
                                                      InkWell(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Container(
                                                                child: Text(
                                                                    widget.cow.breeder!.father == "-"
                                                                        ? "ไม่พบข้อมูล"
                                                                        : widget
                                                                            .cow
                                                                            .breeder!
                                                                            .father
                                                                            .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20.0,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            4,
                                                                            192,
                                                                            10),
                                                                        fontWeight: FontWeight
                                                                            .w600),
                                                                    overflow: TextOverflow
                                                                        .ellipsis))),
                                                        onTap: () async {
                                                          if (widget
                                                                  .cow
                                                                  .breeder!
                                                                  .father
                                                                  .toString() ==
                                                              "-") {
                                                            return;
                                                          } else {
                                                            setState(() {
                                                              cow_id = widget
                                                                  .cow
                                                                  .breeder!
                                                                  .father
                                                                  .toString();
                                                            });
                                                            final newbreederBull =
                                                                await Breeder_data()
                                                                    .fetch_Cow_bull(
                                                                        cow_id);
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        ((context) {
                                                              return DetailCow(
                                                                  cow:
                                                                      newbreederBull,
                                                                  emp: widget
                                                                      .emp);
                                                            })));
                                                          }
                                                        },
                                                      )
                                                    ])))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "เลขประจำตัวแม่",
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Color.fromARGB(
                                                      255, 12, 2, 2),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Expanded(
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: Column(children: [
                                                      InkWell(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Container(
                                                                child: Text(
                                                                    widget.cow.breeder!.mother == "-"
                                                                        ? "ไม่พบข้อมูล"
                                                                        : widget
                                                                            .cow
                                                                            .breeder!
                                                                            .mother
                                                                            .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20.0,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            4,
                                                                            192,
                                                                            10),
                                                                        fontWeight: FontWeight
                                                                            .w600),
                                                                    overflow: TextOverflow
                                                                        .ellipsis))),
                                                        onTap: () async {
                                                          if (widget
                                                                  .cow
                                                                  .breeder!
                                                                  .mother
                                                                  .toString() ==
                                                              "-") {
                                                            return;
                                                          } else {
                                                            setState(() {
                                                              cow_id = widget
                                                                  .cow
                                                                  .breeder!
                                                                  .mother
                                                                  .toString();
                                                            });
                                                            final newbreederCow =
                                                                await Breeder_data()
                                                                    .fetch_Cow_cow(
                                                                        cow_id);
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        ((context) {
                                                              return DetailCow(
                                                                  cow:
                                                                      newbreederCow,
                                                                  emp: widget
                                                                      .emp);
                                                            })));
                                                          }
                                                        },
                                                      )
                                                    ])))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "เพศ : ${widget.cow.gender} ",
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    color: Color.fromARGB(
                                                        255, 12, 2, 2),
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "น้ำหนักเริ่มต้น : ${widget.cow.weight} กิโลกรัม ",
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    color: Color.fromARGB(
                                                        255, 12, 2, 2),
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        if (Listprogress.isNotEmpty)
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  "น้ำหนักล่าสุด  : " +
                                                      Listprogress.last.weight
                                                          .toString() +
                                                      " กิโลกรัม ",
                                                  style: const TextStyle(
                                                      fontSize: 20.0,
                                                      color: Color.fromARGB(
                                                          255, 12, 2, 2),
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "ส่วนสูง : ${widget.cow.height} เซนติเมตร",
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    color: Color.fromARGB(
                                                        255, 12, 2, 2),
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        _birthdayCow(widget.cow),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "สถานะ : ${widget.cow.status}",
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    color: Color.fromARGB(
                                                        255, 12, 2, 2),
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "สี : ${widget.cow.color}",
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    color: Color.fromARGB(
                                                        255, 12, 2, 2),
                                                    fontWeight:
                                                        FontWeight.w600))),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      width: size.width * 0.93,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: const Color.fromARGB(
                                                  255, 254, 255, 253)
                                              .withAlpha(50)),
                                      child: Column(children: [
                                        DropdownButtonFormField(
                                          items: [
                                            'พัฒนาการโค',
                                            'ให้อาหารโค',
                                            'การฉีดวัคซีน',
                                            'การผสมพันธุ์โค'
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              data_cow = newValue;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'ข้อมูลโค',
                                            hintStyle:
                                                TextStyle(color: Colors.black),
                                            icon: Icon(
                                              FontAwesomeIcons.cow,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              size: 20,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ]),
                                    ),
                                    TextTest(data_cow!),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }

  Widget TextTest(String text) {
    if (text == 'พัฒนาการโค') {
      return Container(
        height: 470,
        width: 500,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Card(
            color: const Color(0XFF397D54),
            child: Listprogress.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: Listprogress.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime d = DateTime(
                          Listprogress[index].progress_date!.year + 543,
                          Listprogress[index].progress_date!.month,
                          Listprogress[index].progress_date!.day);

                      String formattedDate = DateFormat('dd-MM-yyyy').format(d);
                      return Column(
                        children: [
                          Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    // An action can be bigger than the others.
                                    flex: 1,
                                    onPressed: (BuildContext context) {
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CupertinoAlertDialog(
                                          title: Text(
                                              'ลบข้อมูลการให้อาหารโค\nวันที่ ${formattedDate} \nรหัสโค : ${Listprogress[index].cow!.cow_id}'),
                                          content: const Text(
                                              'เช็คข้อมูลการลบข้อมูลทุกครั้ง'),
                                          actions: <CupertinoDialogAction>[
                                            CupertinoDialogAction(
                                              isDefaultAction: true,
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No'),
                                            ),
                                            CupertinoDialogAction(
                                              isDestructiveAction: true,
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                final progress =
                                                    await Progress_data()
                                                        .DeleteProgress(
                                                            Listprogress[index]
                                                                .id_progress!
                                                                .toString());
                                                if (progress != 0) {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              super.widget));
                                                }
                                              },
                                              child: const Text('Yes'),
                                            )
                                          ],
                                        ),
                                      );
                                    },

                                    backgroundColor:
                                        const Color.fromARGB(255, 192, 73, 67),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: "ลบข้อมูลการพัฒนาโค",
                                  ),
                                ]),
                            child: Card(
                              color: (Colors.green),
                              child: ListTile(
                                  tileColor: Colors.white54,
                                  leading: _buildLeadingTile(widget.cow),
                                  title: Progress_date(Listprogress[index]),
                                  subtitle:
                                      _subtitleprogress(Listprogress[index])
                                  // isThreeLine: true,
                                  ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : Column(
                    children: const [
                      Text(
                        'ยังไม่มีรายการที่เลือก',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
      );
    } else if (text == "ให้อาหารโค") {
      return Container(
        height: 470,
        width: 500,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Card(
            color: const Color(0XFF397D54),
            child: ListFeeding.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: ListFeeding.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime d = DateTime(
                          ListFeeding[index].record_date!.year + 543,
                          ListFeeding[index].record_date!.month,
                          ListFeeding[index].record_date!.day);

                      String formattedDate = DateFormat('dd-MM-yyyy').format(d);
                      return Column(
                        children: [
                          Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    // An action can be bigger than the others.
                                    flex: 1,
                                    onPressed: (BuildContext context) {
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CupertinoAlertDialog(
                                          title: Text(
                                              'ลบข้อมูลการให้อาหารโค\nวันที่:${formattedDate}\n ช่วงเวลา: ${ListFeeding[index].time} \nรหัสโค : ${ListFeeding[index].cow!.cow_id}'),
                                          content: const Text(
                                              'เช็คข้อมูลการลบข้อมูลทุกครั้ง'),
                                          actions: <CupertinoDialogAction>[
                                            CupertinoDialogAction(
                                              isDefaultAction: true,
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No'),
                                            ),
                                            CupertinoDialogAction(
                                              isDestructiveAction: true,
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                final feeding =
                                                    await Feeding_data()
                                                        .DeleteFedding(
                                                            ListFeeding[index]
                                                                .id_Feeding!
                                                                .toString());
                                                if (feeding != 0) {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              super.widget));
                                                }
                                              },
                                              child: const Text('Yes'),
                                            )
                                          ],
                                        ),
                                      );
                                    },

                                    backgroundColor:
                                        const Color.fromARGB(255, 192, 73, 67),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: "ลบข้อมูลการให้อาหารโค",
                                  ),
                                ]),
                            child: Card(
                              color: (Colors.green),
                              child: ListTile(
                                  tileColor: Colors.white54,
                                  leading:
                                      _buildLeadingTile_feeding(widget.cow),
                                  onTap: (() {}),
                                  // title: Progress_date(widget.cow),
                                  subtitle: _subtitlefeeding(ListFeeding[index])
                                  // isThreeLine: true,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    },
                  )
                : Column(
                    children: const [
                      Text(
                        'ยังไม่มีรายการที่เลือก',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
      );
    } else if (text == "การฉีดวัคซีน") {
      return Container(
        height: 470,
        width: 500,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Card(
            color: const Color(0XFF397D54),
            child: ListVaccination.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: ListVaccination.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime d = DateTime(
                          ListVaccination[index].dateVaccination!.year + 543,
                          ListVaccination[index].dateVaccination!.month,
                          ListVaccination[index].dateVaccination!.day);

                      String formattedDate = DateFormat('dd-MM-yyyy').format(d);
                      return Column(
                        children: [
                          Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    // An action can be bigger than the others.
                                    flex: 1,
                                    onPressed: (BuildContext context) {
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CupertinoAlertDialog(
                                          title: Text(
                                              'ลบข้อมูลการฉีดวัคซีน\nวันที่: ${formattedDate}\nชื่อวัคซีน : ${ListVaccination[index].vaccine!.name_vaccine} \nรหัสโค : ${ListVaccination[index].cow!.cow_id}'),
                                          content: const Text(
                                              'เช็คข้อมูลการลบข้อมูลทุกครั้ง'),
                                          actions: <CupertinoDialogAction>[
                                            CupertinoDialogAction(
                                              isDefaultAction: true,
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No'),
                                            ),
                                            CupertinoDialogAction(
                                              isDestructiveAction: true,
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                final feeding =
                                                    await Vaccination_data()
                                                        .DeleteVaccination(
                                                            ListVaccination[
                                                                    index]
                                                                .dateVaccination
                                                                .toString());
                                                if (feeding != 0) {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              super.widget));
                                                }
                                              },
                                              child: const Text('Yes'),
                                            )
                                          ],
                                        ),
                                      );
                                    },

                                    backgroundColor:
                                        const Color.fromARGB(255, 192, 73, 67),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: "ลบข้อมูลการฉีดวัคซีน",
                                  ),
                                ]),
                            child: Card(
                              color: (Colors.green),
                              child: ListTile(
                                  tileColor: Colors.white54,
                                  leading:
                                      _buildLeadingTile_vaccine(widget.cow),
                                  onTap: (() {}),
                                  //title: Progress_date(widget.cow),
                                  subtitle: _subtitleVaccination(
                                      ListVaccination[index])
                                  // isThreeLine: true,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    },
                  )
                : Column(
                    children: const [
                      Text(
                        'ยังไม่มีรายการที่เลือก',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
      );
    } else if (text == "การผสมพันธุ์โค") {
      return Container(
        height: 470,
        width: 500,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Card(
            color: const Color(0XFF397D54),
            child: List_Cow_has_Hybridization.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: List_Cow_has_Hybridization.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime d = DateTime(
                          List_Cow_has_Hybridization[index].hybridization!.date_Hybridization!.year +
                              543,
                          List_Cow_has_Hybridization[index]
                              .hybridization!
                              .date_Hybridization!
                              .month,
                          List_Cow_has_Hybridization[index]
                              .hybridization!
                              .date_Hybridization!
                              .day);

                      String formattedDate = DateFormat('dd-MM-yyyy').format(d);
                      return Column(
                        children: [
                          Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    // An action can be bigger than the others.
                                    flex: 1,
                                    onPressed: (BuildContext context) {
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CupertinoAlertDialog(
                                          title: Text(
                                              'ลบข้อมูลการผสมพันธุ์\n วันที่ผสมพันธุ์ ${formattedDate} \nรหัสโค : ${List_Cow_has_Hybridization[index].cow!.cow_id}'),
                                          content: const Text(
                                              'เช็คข้อมูลการลบข้อมูลทุกครั้ง'),
                                          actions: <CupertinoDialogAction>[
                                            CupertinoDialogAction(
                                              isDefaultAction: true,
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No'),
                                            ),
                                            CupertinoDialogAction(
                                              isDestructiveAction: true,
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                final feeding = await Hybridization_data()
                                                    .DeleteCow_has_Hybridization(
                                                        List_Cow_has_Hybridization[
                                                                index]
                                                            .cow!
                                                            .cow_id
                                                            .toString(),
                                                        List_Cow_has_Hybridization[
                                                                index]
                                                            .hybridization!
                                                            .id_Hybridization
                                                            .toString());
                                                if (feeding != 0) {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              super.widget));
                                                }
                                              },
                                              child: const Text('Yes'),
                                            )
                                          ],
                                        ),
                                      );
                                    },

                                    backgroundColor:
                                        const Color.fromARGB(255, 192, 73, 67),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: "ลบข้อมูลการผสมพันธุ์โค",
                                  ),
                                ]),
                            child: Card(
                              color: (Colors.green),
                              child: ListTile(
                                  tileColor: Colors.white54,
                                  leading: _buildLeadingTile(widget.cow),

                                  //title: Progress_date(widget.cow),
                                  subtitle: _subtitleCow_has_Hybridization(
                                      List_Cow_has_Hybridization[index],
                                      widget.cow.gender,
                                      gender_co[index])
                                  // isThreeLine: true,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    },
                  )
                : Column(
                    children: const [
                      Text(
                        'ยังไม่มีรายการที่เลือก',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
      );
    } else {
      return Text(text);
    }
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

    return Align(
        alignment: Alignment.centerLeft,
        child: Text("อายุ : $duration",
            style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 12, 2, 2),
                fontWeight: FontWeight.w600)));
  }

  Widget _buildLeadingTile(Cow c) {
    /*
    if (c.picture != null || c.picture != "-") {
      return Container(
        padding: const EdgeInsets.only(right: 10.0),
        width: 80,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            border: Border(right: BorderSide(width: 1.0, color: Colors.black))),
        child: SizedBox(
          width: 75,
          height: 75,
          child: Image.network(
            c.picture.toString(),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {*/

    return Container(
      width: 80,
      height: 100,
      child: Image.asset(
        "images/cow-01.png",
        width: 100,
        height: 100,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildLeadingTile_feeding(Cow c) {
    /*
    if (c.picture != null || c.picture != "-") {
      return Container(
        padding: const EdgeInsets.only(right: 10.0),
        width: 80,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            border: Border(right: BorderSide(width: 1.0, color: Colors.black))),
        child: SizedBox(
          width: 75,
          height: 75,
          child: Image.network(
            c.picture.toString(),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {*/

    return Container(
      width: 80,
      height: 100,
      child: Image.asset(
        "images/cow-05.png",
        width: 100,
        height: 100,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildLeadingTile_vaccine(Cow c) {
    return Container(
      width: 81,
      height: 100,
      child: Image.asset(
        "images/cow-06.png",
        width: 100,
        height: 100,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  image_cow(Cow c) {
    return Stack(children: [
      Container(
        height: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [BoxShadow(color: Colors.black)]),
        child: Image.network(
          url.URL_IMAGE + c.picture.toString(),
          fit: BoxFit.fill,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(32, 60, 0, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (widget.emp != null) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return MainpageEmployee(
                      cow: listcow,
                      emp: widget.emp,
                    );
                  })));
                } else {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return Mainfarm(
                      fm: widget.fm!,
                    );
                  })));
                }
              },
              child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25,
                  )),
            )
          ],
        ),
      ),
    ]);
  }

  image_cow_df() {
    return Image.asset(
      "images/cow-01.png",
      width: 250.0,
      height: 250.0,
      fit: BoxFit.contain,
    );
  }

  Progress_date(Progress p) {
    int textYear = 0;
    String textMonth = " ";
    String textDay = " ";

    String colros = "";
    String nameSpecies = "";
    String gender = "";

    DateTime birthday = DateTime.now();
    DateDuration duration;

//Age
    var numY = int.parse(p.progress_date!.year.toString());
    textYear = numY + 543;

    var numM = int.parse(p.progress_date!.month.toString());

    var numD = int.parse(p.progress_date!.day.toString());

    DateTime dateBirthday = DateTime(numY, numM, numD);

    gender = cow.gender.toString();

    return Text(
        "วันที่บันทึก : ${dateBirthday.day} / ${dateBirthday.month} / ${dateBirthday.year}",
        style: const TextStyle(
            fontSize: 20.0,
            color: Color.fromARGB(255, 12, 2, 2),
            fontWeight: FontWeight.w600));
  }

  _subtitleprogress(Progress p) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
            "ส่วนสูง : ${p.height} เซนติเมตร\nน้ำหนัก : ${p.weight} กิโลกรัม",
            style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 12, 2, 2),
                fontWeight: FontWeight.w600)));
  }

  _subtitlefeeding(Feeding f) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
            "วันที่: ${f.record_date!.day}/${f.record_date!.month}/${f.record_date!.year}\nเวลา ${f.record_date!.hour} : ${f.record_date!.minute}\nอาหาร : ${f.food!.food_name}\nจำนวน : ${f.amount}  (กิโลกรัม) \nอาหารเสริม: ${f.food_supplement}\nช่วงเวลาให้อาหาร : ตอน${f.time}",
            style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 12, 2, 2),
                fontWeight: FontWeight.w600)));
  }

  _subtitleVaccination(Vaccination v) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
            "วันฉีดวัคซีน : ${v.dateVaccination!.day}/${v.dateVaccination!.month}/${v.dateVaccination!.year}\nชื่อวัคซีน : ${v.vaccine!.name_vaccine} จำนวนที่ฉีด : ${v.countvaccine} มิลลิลิตร\nชื่อหมอ : ${v.doctorname}",
            style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 12, 2, 2),
                fontWeight: FontWeight.w600)));
  }

  _subtitleCow_has_Hybridization(
      Cow_has_Hybridization cH, String? gender, Cow gender_co) {
    if (cH.hybridization!.result == "สำเร็จ" && widget.cow.gender == "ผู้") {
      return Align(
          alignment: Alignment.centerLeft,
          child: Text(
              "วันที่ผสมพันธุ์ :${cH.hybridization!.date_Hybridization!.day}/${cH.hybridization!.date_Hybridization!.month}/${cH.hybridization!.date_Hybridization!.year} \nผลลัพธ์ : ${cH.hybridization!.result}\nหมาเลขประจำตัวแม่พันธุ์ : \n${gender_co.cow_id} \nวันที่คลอดลูก: ${cH.hybridization!.date_of_birthday!.day}/${cH.hybridization!.date_of_birthday!.month}/${cH.hybridization!.date_of_birthday!.year}   \nประเภทการผสมพันธุ์ : \n${cH.hybridization!.typebridization!.name_typebridization}",
              /* "",*/
              style: const TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 12, 2, 2),
                  fontWeight: FontWeight.w600)));
    } else if (cH.hybridization!.result == "ไม่สำเร็จ" &&
        widget.cow.gender == "ผู้") {
      return Align(
          alignment: Alignment.centerLeft,
          child: Text(
              "วันที่ผสมพันธุ์ :${cH.hybridization!.date_Hybridization!.day}/${cH.hybridization!.date_Hybridization!.month}/${cH.hybridization!.date_Hybridization!.year} \nผลลัพธ์ : ${cH.hybridization!.result}\nหมาเลขประจำตัวแม่พันธุ์ : \n${gender_co.cow_id} \nประเภทผสมพันธุ์ :\n${cH.hybridization!.typebridization!.name_typebridization}",
              style: const TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 12, 2, 2),
                  fontWeight: FontWeight.w600)));
    }
    if (cH.hybridization!.result == "สำเร็จ" && widget.cow.gender == "เมีย") {
      return Align(
          alignment: Alignment.centerLeft,
          child: Text(
              "วันที่ผสมพันธุ์ :${cH.hybridization!.date_Hybridization!.day}/${cH.hybridization!.date_Hybridization!.month}/${cH.hybridization!.date_Hybridization!.year} \nผลลัพธ์ : ${cH.hybridization!.result}\nหมาเลขประจำตัวพ่อพันธุ์ : \n${gender_co.cow_id} \nประเภทผสมพันธุ์ :\n${cH.hybridization!.typebridization!.name_typebridization}",
              /*"",*/
              style: const TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 12, 2, 2),
                  fontWeight: FontWeight.w600)));
    } else if (cH.hybridization!.result == "ไม่สำเร็จ" &&
        widget.cow.gender == "เมีย") {
      return Align(
          alignment: Alignment.centerLeft,
          child: Text(
              "วันที่ผสมพันธุ์ :${cH.hybridization!.date_Hybridization!.day}/${cH.hybridization!.date_Hybridization!.month}/${cH.hybridization!.date_Hybridization!.year} \nผลลัพธ์ : ${cH.hybridization!.result}\nหมาเลขประจำตัวพ่อพันธุ์ : \n${gender_co.cow_id} \nประเภทผสมพันธุ์ :\n${cH.hybridization!.typebridization!.name_typebridization}",
              /*"",*/
              style: const TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 12, 2, 2),
                  fontWeight: FontWeight.w600)));
    }
  }
}
