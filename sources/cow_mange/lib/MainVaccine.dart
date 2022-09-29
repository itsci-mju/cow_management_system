import 'package:cow_mange/ListVaccination.dart';
import 'package:cow_mange/Mainpage.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainVaccine extends StatefulWidget {
  final Employee? emp;
  final List<Cow> cow;
  const MainVaccine({Key? key, required this.cow, this.emp}) : super(key: key);

  @override
  State<MainVaccine> createState() => _MainVaccineState();
}

class _MainVaccineState extends State<MainVaccine> {
  String query = "";
  List<Cow> listcow = [];

  bool _showClearButton = false;
  final globalKey = GlobalKey<ScaffoldState>();
  final inputSearch = TextEditingController();

  Future Listcow(String query) async {
    listcow = [];
    for (int i = 0; i < widget.cow.length; i++) {
      if (widget.cow[i].cow_id.toString().contains(query)) {
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      /*
      endDrawer: Drawer_Filter_Progress(
        emp: widget.emp!,
        cow: widget.cow,
      ),*/
      body: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return MainpageEmployee(
                      emp: widget.emp,
                      cow: const [],
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
            const Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 0, 0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "ข้อมูลวัคซีนโค",
                    style: TextStyle(fontSize: 25),
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
                  itemCount: listcow.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: Card(
                            color: (Colors.green),
                            child: ListTile(
                              leading: _buildLeadingTile(),
                              onTap: (() {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: ((context) {
                                  return ListVaccination(
                                    cow: listcow[index],
                                    emp: widget.emp,
                                  );
                                })));
                              }),
                              title: Text(
                                "รหัสประจำตัวโค : ${listcow[index].cow_id}",
                                style: const TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                  "สายพันธุ์ :${listcow[index].species!.species_breed}\nเพศ :${listcow[index].gender}    สี :${listcow[index].color}",
                                  style: const TextStyle(fontSize: 17)),
                              isThreeLine: true,
                            )));
                  },
                )))
      ]),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {
            /*
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              
              return AddVaccine(cow: listcow, emp: widget.emp);
              
            })));*/
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
}

Widget _buildLeadingTile() {
  return Container(
    padding: const EdgeInsets.only(right: 10.0),
    width: 80,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
        border: Border(right: BorderSide(width: 1.0, color: Colors.black))),
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
