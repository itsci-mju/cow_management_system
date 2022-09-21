// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cow_mange/MainHybridization.dart';
import 'package:cow_mange/class/Cow_has_Hybridization.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cow_mange/class/Cow.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListHybridization extends StatefulWidget {
  final Cow? cow;
  final Employee? emp;
  const ListHybridization({
    Key? key,
    this.cow,
    this.emp,
  }) : super(key: key);

  @override
  State<ListHybridization> createState() => _ListHybridizationState();
}

class _ListHybridizationState extends State<ListHybridization> {
  List<Cow_has_Hybridization> ListCow_has_Hybridization = [];
  String query = "";
  List<Cow> listcow = [];

  //List_text Cow_has_Hybridization
  List<String> year = [];
  List<String> month = [];
  List<String> day = [];
  List<String> id_Hybridization = [];

  String? stringResponse;
  List? list;

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

  Future init() async {
    setState(() {});
  }

  bool _showClearButton = false;
  final globalKey = GlobalKey<ScaffoldState>();
  final inputSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: ListCow_has_Hybridization == null
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
                          return MainHybridization(
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
                          "การผสมพันธุ์โค ${widget.cow!.cow_id}",
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
                        cursorColor: const Color.fromARGB(255, 0, 0, 0),
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
                        itemCount: ListCow_has_Hybridization.length,
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
                                                /*
                                                Navigator.pop(context);
                                                final co =
                                                    await DeleteCow_has_Hybridization(
                                                        ListCow_has_Hybridization[
                                                                index]
                                                            .cow!
                                                            .cow_id
                                                            .toString(),
                                                        ListCow_has_Hybridization[
                                                                index]
                                                            .hybridization!
                                                            .id_Hybridization
                                                            .toString());
                                                if (co != 0) {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: ((context) {
                                                    return MainHybridization(
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
                              child: Container(
                                  child: Card(
                                      color: (Colors.green),
                                      child: ListTile(
                                        leading: _buildLeadingTile(),
                                        title: Text(
                                          "รหัสการพัฒนาโค : ${ListCow_has_Hybridization[index]
                                                  .hybridization!
                                                  .id_Hybridization}",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        subtitle: progress_date(),
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
        child: const Icon(Icons.close),
        onTap: () {
          inputSearch.clear();
          search("");
        });
  }

  Text progress_date() {
    int textyear = 0;
    String textMonth = " ";
    String textDay = " ";
    String textIdHybridization = "";
    String textWeight = "";

    for (int i = 0; i < ListCow_has_Hybridization.length; i++) {
      year.add(ListCow_has_Hybridization[i]
          .hybridization!
          .date_Hybridization!
          .year
          .toString());
      month.add(ListCow_has_Hybridization[i]
          .hybridization!
          .date_Hybridization!
          .month
          .toString());
      day.add(ListCow_has_Hybridization[i]
          .hybridization!
          .date_Hybridization!
          .day
          .toString());
      id_Hybridization.add(ListCow_has_Hybridization[i]
          .hybridization!
          .id_Hybridization
          .toString());

      //year
      String y = year[i].toString();

      String textYear = y;
      var numYear = int.parse(textYear);
      textyear = numYear + 543;

//month
      textMonth = month[i].toString();

//day
      textDay = day[i].toString();

//height
      textIdHybridization = id_Hybridization[i].toString();

//weight
      // text_weight = weight[i].toString();
    }
    return Text(
        "วันที่บันทึก :$textDay/$textMonth/$textyear\nน้ำหนัก :$textWeight  ส่วนสูง :$textIdHybridization",
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
