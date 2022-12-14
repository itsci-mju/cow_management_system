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
import 'package:cow_mange/class/Progress.dart';
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
  double price_sum = 0.00;

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
      body: jsonEncode({"Farm_id_Farm": farm.id_Farm}),
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

  Future sum_price(Farm farm) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_sum_price),
      body: jsonEncode({"Farm_id_Farm": farm.id_Farm}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List? list;
      double d = 0.0;
      Map<String, dynamic> mapResponse = json.decode(response.body);

      mapResponse = json.decode(response.body);

      d = mapResponse['result'];

      return d;
    }
  }

  @override
  void initState() {
    super.initState();
    init();

    inputSearch.addListener(() {
      setState(() {
        _showClearButton = inputSearch.text.isNotEmpty;
        // ?????????  inputsearch.text.length >0 ????????????????????????????????? _showClearButton ???????????? true
      });
    });
  }

  Future init() async {
    final sum = await sum_price(widget.fm);
    setState(() {
      price_sum = sum;
    });
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
    final listexp = await Expend_data().ListExpend_idfarm(widget.fm.id_Farm);

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
        resizeToAvoidBottomInset: false,
        drawer: MyWidget(fm: widget.fm),
        endDrawer: Drawer_Filter(
          fm: widget.fm,
          cow: listcow,
        ),
        backgroundColor: Color.fromARGB(255, 223, 224, 226),
        body: listcow == null
            ? Column(children: const <Widget>[])
            : Column(children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 50, left: 0, right: 20),
                  height: 220,
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
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "?????????????????? ${widget.fm.owner_name.toString()}",
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
                            "??????????????????????????? : ${widget.fm.name_Farm} ",
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
                if (_currentIndex == 2)
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "?????????????????????????????????????????? : " +
                                    price_sum.toString() +
                                    " ?????????",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    height: 20,
                  ),
                mainpage(_currentIndex)
              ]),
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
              title: const Text('????????????????????????'),
              activeColor: const Color(0XFF397D54),
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(
                FontAwesomeIcons.userGroup,
                color: Color(0XFF397D54),
                size: 20,
              ),
              title: const Text('?????????????????????'),
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
                '?????????????????????????????????????????????',
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
      textInput = "??????????????????????????????????????????????????? ??????????????????";
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
      textInput = "????????????????????????????????????????????????";
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
      textInput = "?????????????????????????????????????????????";
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
                    return Check_Weight(co: listcow[index], fm: widget.fm);
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
                      elevation: 5,
                      color: (Color.fromARGB(255, 255, 255, 255)),
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
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
                                  title: Text('????????????????????????????????????????????????????????????????????????  '
                                          "\n" +
                                      listemployee[index].firstname.toString() +
                                      " " +
                                      listemployee[index].lastname.toString() +
                                      "\n ????????????????????? :" +
                                      listemployee[index].position.toString()),
                                  content: const Text(
                                      '???????????????????????????????????????????????????????????????????????????????????????'),
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
                                child: Text('?????????????????????????????????'),
                              ),
                              const PopupMenuItem(
                                value: 1,
                                child: Text('?????????????????????????????????????????????'),
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
      return

          /*
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "?????????????????????????????????????????? : " + price_sum.toString() + " ?????????",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
            ],
          ),*/

          Expanded(
        child: Container(
            transform: Matrix4.translationValues(0.0, -10.0, 0.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listexpendfarm.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    elevation: 5,
                    color: (Color.fromARGB(255, 255, 255, 255)),
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
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
                                title: Text('?????????????????????????????????????????????????????????????????????????????????  '
                                        "\n"
                                        "?????????????????????????????????????????? : " +
                                    listexpendfarm[index].id_list.toString()),
                                content:
                                    const Text('???????????????????????????????????????????????????????????????????????????????????????'),
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
                              child: Text('?????????????????????????????????????????????'),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Text('??????????????????????????????????????????????????????'),
                            ),
                          ];
                        },
                      ),
                      title: Text(
                          "?????????????????????????????????????????? : ${listexpendfarm[index].id_list}",
                          style: const TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis),
                      subtitle: _expenseFarm_date(listexpendfarm[index]),
                      // isThreeLine: true,
                    ));
              },
            )),
      );
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
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return Register_Cow(fm: widget.fm);
            })));
          },
          label: const Text(
            "?????????????????????????????????",
            style: TextStyle(color: Colors.black),
          ),
          icon: const Icon(
            FontAwesomeIcons.cow,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      );
    } else if (currentIndex == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return AddEmployee(fm: widget.fm);
            })));
          },
          label: const Text(
            "?????????????????????????????????",
            style: TextStyle(color: Colors.black),
          ),
          icon: const Icon(
            FontAwesomeIcons.userGroup,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return AddExpend(fm: widget.fm);
            })));
          },
          label: const Text(
            "?????????????????????????????????",
            style: TextStyle(color: Colors.black),
          ),
          icon: const Icon(
            FontAwesomeIcons.moneyBill,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      );
    }
  }

  _detail_emp(Employee listemployee) {
    return Text(
        "??????????????? : ${listemployee.email!}\n??????????????? : ${listemployee.tel!}\n????????????????????? : ${listemployee.position!}",
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 12, 2, 2)));
  }

  Widget? _getClearButton() {
    // ?????????????????????????????????????????? return null
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
    // ?????????????????????????????????????????? return null
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
    // ?????????????????????????????????????????? return null
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
        url.URL_IMAGE + listcow.picture.toString(),
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
}

image_cow(Cow c) {
  return Image.network(
    url.URL_IMAGE + c.picture!,
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
      "?????????????????? :$nameSpecies\n????????? :$gender  ?????? :$colros\n???????????? : $duration ",
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
  if (expendfarm.expendType!.expendType_name.toString() == "???????????????") {
    return Text(
        "???????????? :${expendfarm.name} ???????????? : ${expendfarm.price} ????????? \n?????????????????? : ${expendfarm.amount} ????????????????????????\n?????????????????????????????? : $formattedDate\n???????????????????????????????????? : ${expendfarm.expendType!.expendType_name}",
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 12, 2, 2)));
  } else {
    return Text(
        "???????????? :${expendfarm.name} ???????????? : ${expendfarm.price} ????????? \n?????????????????? : ${expendfarm.amount} ?????????\n?????????????????????????????? : $formattedDate\n???????????????????????????????????? : ${expendfarm.expendType!.expendType_name}",
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 12, 2, 2)));
  }
}

class Check_Weight extends StatefulWidget {
  Cow? co;
  Farm? fm;
  Check_Weight({required this.co, required this.fm});

  @override
  State<Check_Weight> createState() => _Check_WeightState();
}

class _Check_WeightState extends State<Check_Weight> {
  List<Progress> Listprogress = [];

  // query

  //weight
  double doubleWeight = 0;
  List<double> weight = [];

  Future ch_weight() async {
    final list_Pg = await Progress_data().listMainprogress(widget.co!.cow_id);
    Listprogress = list_Pg;
    for (int i = 0; i < Listprogress.length; i++) {
      setState(() {
        weight.add(Listprogress[i].weight!.toDouble());
      });
    }

    if (weight.isNotEmpty) {
      double w = 0.00;

      weight.sort();
      w = weight[weight.length - 1];
      if (w < 100) {
        setState(() {
          doubleWeight = widget.co!.weight!.toDouble();
        });
      } else {
        setState(() {
          doubleWeight = weight[weight.length - 1];
        });
      }
    } else {
      setState(() {
        doubleWeight = widget.co!.weight!.toDouble();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ch_weight();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        color: (Color.fromARGB(255, 255, 255, 255)),
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: ListTile(
          leading: _buildLeadingTile(widget.co!),
          onTap: (() {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return DetailCow(
                cow: widget.co!,
                fm: widget.fm,
              );
            })));
          }),
          trailing: PopupMenuButton(
              onSelected: (result) async {
                if (result == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditCow(
                              fm: widget.fm,
                              cow: widget.co!,
                            )),
                  );
                } else if (result == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProgress(
                              fm: widget.fm,
                              cow: widget.co!,
                            )),
                  );
                } else if (result == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddFeedingcow(
                              fm: widget.fm,
                              cow: widget.co!,
                            )),
                  );
                } else if (result == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddVaccine(
                              fm: widget.fm,
                              cow: widget.co!,
                            )),
                  );
                } else if (result == 4) {
                  final list_Pg =
                      await Progress_data().listMainprogress(widget.co!.cow_id);
                  Listprogress = list_Pg;
                  for (int i = 0; i < Listprogress.length; i++) {
                    setState(() {
                      weight.add(Listprogress[i].weight!.toDouble());
                    });
                  }

                  if (weight.isNotEmpty) {
                    weight.sort();
                    setState(() {
                      doubleWeight = weight[weight.length - 1];
                    });
                  } else {
                    setState(() {
                      doubleWeight = widget.co!.weight!.toDouble();
                    });
                  }

                  if (doubleWeight >= 100) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddHybridization(
                                cow: widget.co!,
                                fm: widget.fm,
                              )),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                  "???????????????????????????????????????????????????${doubleWeight}????????????????????????"),
                              content: Text(
                                  "?????????????????????????????????????????????????????????????????????????????????????????????????????????????????? 100-150 ??????????????????????????????????????????"),
                            ));
                  }
                }
              },
              iconSize: 40,
              itemBuilder: (BuildContext context) {
                if (doubleWeight >= 100) {
                  return [
                    const PopupMenuItem(
                      value: 0,
                      child: Text('?????????????????????????????????'),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: Text('???????????????????????????????????????????????????????????????'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('????????????????????????????????????????????????????????????????????????'),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text('?????????????????????????????????????????????????????????????????????'),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: Text('???????????????????????????????????????????????????????????????????????????'),
                    )
                  ];
                } else {
                  return [
                    const PopupMenuItem(
                      value: 0,
                      child: Text('?????????????????????????????????'),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: Text('???????????????????????????????????????????????????????????????'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('????????????????????????????????????????????????????????????????????????'),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text('?????????????????????????????????????????????????????????????????????'),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: Text('???????????????????????????????????????????????????????????????????????????'),
                      enabled: false,
                    )
                  ];
                }
              }),
          title: Text("?????????????????? : ${widget.co!.cow_id}",
              style: const TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis),
          subtitle: _birthdayCow(widget.co!),
          // isThreeLine: true,
        ));
  }

  Widget _buildLeadingTile(Cow listcow) {
    return Container(
      width: 100,
      child: SizedBox(
        child: Image.network(
          url.URL_IMAGE + listcow.picture.toString(),
          fit: BoxFit.fitWidth,
        ),
      ),
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

    var numM = int.parse(cow.birthday!.month.toString());

    var numD = int.parse(cow.birthday!.day.toString());

    DateTime dateBirthday = DateTime(numY, numM, numD);

//colors
    colros = cow.color.toString();
//name_species
    nameSpecies = cow.species!.species_breed.toString();
//gender
    gender = cow.gender.toString();

    duration = AgeCalculator.age(dateBirthday);

    return Text(
        "?????????????????? :$nameSpecies\n????????? :$gender  ?????? :$colros\n???????????? : $duration ",
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 12, 2, 2)));
  }
}
