import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cow_mange/AddEmployee.dart';
import 'package:cow_mange/AddExpend.dart';

import 'package:cow_mange/AddFeedingcow.dart';
import 'package:cow_mange/AddHybridization.dart';
import 'package:cow_mange/AddProgresscow.dart';
import 'package:cow_mange/AddVaccine.dart';
import 'package:cow_mange/DetailCow.dart';
import 'package:cow_mange/Drawer/Drawer_Filter.dart';
import 'package:cow_mange/EditExpend.dart';
import 'package:cow_mange/Editcow.dart';
import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/Register_cow.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/EditEmployee.dart';
import 'package:cow_mange/class/Expendfarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:cow_mange/Drawer/hamberg.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cow_mange/url/URL.dart';
import 'package:intl/intl.dart';

class Mainfarm extends StatefulWidget {
  final Farm fm;
  final List<Cow>? cow;

  const Mainfarm({
    Key? key,
    required this.fm,
    this.cow,
  }) : super(key: key);

  @override
  State<Mainfarm> createState() => _MainfarmState();
}

class _MainfarmState extends State<Mainfarm> {
  final globalKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  int _counter = 0;
  List<Cow> listcow = [];
  List<Employee> listemployee = [];
  List<Expendfarm> listexpendfarm = [];

  // query
  String query = "";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  bool _showClearButton = false;
  final inputSearch = TextEditingController();

  Future search_cow(String query, Farm farm) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Listmaincow_farm),
      body: jsonEncode({"id_Farm": farm.id_Farm}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List? list;
      Map<String, dynamic> mapResponse = json.decode(response.body);

      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Cow.fromJson(e)).where((Cow) {
        final textId = Cow.cow_id;
        final textquery = query;

        return textId!.toLowerCase().contains(textquery.toLowerCase());
      }).toList();
    }
  }

  Future search_employee(String query, Farm farm) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_List_idfarm),
      body: jsonEncode({"id_Farm": farm.id_Farm}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List? list;
      Map<String, dynamic> mapResponse = json.decode(response.body);

      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Employee.fromJson(e)).where((Employee) {
        final textName = Employee.firstname;
        final textquery = query;

        return textName!.toLowerCase().contains(textquery.toLowerCase());
      }).toList();
    }
  }

  Future search_expend(String query, Farm farm) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_List_idfarm_Expendfarm),
      body: jsonEncode({"id_Farm": farm.id_Farm}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List? list;
      Map<String, dynamic> mapResponse = json.decode(response.body);

      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Expendfarm.fromJson(e)).where((Expendfarm) {
        final textIdFarmt = Expendfarm.id_list;
        final textquery = query;

        return textIdFarmt!.toLowerCase().contains(textquery.toLowerCase());
      }).toList();
    }
  }

  Future search(String q) async {
    final co = await search_cow(q, widget.fm);

    if (!mounted) return;
    setState(() {
      query = q;
      listcow = co;
    });
  }

  Future search_emp(String q) async {
    final emp = await search_employee(q, widget.fm);

    if (!mounted) return;
    setState(() {
      query = q;
      listemployee = emp;
    });
  }

  Future search_exp(String q) async {
    final exp = await search_expend(q, widget.fm);

    if (!mounted) return;
    setState(() {
      query = q;
      listexpendfarm = exp;
    });
  }

  @override
  void initState() {
    super.initState();
    init();

    inputSearch.addListener(() {
      setState(() {
        _showClearButton = inputSearch.text.isNotEmpty;
        // ถ้า  inputsearch.text.length >0 จะเป็นทำให้ _showClearButton เป็น true
      });
    });
  }

  Future init() async {
    // cow
    final co = await search_cow(query, widget.fm);
    if (widget.cow != null) {
      final co = widget.cow!;
      setState(() {
        listcow = co;
      });
    } else {
      final listCo = await Cow_data().listMaincow_farm(widget.fm);
      setState(() {
        listcow = listCo;
      });
    }

    //employee
    final emp = await search_employee(query, widget.fm);
    final listEmp = await Employee_data().List_employee(widget.fm);
    //expenfarm
    final exp = await search_expend(query, widget.fm);
    final listexp = await Expend_data().ListExpend();

    setState(() {
      listemployee = emp;
      listemployee = listEmp;
      listexpendfarm = exp;
      listexpendfarm = listexp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        key: globalKey,
        drawer: MyWidget(fm: widget.fm),
        endDrawer: Drawer_Filter(
          fm: widget.fm,
          cow: listcow,
        ),
        body: listcow == null
            ? Column(children: const <Widget>[])
            : Container(
                child: Column(children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 50, left: 0, right: 20),
                    height: 210,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.green],
                        )),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "สวัสดี คุณ ",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: const Icon(FontAwesomeIcons.bell),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.fm.owner_name.toString(),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                              child: IconButton(
                                  iconSize: 35,
                                  onPressed: () {
                                    globalKey.currentState!.openDrawer();
                                  },
                                  icon: const Icon(FontAwesomeIcons.bars)),
                            ),
                            _search(_currentIndex),
                            _fitter(_currentIndex)
                          ],
                        ),
                      ],
                    ),
                  ),
                  mainpage(_currentIndex)
                ]),
              ),
        floatingActionButton: _button_add(_currentIndex),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          onItemSelected: (index) => setState(() => _currentIndex = index),
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: const Icon(
                FontAwesomeIcons.cow,
                color: Color(0XFF397D54),
                size: 20,
              ),
              title: const Text('ข้อมูลโค'),
              activeColor: const Color(0XFF397D54),
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(
                FontAwesomeIcons.userGroup,
                color: Color(0XFF397D54),
                size: 20,
              ),
              title: const Text('พนักงาน'),
              activeColor: const Color(0XFF397D54),
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(
                FontAwesomeIcons.moneyBill,
                color: Color(0XFF397D54),
                size: 20,
              ),
              title: const Text(
                'ค่าใช้จ่ายฟาร์ม',
              ),
              activeColor: const Color(0XFF397D54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  _search(int currentIndex) {
    String textInput = "";
    if (currentIndex == 0) {
      textInput = "ค้นหาข้อมูลโค";
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
          child: TextFormField(
            cursorColor: const Color.fromARGB(255, 0, 0, 0),
            controller: inputSearch,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 2, 50, 14),
                ),
              ),
              hintText: textInput,
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
      );
    } else if (currentIndex == 1) {
      textInput = "ค้นหาชื่อพนักงาน";
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
          child: TextFormField(
            cursorColor: const Color.fromARGB(255, 0, 0, 0),
            controller: inputSearch,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 2, 50, 14),
                ),
              ),
              hintText: textInput,
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
              suffixIcon: _getClearButton_emp(),
            ),
            onChanged: search_emp,
          ),
        ),
      );
    } else {
      textInput = "ค้นหาค่าใช้จ่าย";
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
          child: TextFormField(
            cursorColor: const Color.fromARGB(255, 0, 0, 0),
            controller: inputSearch,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 2, 50, 14),
                ),
              ),
              hintText: textInput,
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
              suffixIcon: _getClearButton_exp(),
            ),
            onChanged: search_exp,
          ),
        ),
      );
    }
  }

  mainpage(int currentIndex) {
    if (_currentIndex == 0) {
      return Expanded(
          child: Container(
              transform: Matrix4.translationValues(0.0, -10.0, 0.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listcow.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        color: (Colors.green),
                        child: ListTile(
                          leading: _buildLeadingTile(listcow[index]),
                          onTap: (() {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: ((context) {
                              return DetailCow(
                                cow: listcow[index],
                                fm: widget.fm,
                              );
                            })));
                          }),
                          trailing: PopupMenuButton(
                            onSelected: (result) {
                              if (result == 0) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditCow(
                                                cow: listcow[index],
                                                fm: widget.fm,
                                              )),
                                    );
                                  }
                                });
                              } else if (result == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddProgress(
                                            fm: widget.fm,
                                            cow: listcow[index],
                                          )),
                                );
                              } else if (result == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddFeedingcow(
                                            cow: listcow[index],
                                            fm: widget.fm,
                                          )),
                                );
                              } else if (result == 3) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddVaccine(
                                            fm: widget.fm,
                                            cow: listcow[index],
                                          )),
                                );
                              } else if (result == 4) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddHybridization(
                                            cow: listcow[index],
                                            fm: widget.fm,
                                          )),
                                );
                              }
                            },
                            iconSize: 40,
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem(
                                  value: 0,
                                  child: Text('แก้ไขข้อมูล'),
                                ),
                                const PopupMenuItem(
                                  value: 1,
                                  child: Text('เพิ่มข้อมูลพัฒนาการโค'),
                                ),
                                const PopupMenuItem(
                                  value: 2,
                                  child: Text('เพิ่มข้อมูลการให้อาหารโค'),
                                ),
                                const PopupMenuItem(
                                  value: 3,
                                  child: Text('เพิ่มข้อมูลการฉีดวัคซีน'),
                                ),
                                const PopupMenuItem(
                                  value: 4,
                                  child: Text('เพิ่มข้อมูลการผสมพันธุ์โค'),
                                )
                              ];
                            },
                          ),
                          title: Text("รหัสโค : ${listcow[index].cow_id!}",
                              style: const TextStyle(fontSize: 20),
                              overflow: TextOverflow.ellipsis),
                          subtitle: _birthdayCow(listcow[index]),
                          // isThreeLine: true,
                        ));
                  })));
    } else if (_currentIndex == 1) {
      return Expanded(
          child: Container(
              transform: Matrix4.translationValues(0.0, -10.0, 0.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listemployee.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      color: (Colors.green),
                      child: ListTile(
                        leading: _buildLeadingTile_user(listemployee[index]),
                        trailing: PopupMenuButton(
                          onSelected: (result) {
                            if (result == 0) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: ((context) {
                                return EditEmployee(
                                  e: listemployee[index],
                                  fm: widget.fm,
                                );
                              })));
                            } else {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                  title: Text('ลบข้อมูลพนักงาน  ' "\n" +
                                      listemployee[index].firstname.toString() +
                                      " " +
                                      listemployee[index].lastname.toString() +
                                      "\n ตำแหน่ง :" +
                                      listemployee[index].position.toString()),
                                  content: const Text(
                                      'เช็คข้อมูลการลบข้อมูลทุกครั้ง'),
                                  actions: <CupertinoDialogAction>[
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No'),
                                    ),
                                    CupertinoDialogAction(
                                      isDestructiveAction: true,
                                      onPressed: () async {
                                        final emp = Employee_data()
                                            .DeleteEmployee(
                                                listemployee[index].username);
                                        if (emp != 0) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          super.widget));
                                        }
                                      },
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          iconSize: 40,
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem(
                                value: 0,
                                child: Text('แก้ไขข้อมูล'),
                              ),
                              const PopupMenuItem(
                                value: 1,
                                child: Text('ลบข้อมูลพนักงาน'),
                              ),
                            ];
                          },
                        ),
                        title: Text(
                            "${listemployee[index].firstname!}  ${listemployee[index].lastname!}",
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis),
                        subtitle: _detail_emp(listemployee[index]),
                        // isThreeLine: true,
                      ));
                },
              )));
    } else {
      return Expanded(
          child: Container(
              transform: Matrix4.translationValues(0.0, -10.0, 0.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listexpendfarm.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      color: (Colors.green),
                      child: ListTile(
                        //leading: _buildLeadingTile_df(listcow[index]),
                        trailing: PopupMenuButton(
                          onSelected: (result) {
                            if (result == 0) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: ((context) {
                                return EditExpend(
                                  ex: listexpendfarm[index],
                                  fm: widget.fm,
                                );
                              })));
                            } else {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                  title: Text('ลบข้อมูลค่าใช้จ่าย  '
                                          "\n"
                                          "รหัสคำสั่งซื้อ : " +
                                      listexpendfarm[index].id_list.toString()),
                                  content: const Text(
                                      'เช็คข้อมูลการลบข้อมูลทุกครั้ง'),
                                  actions: <CupertinoDialogAction>[
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No'),
                                    ),
                                    CupertinoDialogAction(
                                      isDestructiveAction: true,
                                      onPressed: () async {
                                        final emp = Expend_data().DeleteExpend(
                                            listexpendfarm[index].id_list);
                                        if (emp != 0) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          super.widget));
                                        }
                                      },
                                      child: const Text('Yes'),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          iconSize: 40,
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem(
                                value: 0,
                                child: Text('แก้ไขค่าใช้จ่าย'),
                              ),
                              const PopupMenuItem(
                                value: 1,
                                child: Text('ลบข้อมูลค่าใช้จ่าย'),
                              ),
                            ];
                          },
                        ),
                        title: Text(
                            "รหัสคำสั่งซื้อ : ${listexpendfarm[index].id_list}",
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis),
                        subtitle: _expenseFarm_date(listexpendfarm[index]),
                        // isThreeLine: true,
                      ));
                },
              )));
    }
  }

  //fitter
  _fitter(currentIndex) {
    if (currentIndex == 0) {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 30, 8, 0),
        child: Row(
          children: [
            Builder(builder: (context) {
              return IconButton(
                  iconSize: 25,
                  onPressed: () {
                    globalKey.currentState!.openEndDrawer();
                  },
                  icon: const Icon(FontAwesomeIcons.filter));
            })
          ],
        ),
      );
    } else if (currentIndex == 1) {
      return Container();
    } else {
      return Container();
    }
  }

  _button_add(currentIndex) {
    if (currentIndex == 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return Register_Cow(fm: widget.fm);
            })));
          },
          label: const Text(
            "เพิ่มข้อมูล",
            style: TextStyle(color: Colors.black),
          ),
          icon: const Icon(
            FontAwesomeIcons.cow,
            color: Colors.green,
          ),
        ),
      );
    } else if (currentIndex == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return AddEmployee(fm: widget.fm);
            })));
          },
          label: const Text(
            "เพิ่มข้อมูล",
            style: TextStyle(color: Colors.black),
          ),
          icon: const Icon(
            FontAwesomeIcons.userGroup,
            color: Colors.green,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return AddExpend(fm: widget.fm);
            })));
          },
          label: const Text(
            "เพิ่มข้อมูล",
            style: TextStyle(color: Colors.black),
          ),
          icon: const Icon(
            FontAwesomeIcons.moneyBill,
            color: Colors.green,
          ),
        ),
      );
    }
  }

  _detail_emp(Employee listemployee) {
    return Text(
        "อีเมล : ${listemployee.email!}\nเบอร์ : ${listemployee.tel!}\nตำแหน่ง : ${listemployee.position!}",
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 12, 2, 2)));
  }

  Widget? _getClearButton() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton) {
      return null;
    }

    return GestureDetector(
        child: const Icon(
          Icons.close,
          color: Colors.green,
        ),
        onTap: () {
          inputSearch.clear();
          search("");
        });
  }

  Widget? _getClearButton_emp() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton) {
      return null;
    }

    return GestureDetector(
        child: const Icon(
          Icons.close,
          color: Colors.green,
        ),
        onTap: () {
          inputSearch.clear();
          search_emp("");
        });
  }

  Widget? _getClearButton_exp() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton) {
      return null;
    }

    return GestureDetector(
        child: const Icon(
          Icons.close,
          color: Colors.green,
        ),
        onTap: () {
          inputSearch.clear();
          search_exp("");
        });
  }
}

Widget _buildLeadingTile(Cow listcow) {
  return Container(
    width: 100,
    child: SizedBox(
      child: Image.network(
        listcow.picture.toString(),
        fit: BoxFit.fitWidth,
      ),
    ),
  );
}

Widget _buildLeadingTile_df(Cow listcow) {
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

Widget _buildLeadingTile_user(Employee listemp) {
  return Container(
    width: 81,
    height: 100,
    child: Image.asset(
      "images/user.jpg",
      width: 100,
      height: 100,
      fit: BoxFit.fitWidth,
    ),
  );
  return Container(
    width: 80.0,
    height: 200.0,
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/user.jpg'), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [BoxShadow(blurRadius: 5.0, color: Colors.black)]),
  );
}

image_cow(Cow c) {
  return Image.network(
    c.picture!,
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

  DateTime dateBirthday = DateTime(numY, numM + 1, numD);

  birthday = dateBirthday;
  duration = AgeCalculator.age(birthday);
//colors
  colros = cow.color!;
//name_species
  nameSpecies = cow.species!.species_breed!;
//gender
  gender = cow.gender!;

  return Text(
      "สายพันธุ์ :$nameSpecies\nเพศ :$gender  สี :$colros\nอายุ : $duration ",
      style:
          const TextStyle(fontSize: 16, color: Color.fromARGB(255, 12, 2, 2)));
}

_expenseFarm_date(Expendfarm expendfarm) {
  int textYear = 0;
  String textMonth = " ";
  String textDay = " ";

  DateTime birthday = DateTime.now();

//Age
  var numY = int.parse(expendfarm.expendFarmDate!.year.toString());
  textYear = numY + 543;

  var numM = int.parse(expendfarm.expendFarmDate!.month.toString());

  var numD = int.parse(expendfarm.expendFarmDate!.day.toString());

  DateTime dateBirthday = DateTime(numY + 543, numM, numD);
  var formatter = DateFormat('dd/MM/yyyy');
  String formattedDate = formatter.format(dateBirthday);
  if (expendfarm.expendType!.expendType_name.toString() == "อาหาร") {
    return Text(
        "ชื่อ :${expendfarm.name} ราคา : ${expendfarm.price} บาท \nจำนวน : ${expendfarm.amount} กิโลกรัม\nวันที่ซื้อ : $formattedDate\nประเภทสินค้า : ${expendfarm.expendType!.expendType_name}",
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 12, 2, 2)));
  } else {
    return Text(
        "ชื่อ :${expendfarm.name} ราคา : ${expendfarm.price} บาท \nจำนวน : ${expendfarm.amount} ขวด\nวันที่ซื้อ : $formattedDate\nประเภทสินค้า : ${expendfarm.expendType!.expendType_name}",
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 12, 2, 2)));
  }
}
