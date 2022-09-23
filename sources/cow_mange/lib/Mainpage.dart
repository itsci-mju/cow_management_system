import 'package:cow_mange/AddFeedingcow.dart';
import 'package:cow_mange/AddHybridization.dart';
import 'package:cow_mange/AddProgresscow.dart';
import 'package:cow_mange/AddVaccine.dart';
import 'package:cow_mange/Editcow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:cow_mange/DetailCow.dart';
import 'package:cow_mange/Drawer/Drawer_Filter.dart';
import 'package:cow_mange/Drawer/hamberg.dart';
import 'package:cow_mange/Register_cow.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';

import 'package:age_calculator/age_calculator.dart';

class MainpageEmployee extends StatefulWidget {
  final Employee? emp;
  final List<Cow> cow;

  const MainpageEmployee({
    Key? key,
    this.emp,
    required this.cow,
  }) : super(key: key);

  @override
  State<MainpageEmployee> createState() => MainpageEmployeeState();
}

class MainpageEmployeeState extends State<MainpageEmployee> {
  //map database
  late List<dynamic> list;
  Map? mapResponse;

  // query
  String query = "";

  //ขนาด size ของหน้าจอ
  late final Size size;

/*
  Future fetchCow(String query) async {
    final response = await http.post(
        Uri.parse('http://10.0.1.21:8081/project_cowmanage/cow/listmaincow'));

    if (response.statusCode == 200) {
      // วิธีที่ 1
      mapResponse = json.decode(response.body);
      print(mapResponse);
      list = mapResponse?['result'];

      return list.map((e) => Cow.fromJson(e)).where((Cow) {
        final text = Cow.namecow.toString();
        final textquery = query.toString();
        return text.contains(textquery);
      }).toList();

/*   วิธีที่ 2 
      List<Employee> e = [];
      for (dynamic listemployee in list) {
        if (Employee.fromJson(listemployee)
            .employee_username!
            .contains(query)) {
          e.add(Employee.fromJson(listemployee));
        }
      }
      return e;
      */
    } else {
      throw Exception('Failed to load album');
    }
  }
  */

  List<Cow> listcow = [];

  Future Listcow(String query) async {
    listcow = [];
    for (int i = 0; i < widget.cow.length; i++) {
      if (widget.cow[i].cow_id
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())) {
        listcow.add(widget.cow[i]);
      }
    }
    return listcow;
  }

  Future search(String q) async {
    final co = await Listcow(q);

    if (!mounted) return;
    setState(() {
      query = q;
      listcow = co;
    });
  }

  @override
  void initState() {
    super.initState();
    search(query);

    inputSearch.addListener(() {
      setState(() {
        _showClearButton = inputSearch.text.isNotEmpty;
        // ถ้า  inputsearch.text.length >0 จะเป็นทำให้ _showClearButton เป็น true
      });
    });
  }

  final inputSearch = TextEditingController();
  bool _showClearButton = false;
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String idFarm = widget.emp!.farm!.id_Farm.toString();
    Size size = MediaQuery.of(context).size;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: globalKey,
      drawer: MyWidget(
        emp: widget.emp,
      ),
      endDrawer: Drawer_Filter(
        emp: widget.emp!,
        cow: listcow,
      ),
      body: listcow == null
          ? Column(children: const <Widget>[])
          : Column(children: <Widget>[
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
                                "สวัสดี ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: const Icon(FontAwesomeIcons.bell),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${widget.emp!.firstname} ${widget.emp!.lastname}",
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
                        Expanded(
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
                                hintText: "ค้นหาข้อมูลโค",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
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
                                    iconSize: 25,
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
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listcow.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (listcow[index].picture == "-") {
                            return Card(
                                color: (Colors.green),
                                child: ListTile(
                                  leading: _buildLeadingTile_df(listcow[index]),
                                  onTap: (() {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: ((context) {
                                      return DetailCow(
                                        cow: listcow[index],
                                        emp: widget.emp,
                                      );
                                    })));
                                  }),
                                  trailing: PopupMenuButton(
                                    onSelected: (result) {
                                      if (result == 0) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditCow(
                                                    cow: listcow[index],
                                                    emp: widget.emp,
                                                  )),
                                        );
                                      } else if (result == 1) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddProgress(
                                                    emp: widget.emp,
                                                    cow: listcow[index],
                                                  )),
                                        );
                                      } else if (result == 2) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddFeedingcow(
                                                    cow: listcow[index],
                                                    emp: widget.emp,
                                                  )),
                                        );
                                      } else if (result == 3) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddVaccine(
                                                    emp: widget.emp,
                                                    cow: listcow[index],
                                                  )),
                                        );
                                      } else if (result == 4) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddHybridization(
                                                    cow: listcow[index],
                                                    emp: widget.emp,
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
                                          child:
                                              Text('เพิ่มข้อมูลการให้อาหารโค'),
                                        ),
                                        const PopupMenuItem(
                                          value: 3,
                                          child:
                                              Text('เพิ่มข้อมูลการฉีดวัคซีน'),
                                        ),
                                        const PopupMenuItem(
                                          value: 4,
                                          child:
                                              Text('เพิ่มข้อมูลการผสมพันธุ์โค'),
                                        )
                                      ];
                                    },
                                  ),
                                  title: Text(
                                      "รหัสโค : ${listcow[index].cow_id}",
                                      style: const TextStyle(fontSize: 20),
                                      overflow: TextOverflow.ellipsis),
                                  subtitle: _birthdayCow(widget.cow[index]),
                                  // isThreeLine: true,
                                ));
                          } else {
                            return Card(
                                color: (Colors.green),
                                child: ListTile(
                                  leading: _buildLeadingTile(listcow[index]),
                                  onTap: (() {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: ((context) {
                                      return DetailCow(
                                        cow: listcow[index],
                                        emp: widget.emp,
                                      );
                                    })));
                                  }),
                                  trailing: PopupMenuButton(
                                    onSelected: (result) {
                                      if (result == 0) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditCow(
                                                    cow: listcow[index],
                                                    emp: widget.emp,
                                                  )),
                                        );
                                      } else if (result == 1) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddProgress(
                                                    emp: widget.emp,
                                                    cow: listcow[index],
                                                  )),
                                        );
                                      } else if (result == 2) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddFeedingcow(
                                                    cow: listcow[index],
                                                    emp: widget.emp,
                                                  )),
                                        );
                                      } else if (result == 3) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddVaccine(
                                                    emp: widget.emp,
                                                    cow: listcow[index],
                                                  )),
                                        );
                                      } else if (result == 4) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddHybridization(
                                                    cow: listcow[index],
                                                    emp: widget.emp,
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
                                          child:
                                              Text('เพิ่มข้อมูลการให้อาหารโค'),
                                        ),
                                        const PopupMenuItem(
                                          value: 3,
                                          child:
                                              Text('เพิ่มข้อมูลการฉีดวัคซีน'),
                                        ),
                                        const PopupMenuItem(
                                          value: 4,
                                          child:
                                              Text('เพิ่มข้อมูลการผสมพันธุ์โค'),
                                        )
                                      ];
                                    },
                                  ),
                                  title: Text(
                                      "รหัสโค : ${listcow[index].cow_id}",
                                      style: const TextStyle(fontSize: 20),
                                      overflow: TextOverflow.ellipsis),
                                  subtitle: _birthdayCow(widget.cow[index]),
                                  // isThreeLine: true,
                                ));
                          }
                        },
                      )))
            ]),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return Register_Cow(
                emp: widget.emp,
              );
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
      ),
      /*
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,*/
    );
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
        "สายพันธุ์ :$nameSpecies\nเพศ :$gender  สี :$colros\nอายุ : $duration ",
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 12, 2, 2)));
  }
}
