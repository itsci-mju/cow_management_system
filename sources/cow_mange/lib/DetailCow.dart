import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/Mainpage.dart';
import 'package:cow_mange/class/Cow_has_Hybridization.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Feeding.dart';
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

//firebase

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
    "ข้อมูลต่างๆของโค",
  ];
  int selectIndex = 0;

  Cow cow = Cow();

  late List<dynamic> list;
  Map? mapResponse;
  List<Cow> listcow = [];
  Cow breeder_cow = Cow();
  Cow breeder_bull = Cow();

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
        await Feeding_data().listMainFedding(widget.cow.cow_id.toString());
    final listVc = await Vaccination_data()
        .listMainVaccination(widget.cow.cow_id.toString());
    final list_c__list_hz = await Hybridization_data()
        .listMainCow_has_Hybridization(widget.cow.cow_id.toString());

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
    final Storage storage = Storage();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
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
              widget.cow.picture == "-"
                  ? image_cow_df()
                  : image_cow(widget.cow),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 28.0),
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                decoration: const BoxDecoration(
                    color: Color(0XFF397D54),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
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
                      child: Text(
                        "รหัสโค : ${widget.cow.namecow}",
                        style: const TextStyle(
                            fontSize: 28.0,
                            color: Color.fromARGB(255, 253, 253, 253),
                            fontWeight: FontWeight.w700),
                      ),
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
                              "สายพันธุ์ ",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              widget.cow.species!.species_breed.toString(),
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Color.fromARGB(255, 255, 253, 253),
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
                              FontAwesomeIcons.user,
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
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              widget.cow.caretaker.toString(),
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Color.fromARGB(255, 255, 253, 253),
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
                      margin: const EdgeInsets.symmetric(horizontal: 32.0),
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
                                      ? const Color.fromARGB(255, 29, 103, 31)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(28.0)),
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
                            height: 470,
                            width: 370,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 212, 248, 226),
                                borderRadius: BorderRadius.circular(24.0)),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        child: Text(
                                            "รหัสประจำตัวโค : ${widget.cow.cow_id}",
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                color: Color.fromARGB(
                                                    255, 12, 2, 2),
                                                fontWeight: FontWeight.w600))),
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
                                            color:
                                                Color.fromARGB(255, 12, 2, 2),
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
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "สายพันธุ์ : ${widget.cow.species!.species_breed}",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "ประเทศ : ${widget.cow.species!.country}",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "ผู้ดูแล : ${widget.cow.caretaker}",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: const [
                                      /* RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color: const Color.fromARGB(
                                                  255, 12, 2, 2),
                                              fontWeight: FontWeight.w600),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: widget.cow.breeder!.father
                                                    .toString(),
                                                recognizer:
                                                    new TapGestureRecognizer()
                                                      ..onTap = () {
                                                        setState(() {
                                                          cow.cow_id = widget
                                                              .cow
                                                              .breeder!
                                                              .father
                                                              .toString();
                                                        });
                                                      },
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green)),
                                          ],
                                        ),
                                      ),*/
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "เลขประจำตัวพ่อ",
                                        maxLines: 1,
                                        softWrap: false,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color:
                                                Color.fromARGB(255, 12, 2, 2),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: Column(children: [
                                                InkWell(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                          child: Text(
                                                              breeder_bull == null
                                                                  ? "ยังไม่มีข้อมูลในระบบ"
                                                                  : breeder_bull
                                                                      .namecow
                                                                      .toString(),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      20.0,
                                                                  color:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          4,
                                                                          192,
                                                                          10),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis))),
                                                  onTap: () async {
                                                    setState(() {
                                                      cow_id = breeder_bull
                                                          .cow_id
                                                          .toString();
                                                    });

                                                    final newbreederBull =
                                                        await Breeder_data()
                                                            .fetch_Cow_bull(
                                                                cow_id);
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                ((context) {
                                                      return DetailCow(
                                                          cow: newbreederBull,
                                                          emp: widget.emp);
                                                    })));
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
                                            color:
                                                Color.fromARGB(255, 12, 2, 2),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: Column(children: [
                                                InkWell(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                          child: Text(
                                                              breeder_cow == null
                                                                  ? "ยังไม่มีข้อมูลในระบบ"
                                                                  : breeder_cow
                                                                      .namecow
                                                                      .toString(),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      20.0,
                                                                  color:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          4,
                                                                          192,
                                                                          10),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis))),
                                                  onTap: () async {
                                                    setState(() {
                                                      cow_id = breeder_cow
                                                          .cow_id
                                                          .toString();
                                                    });
                                                    final newbreederCow =
                                                        await Breeder_data()
                                                            .fetch_Cow_cow(
                                                                cow_id);
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                ((context) {
                                                      return DetailCow(
                                                          cow: newbreederCow,
                                                          emp: widget.emp);
                                                    })));
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
                                      child: Text("เพศ : ${widget.cow.gender} ",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "น้ำหนัก : ${widget.cow.weight} กิโลกรัม",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "ส่วนสูง : ${widget.cow.height} กิโลกรัม",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
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
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("สี : ${widget.cow.color}",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color:
                                        const Color.fromARGB(255, 254, 255, 253)
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
                                      hintStyle: TextStyle(color: Colors.black),
                                      icon: Icon(
                                        FontAwesomeIcons.cow,
                                        color: Color.fromARGB(255, 0, 0, 0),
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
                                              'qqqq ${Listprogress[index].cow!.cow_id}'),
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
                                  onTap: (() {}),
                                  title: Progress_date(Listprogress[index]),
                                  subtitle:
                                      _subtitleprogress(Listprogress[index])
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
                                              'qqqq ${ListFeeding[index].cow!.cow_id}'),
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
                                    label: "ลบข้อมูลการพัฒนาโค",
                                  ),
                                ]),
                            child: Card(
                              color: (Colors.green),
                              child: ListTile(
                                  tileColor: Colors.white54,
                                  leading: _buildLeadingTile(widget.cow),
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
                                              'รหัสโค : ${ListVaccination[index].cow!.cow_id}'),
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
                                    label: "ลบข้อมูลการพัฒนาโค",
                                  ),
                                ]),
                            child: Card(
                              color: (Colors.green),
                              child: ListTile(
                                  tileColor: Colors.white54,
                                  leading: _buildLeadingTile(widget.cow),
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
                                              'qqqq ${List_Cow_has_Hybridization[index].cow!.cow_id}'),
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
                                    label: "ลบข้อมูลการพัฒนาโค",
                                  ),
                                ]),
                            child: Card(
                              color: (Colors.green),
                              child: ListTile(
                                  tileColor: Colors.white54,
                                  leading: _buildLeadingTile(widget.cow),
                                  onTap: (() {}),
                                  //title: Progress_date(widget.cow),
                                  subtitle: _subtitleCow_has_Hybridization(
                                      List_Cow_has_Hybridization[index])
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

  Widget _buildLeadingTile(Cow c) {
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
    } else {
      return Container(
        padding: const EdgeInsets.only(right: 10.0),
        width: 80,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            border: Border(right: BorderSide(width: 1.0, color: Colors.black))),
        child: SizedBox(
          width: 75,
          height: 75,
          child: Image.asset(
            "images/cow-01.png",
            width: 250.0,
            height: 250.0,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }

  image_cow(Cow c) {
    return Image.network(
      c.picture.toString(),
      fit: BoxFit.cover,
    );
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

    DateTime dateBirthday = DateTime(numY, numM + 1, numD);

    gender = cow.gender.toString();

    return Text(
        "วันที่บันทึก :${dateBirthday.day} / ${dateBirthday.month} / ${dateBirthday.year}",
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
            "อาหาร : ${f.food!.food_name}\n${f.amount} จำนวน (กิโลกรัม)",
            style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 12, 2, 2),
                fontWeight: FontWeight.w600)));
  }

  _subtitleVaccination(Vaccination v) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
            "ชื่อวัคซีน : ${v.vaccine!.name_vaccine} จำนวนที่ฉีด : ${v.countvaccine} มิลลิลิตร",
            style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 12, 2, 2),
                fontWeight: FontWeight.w600)));
  }

  _subtitleCow_has_Hybridization(Cow_has_Hybridization cH) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text("วันที่ผสมพันธุ์ :  ผลลัพธ์ : ${cH.hybridization!.result}",
            style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 12, 2, 2),
                fontWeight: FontWeight.w600)));
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
}
