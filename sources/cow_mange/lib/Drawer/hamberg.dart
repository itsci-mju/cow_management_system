import 'dart:convert';

import 'package:cow_mange/mainfarm.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:cow_mange/Mainpage.dart';
import 'package:cow_mange/Mainpageguest.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/url/URL.dart';

class MyWidget extends StatefulWidget {
  final Employee? emp;
  final Farm? fm;
  const MyWidget({
    Key? key,
    this.emp,
    this.fm,
  }) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<Cow> cow = [];
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
    if (widget.emp != null) {
      final co = await listMaincow(widget.emp!);
      setState(() {
        cow = co;
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[buildHeader(context), buildMain(context)],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      color: Colors.green,
      width: 500,
      padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 52,
            child: Image.asset("images/cow-01.png"),
          ),
          const SizedBox(
            height: 12,
          ),
          widget.emp != null
              ? Text(
                  "${widget.emp!.firstname} ${widget.emp!.lastname}",
                  style: const TextStyle(fontSize: 20),
                )
              : Text(
                  widget.fm!.owner_name.toString(),
                  style: const TextStyle(fontSize: 20),
                )
        ],
      ),
    );
  }

  Widget buildMain(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home, color: Color(0XFF397D54)),
            title: const Text("หน้าหลัก"),
            onTap: () {
              if (widget.emp != null) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: ((context) {
                  return MainpageEmployee(
                    emp: widget.emp,
                    cow: cow,
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
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.rightFromBracket,
              color: Color(0XFF397D54),
              size: 20,
            ),
            title: const Text("ออกจากระบบ"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Mainguest()),
              );
            },
          )
        ],
      ),
    );
  }

  TextTitle(Employee e, Farm f) {
    if (e == null) {
      return const Text("1");
    } else {
      return Text(
        "${widget.emp!.firstname} ${widget.emp!.lastname}",
        style: const TextStyle(fontSize: 20),
      );
    }
  }
}
