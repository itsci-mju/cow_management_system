import 'dart:convert';

import 'package:cow_mange/DetailCow_guest.dart';
import 'package:cow_mange/Drawer/Drawer_Filter.dart';
import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/Drawer/hamberg_guest.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cow_mange/url/URL.dart';

class Mainguest extends StatefulWidget {
  const Mainguest({Key? key}) : super(key: key);

  @override
  State<Mainguest> createState() => _MainguestState();
}

class _MainguestState extends State<Mainguest> {
  //list
  List<Cow> listcow = [];
  List<Farm> listfarm = [];

  // query
  String query = "";

  final globalKey = GlobalKey<ScaffoldState>();
  final inputSearch = TextEditingController();
  bool _showClearButton = false;

  Future search_cow(String query) async {
    final response =
        await http.post(Uri.parse(url.URL.toString() + url.URL_ListAllcow));

    if (response.statusCode == 200) {
      List? list;
      Map<String, dynamic> mapResponse = json.decode(response.body);

      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Cow.fromJson(e)).where((Cow) {
        final textId = Cow.cow_id;
        final textNamefarm = Cow.farm!.name_Farm;
        final textquery = query;

        return textId!.toLowerCase().contains(textquery.toLowerCase()) ||
            textNamefarm!.toLowerCase().contains(textquery.toLowerCase());
      }).toList();
    }
  }

  Future search(String q) async {
    final co = await search_cow(q);
    if (!mounted) return;

    setState(() {
      query = q;
      listcow = co;
    });
  }

  Future init() async {
    final co = await search_cow(query);
    final listFm = await Farm_data().ListFarm();

    setState(() {
      listcow = co;
      listfarm = listFm;
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

  @override
  Widget build(BuildContext context) {
    print(listcow);
    return Scaffold(
      key: globalKey,
      endDrawer: Drawer_Filter(
        cow: listcow,
      ),
      drawer: const hamberg_guest(),
      body: listcow == null
          ? Column(children: const <Widget>[])
          : Column(children: <Widget>[
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
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                      child: TextFormField(
                        cursorColor: const Color.fromARGB(255, 0, 0, 0),
                        controller: inputSearch,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 8, 96, 12)),
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 8, 167, 48),
                            ),
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
                  /*
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 30, 8, 0),
                    child: Row(
                      children: [
                        Builder(builder: (context) {
                          return IconButton(
                              iconSize: 28,
                              onPressed: () {
                                globalKey.currentState!.openEndDrawer();
                              },
                              icon: Icon(FontAwesomeIcons.filter));
                        })
                      ],
                    ),
                  ),*/
                ],
              ),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listfarm.length,
                        itemBuilder: (BuildContext context, int k) {
                          int status = 0;
                          return Container(
                            child: Column(children: [
                              ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listcow.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (listcow[index].farm!.id_Farm ==
                                      listfarm[k].id_Farm) {
                                    status = status + 1;

                                    return Container(
                                      child: Column(
                                        children: [
                                          if (status == 1)
                                            ListTile(
                                                title: Text(
                                                    listfarm[k]
                                                        .name_Farm
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 20))),
                                          Container(
                                            child: Card(
                                                color: (Color.fromARGB(
                                                    255, 37, 202, 62)),
                                                child: ListTile(
                                                  leading: _buildLeadingTile(
                                                      listcow[index].picture),
                                                  onTap: (() {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                ((context) {
                                                      return DetailCow_guest(
                                                          cow: listcow[index]);
                                                    })));
                                                  }),
                                                  title: Text(
                                                    "รหัสโค : ${listcow[index].cow_id}",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Text(
                                                      "สายพันธุ์ :${listcow[index].species!.species_breed}\nเพศ :${listcow[index].gender}  || ชื่อฟาร์ม :${listcow[index].farm!.name_Farm}",
                                                      style: TextStyle(
                                                          fontSize: 17)),
                                                  isThreeLine: true,
                                                )),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              )
                            ]),
                          );
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

  Widget _buildLeadingTile(String? picture) {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(picture.toString()),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
