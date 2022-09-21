// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:cow_mange/MainFeedingcow.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/class/Feeding.dart';

//
import 'package:http/http.dart' as http;
import 'package:cow_mange/url/URL.dart';

class ListFeeding extends StatefulWidget {
  final Cow? cow;
  final Employee? emp;
  const ListFeeding({
    Key? key,
    this.cow,
    this.emp,
  }) : super(key: key);

  @override
  State<ListFeeding> createState() => _ListFeedingState();
}

class _ListFeedingState extends State<ListFeeding> {
  String query = "";
  List<Feeding> Listfeeding = [];
//day - month - year
  List<String> year = [];
  List<String> month = [];
  List<String> day = [];
  List<String> amount = [];
  List<String> food_name = [];

  //class
  List<Cow> cow = [];

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

  Future listMainFedding(cowId) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_list_feeding_id_cow.toString()),
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
      return list!.map((e) => Feeding.fromJson(e)).toList();
    }
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

  Future DeleteFedding(idFeeding) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_feeding_delete.toString()),
      body: jsonEncode({
        "id_Feeding": idFeeding,
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
      dynamic feeding = mapResponse['result'];

      return feeding;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future init() async {
    final listfd = await listMainFedding(widget.cow!.cow_id.toString());
    final co = await listMaincow(widget.emp!);

    setState(() {
      Listfeeding = listfd;
      cow = co;
    });
  }

  bool _showClearButton = false;
  final globalKey = GlobalKey<ScaffoldState>();
  final inputSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: Listfeeding == null
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
                          return Feedingcow(
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
                          "การให้อาหารโคของ ${widget.cow!.cow_id}",
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
                        itemCount: Listfeeding.length,
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
                                                Navigator.pop(context);
                                                final df = await DeleteFedding(
                                                    Listfeeding[index]
                                                        .id_Feeding!
                                                        .toString());
                                                if (df != 0) {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: ((context) {
                                                    return Feedingcow(
                                                      cow: cow,
                                                      emp: widget.emp,
                                                    );
                                                  })));
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
                                    label: 'ลบข้อมูลโค',
                                  ),
                                ],
                              ),
                              child: Container(
                                  child: Card(
                                      color: (Colors.green),
                                      child: ListTile(
                                        leading: _buildLeadingTile(),
                                        title: Text(
                                          "รหัสการให้อาหารโค : ${Listfeeding[index]
                                                  .id_Feeding!}",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        subtitle: _birthdayCow(),
                                        isThreeLine: true,
                                      ))));
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
        child: const Icon(Icons.close, color: Colors.green),
        onTap: () {
          inputSearch.clear();
          search("");
        });
  }

  Text _birthdayCow() {
    int textyear = 0;
    String textMonth = " ";
    String textDay = " ";
    String textAmount = "";
    String textFoodName = "";

    for (int i = 0; i < Listfeeding.length; i++) {
      year.add(Listfeeding[i].record_date!.year.toString());
      month.add(Listfeeding[i].record_date!.month.toString());
      day.add(Listfeeding[i].record_date!.day.toString());
      amount.add(Listfeeding[i].amount.toString());
      food_name.add(Listfeeding[i].food!.food_name.toString());

//year
      String y = year[i].toString();

      String replaceYear = y;
      var numY = int.parse(replaceYear);
      textyear = numY + 543;

//month
      textMonth = month[i].toString();

//day
      textDay = day[i].toString();

//amount
      textAmount = amount[i].toString();

//food_name
      textFoodName = food_name[i].toString();
    }
    return Text(
        //textyear.toString(),
        "วันที่บันทึก :$textDay/$textMonth/$textyear\nจำนวน :$textAmount กิโลกรัม\nชื่ออาหาร :$textFoodName",
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
