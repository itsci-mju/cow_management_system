import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/url/URL.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailCow_guest extends StatefulWidget {
  final Cow cow;

  const DetailCow_guest({Key? key, required this.cow}) : super(key: key);

  @override
  State<DetailCow_guest> createState() => _DetailCow_guestState();
}

class _DetailCow_guestState extends State<DetailCow_guest> {
  List tabs = ["รายละเอียดโค"];
  int selectIndex = 0;

  Cow cow = Cow();

  late List<dynamic> list;
  Map? mapResponse;

  Future fetchnewcow(Cow cow) async {
    final Cowbreeder = cow.tobreeder();

    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Getcow.toString()),
      body: jsonEncode(Cowbreeder),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      dynamic breeder = mapResponse!['result'];

      return Cow.fromJson(breeder);
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    String gender = " ${cow.gender}";
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              widget.cow.picture == "-"
                  ? image_cow_df()
                  : image_cow(widget.cow),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                decoration: const BoxDecoration(
                    color: Color(0XFF397D54),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    )),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "รหัสประจำตัวโค : ${widget.cow.cow_id}",
                        style: const TextStyle(
                            fontSize: 28.0,
                            color: Color.fromARGB(255, 253, 253, 253),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: 400,
                      margin: const EdgeInsets.symmetric(horizontal: 32.0),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(136, 240, 236, 236),
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          tabs.length,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectIndex = index;
                              });
                            },
                            child: Container(
                              height: 48,
                              width: 300,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: selectIndex == index
                                      ? const Color.fromARGB(255, 29, 103, 31)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(28.0)),
                              child: Text(
                                tabs[index],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: selectIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    selectIndex == 0
                        ? Container(
                            height: 350,
                            width: 370,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 212, 248, 226),
                                borderRadius: BorderRadius.circular(24.0)),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        child: Text(
                                            "รหัสประจำตัวโค : ${widget.cow.cow_id}",
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                color: Color.fromARGB(
                                                    255, 12, 2, 2),
                                                fontWeight: FontWeight.w600))),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        child: Text(
                                      "ชื่อโค : ${widget.cow.namecow}",
                                      style: const TextStyle(
                                          fontSize: 20.0,
                                          color: Color.fromARGB(255, 12, 2, 2),
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "ชื่อฟาร์ม : ${widget.cow.farm!.name_Farm}",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "สายพันธุ์ : ${widget.cow.species!.species_breed}",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "ประเทศ : ${widget.cow.species!.country}",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "น้ำหนัก : ${widget.cow.weight} กิโลกรัม",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "ส่วนสูง : ${widget.cow.height} กิโลกรัม",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  _birthdayCow(widget.cow),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "สี : ${widget.cow.color} ||  เพศ : ${widget.cow.gender}  ",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Color.fromARGB(255, 12, 2, 2),
                                              fontWeight: FontWeight.w600))),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: 130,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.0)),
                            child: const Text(
                              "แก้ไข",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  image_cow(Cow c) {
    Size size = MediaQuery.of(context).size;

    return Stack(children: [
      Container(
        height: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [BoxShadow(color: Colors.black)]),
        child: Image.network(
          url.URL_IMAGE + c.picture.toString(),
          fit: BoxFit.fill,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 30, 0, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25,
                  )),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _AgeCow() {
    String b = widget.cow.birthday!.year.toString();
    var birthday = int.parse(b);
    DateTime now = DateTime.now();

    DateTime datenow = DateTime(now.year, now.month, now.day);
    int age = datenow.year - birthday;

    return Align(
        alignment: Alignment.centerLeft,
        child: Text("อายุ : $age เดือน",
            style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 12, 2, 2),
                fontWeight: FontWeight.w600)));
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
    colros = cow.color.toString();
//name_species
    nameSpecies = cow.species!.species_breed.toString();
//gender
    gender = cow.gender.toString();

    return Align(
        alignment: Alignment.centerLeft,
        child: Text("อายุ : $duration",
            style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 12, 2, 2),
                fontWeight: FontWeight.w600)));
  }
}
