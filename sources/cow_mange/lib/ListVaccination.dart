import 'dart:convert';

import 'package:cow_mange/MainVaccine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/class/vaccination.dart';
import 'package:cow_mange/url/URL.dart';

class ListVaccination extends StatefulWidget {
  final Cow? cow;
  final Employee? emp;
  const ListVaccination({
    Key? key,
    this.emp,
    this.cow,
  }) : super(key: key);

  @override
  State<ListVaccination> createState() => _ListVaccinationState();
}

class _ListVaccinationState extends State<ListVaccination> {
  List<Vaccination> Listvaccination = [];
  String query = "";
  List<Cow> listcow = [];

  //class
  List<Cow> cow = [];

  //
  List<String> year = [];
  List<String> month = [];
  List<String> day = [];
  List<String> doctorname = [];
  List<String> countvaccine = [];
  List<String> price = [];
  List<String> name_vaccine = [];

  Future search(String q) async {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
    search(query);
    inputSearch.addListener(() {
      setState(() {
        _showClearButton = inputSearch.text.isNotEmpty;
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
    final listvct = await listMainVaccination(widget.cow!.cow_id.toString());
    final co = await listMaincow(widget.emp!);

    setState(() {
      Listvaccination = listvct;
      cow = co;
    });
  }

  Future listMainVaccination(cowId) async {
    final response = await http.post(
      Uri.parse(
          url.URL.toString() + url.URL_list_Vaccination_id_cow.toString()),
      body: jsonEncode({
        "cow": cowId,
      }),
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
      return list!.map((e) => Vaccination.fromJson(e)).toList();
    }
  }

  bool _showClearButton = false;
  final globalKey = GlobalKey<ScaffoldState>();
  final inputSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return Scaffold(
      key: globalKey,
      body: Listvaccination == null
          ? Column(children: const <Widget>[])
          : Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: ((context) {
                          return MainVaccine(
                            cow: cow,
                            emp: widget.emp,
                          );
                        })));
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 25,
                          )),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "ข้อมูลการฉีดวัคซีน ${widget.cow!.cow_id}",
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                      child: TextFormField(
                        controller: inputSearch,
                        decoration: InputDecoration(
                          hintText: "ค้นหาโค",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          isDense: true,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.green,
                            size: 26,
                          ),
                          suffixIcon: _getClearButton(),
                        ),
                        onChanged: search,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 8, 0),
                    child: Row(
                      children: [
                        Builder(builder: (context) {
                          return IconButton(
                              iconSize: 28,
                              onPressed: () {
                                globalKey.currentState!.openEndDrawer();
                              },
                              icon: const Icon(FontAwesomeIcons.filter));
                        })
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: Listvaccination.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    // An action can be bigger than the others.
                                    flex: 3,
                                    onPressed: (BuildContext context) {
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CupertinoAlertDialog(
                                          title: Text('ยืนยันการลบข้อมูลโค ${widget.cow!.cow_id}'),
                                          content: const Text(
                                              'เช็คข้อมูลการลบข้อมูลทุกครั้ง'),
                                          actions: <CupertinoDialogAction>[
                                            CupertinoDialogAction(
                                              /// This parameter indicates this action is the default,
                                              /// and turns the action's text to bold text.
                                              isDefaultAction: true,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No'),
                                            ),
                                            CupertinoDialogAction(
                                              /// This parameter indicates the action would perform
                                              /// a destructive action such as deletion, and turns
                                              /// the action's text color to red.
                                              isDestructiveAction: true,
                                              onPressed: () async {
                                                String date = "";
                                                DateTime d = DateTime(
                                                    Listvaccination[index]
                                                        .dateVaccination!
                                                        .year,
                                                    Listvaccination[index]
                                                            .dateVaccination!
                                                            .month +
                                                        1,
                                                    Listvaccination[index]
                                                        .dateVaccination!
                                                        .day);

                                                setState(() {
                                                  date = "${d.year}-${d.month}-${d.day}";
                                                });
                                                Navigator.pop(context);
/*
                                                final dv =
                                                    await DeleteVaccination(
                                                        date);
                                                if (dv != 0) {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: ((context) {
                                                    return MainVaccine(
                                                      cow: cow,
                                                      emp: widget.emp,
                                                    );
                                                  })));
                                                }*/
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
                                    label: 'ลบข้อมูลโค',
                                  ),
                                ],
                              ),
                              child: Card(
                                  color: (Colors.green),
                                  child: ListTile(
                                    leading: _buildLeadingTile(),
                                    title: _dateVaccination(),
                                    subtitle: _textListvaccination(),
                                    isThreeLine: true,
                                  )));
                        },
                      )))
            ]),
    );
  }

  Widget? _getClearButton() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton) {
      return null;
    }

    return GestureDetector(
        child: const Icon(Icons.close),
        onTap: () {
          inputSearch.clear();
          search("");
        });
  }

  Text _dateVaccination() {
    int textyear = 0;
    String textMonth = " ";
    String textDay = " ";

    for (int i = 0; i < Listvaccination.length; i++) {
      year.add(Listvaccination[i].dateVaccination!.year.toString());
      month.add(Listvaccination[i].dateVaccination!.month.toString());
      day.add(Listvaccination[i].dateVaccination!.day.toString());

//year
      String y = year[i].toString();

      String replaceYear = y;
      var numY = int.parse(replaceYear);
      textyear = numY + 543;

//month
      textMonth = month[i].toString();

//day
      textDay = day[i].toString();
    }
    return Text(
        //textyear.toString(),
        "วันที่บันทึก :$textDay/$textMonth/$textyear",
        style: const TextStyle(fontSize: 20));
  }

  Text _textListvaccination() {
    int textyear = 0;
    String textMonth = " ";
    String textDay = " ";
    String textDoctorname = "";
    String textCountvaccine = "";
    String textPrice = "";
    String textNameVaccine = "";

    for (int i = 0; i < Listvaccination.length; i++) {
      year.add(Listvaccination[i].dateVaccination!.year.toString());
      month.add(Listvaccination[i].dateVaccination!.month.toString());
      day.add(Listvaccination[i].dateVaccination!.day.toString());
      name_vaccine.add(Listvaccination[i].vaccine!.name_vaccine.toString());
      doctorname.add(Listvaccination[i].doctorname.toString());
      countvaccine.add(Listvaccination[i].countvaccine.toString());

//year
      String y = year[i].toString();

      String replaceYear = y;
      var numY = int.parse(replaceYear);
      textyear = numY + 543;

//month
      textMonth = month[i].toString();

//name_vaccine
      textNameVaccine = name_vaccine[i].toString();

//day
      textDay = day[i].toString();

//doctorname
      textDoctorname = doctorname[i].toString();

//countvaccine
      textCountvaccine = countvaccine[i].toString();

//price
      textPrice = price[i].toString();
    }
    return Text(
        //textyear.toString(),
        "วันที่บันทึก :$textDay/$textMonth/$textyear\nชื่อวัคซีน :$textNameVaccine\nจำนวนวัคซีน :$textDoctorname  ราคา :$textPrice บาท\nชื่อหมอ :$textDoctorname",
        style: const TextStyle(fontSize: 17));
  }
}

Widget _buildLeadingTile() {
  return Container(
    padding: const EdgeInsets.only(right: 10.0),
    width: 80,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
        border:
            Border(right: BorderSide(width: 1.0, color: Colors.black))),
    child: Container(
      width: 75,
      height: 75,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage("images/cow-01.png"),
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}
