import 'dart:convert';

import 'package:cow_mange/Drawer/Fitter.dart';
import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/Mainpage.dart';

import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Species.dart';
import 'package:cow_mange/mainfarm.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:cow_mange/url/URL.dart';

import 'package:http/http.dart' as http;

class Drawer_Filter extends StatefulWidget {
  final Employee? emp;
  final Farm? fm;
  final List<Cow> cow;
  const Drawer_Filter({
    Key? key,
    required this.cow,
    this.fm,
    this.emp,
  }) : super(key: key);

  @override
  State<Drawer_Filter> createState() => _Drawer_FilterState();
}

final Age1 = TextEditingController();
final Age2 = TextEditingController();
List<String>? vsplit = [];
String string_age1 = "";
String string_age2 = "";
int checkage = 0;

String gender1 = "";
String gender2 = "";
String breeder1 = "";
String breeder2 = "";
List<Species> species = [];
List<Cow> cow = [];

Fitter ft = Fitter();

class _Drawer_FilterState extends State<Drawer_Filter> {
  Future listMaincow(Employee emp) async {
    final JsonlistMaincow = emp.toJsoncow();

    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Listmaincow.toString()),
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

  Future listspecies() async {
    final response = await http
        .post(Uri.parse(url.URL.toString() + url.URL_Listspecies.toString()));

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      List? list;
      mapResponse = json.decode(response.body);

      list = mapResponse['result'];

      return list!.map((e) => Species.fromJson2(e)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final sp = await listspecies();
    setState(() {
      species = sp;
    });
  }

  @override
  Widget build(BuildContext context) {
    void openFilterDialog() async {
      await FilterListDialog.display<Species>(
        context,
        listData: species,
        selectedListData: species,
        choiceChipLabel: (species) => species!.species_breed,
        validateSelectedItem: (list, val) => list!.contains(val),
        onItemSearch: (species, query) {
          return species.species_breed!
              .toLowerCase()
              .contains(query.toLowerCase());
        },
        height: 360,
        borderRadius: 20,
        headlineText: "เลือกสายพันธุ์  ",
        backgroundColor: Colors.green,
        onApplyButtonClick: (list) {
          setState(() {
            ft.species = List.from(list!);
            if (ft.species!.isEmpty) {
              ft.species = null;
            }
            print(ft.species);
          });
          Navigator.pop(context);
        },
      );
    }

    Size size = MediaQuery.of(context).size;
    double heightimg = size.height - (size.height * 0.8);
    int i = 0;
    return Drawer(
        child: Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "เพศ",
            style: TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    SizedBox(
                      child: CustomCheckBoxGroup(
                        buttonTextStyle: const ButtonTextStyle(
                          selectedColor: Colors.green,
                          unSelectedColor: Colors.black,
                          textStyle: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        unSelectedColor: Colors.grey,
                        buttonValuesList: const [
                          "ผู้",
                          "เมีย",
                        ],
                        checkBoxButtonValues: (values) {
                          gender1 = "";
                          gender2 = "";
                          if (values.isEmpty) {
                            gender1 = "";
                            gender2 = "";
                          } else {
                            for (var gender in values) {
                              gender1 = "";
                              gender2 = "";
                              if (values.length == 1) {
                                gender1 = "";
                                gender2 = "$gender";
                                if (gender2 == "ผู้") {
                                  gender1 = "$gender";
                                  gender2 = "";
                                }
                              } else if (values.length == 2) {
                                gender1 = "";
                                gender2 = "";
                                gender1 = "ผู้";
                                gender2 = "เมีย";
                              }
                            }
                          }
                        },
                        buttonLables: const [
                          "ผฺู้",
                          "เมีย",
                        ],
                        shapeRadius: 500,
                        radius: 500,
                        selectedBorderColor: Colors.green,
                        unSelectedBorderColor: Colors.white,
                        spacing: 0,
                        defaultSelected: null,
                        horizontal: false,
                        enableButtonWrap: false,
                        absoluteZeroSpacing: false,
                        selectedColor: Colors.white,
                        padding: 10,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              children: const [
                Text(
                  "สายพันธุ์โค",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        openFilterDialog();
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(50, 50), backgroundColor: Colors.green),
                      child: const Text("เลือกสายพันธุ์โค"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    ft.species == null
                        ? Column(children: const [
                            Text(
                              "ยังไม่มีรายการที่เลือก",
                              style: TextStyle(fontSize: 16),
                            ),
                          ])
                        : ft.species![0].species_breed == 0
                            ? Column(children: const [
                                Text(
                                  "ยังไม่มีรายการที่เลือก2",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ])
                            : Column(children: [
                                const Text("รายการที่เลือก"),
                                for (i = 0; i < ft.species!.length; i++)
                                  Text(
                                    ft.species![i].species_breed.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  )
                              ])
                  ],
                ),
              ),
            ],
          ),
          const Text(
            "อายุ",
            style: TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              ),
              SizedBox(
                width: 100,
                child: TextField(
                    controller: Age1,
                    textAlign: TextAlign.center,
                    onChanged: (String value) {
                      setState(() {
                        if (Age1.text != string_age1) {
                          checkage = 1;
                        } else {
                          checkage = 2;
                        }
                      });
                    }),
              ),
              const Text("---"),
              SizedBox(
                width: 100,
                child: TextField(
                    textAlign: TextAlign.center,
                    controller: Age2,
                    onChanged: (String value) {
                      setState(() {
                        if (Age2.text != string_age2) {
                          checkage = 1;
                        } else {
                          checkage = 2;
                        }
                      });
                    }),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    SizedBox(
                      child: CustomRadioButton(
                        buttonTextStyle: ButtonTextStyle(
                          selectedColor:
                              checkage == 1 ? Colors.black : Colors.green,
                          textStyle: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        unSelectedColor:
                            checkage == 1 ? Colors.grey : Colors.grey,
                        buttonLables: const ["0-5", "5-10"],
                        radioButtonValue: (value) {
                          String v = "";
                          setState(() {
                            v = value as String;
                            vsplit = v.split("-");

                            string_age1 = vsplit![0];
                            string_age2 = vsplit![1];
                            Age1.text = string_age1;
                            Age2.text = string_age2;
                          });
                        },
                        buttonValues: const [
                          "0-5",
                          "5-10",
                        ],
                        shapeRadius: 500,
                        radius: 500,
                        selectedBorderColor:
                            checkage == 1 ? Colors.grey : Colors.green,
                        unSelectedBorderColor: Colors.white,
                        spacing: 0,
                        defaultSelected: null,
                        horizontal: false,
                        enableButtonWrap: false,
                        absoluteZeroSpacing: false,
                        selectedColor: Colors.white,
                        padding: 10,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      ft.species = null;
                      Age1.text = "";
                      Age2.text = "";
                    });
                    if (widget.emp != null) {
                      final listcow = await listMaincow(widget.emp!);

                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: ((context) {
                        return MainpageEmployee(
                          emp: widget.emp,
                          cow: listcow,
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
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(50, 50), backgroundColor: Colors.green),
                  child: const Text("ล้าง"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      //idfarm
                      if (widget.emp != null) {
                        ft.idfarm = widget.emp!.farm!.id_Farm.toString();
                      } else {
                        ft.idfarm = widget.fm!.id_Farm.toString();
                      }

                      //gender
                      ft.gendemale = gender1;
                      ft.genderwoman = gender2;

                      //age
                      if (Age1.text != "") {
                        ft.startage = Age1.text;

                        ft.endage = Age2.text;
                      } else {
                        ft.startage = "";
                        ft.endage = "";
                      }
                    });

                    final listcow = await Fitter_data().fitterCow(ft);
                    setState(() {
                      Age1.text = "";
                      Age2.text = "";
                    });

                    if (listcow != null) {
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
                            cow: listcow,
                          );
                        })));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(50, 50), backgroundColor: Colors.green),
                  child: const Text("ตกลง"),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
