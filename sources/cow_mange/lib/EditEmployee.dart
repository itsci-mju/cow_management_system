import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/mainfarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditEmployee extends StatefulWidget {
  final Farm fm;
  final Employee e;
  const EditEmployee({
    Key? key,
    required this.fm,
    required this.e,
  }) : super(key: key);

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  Employee emp = Employee();
  String? name_title = "";
  String? text_position = "";
  List<String>? list_text_position = [];
  List<String>? list_name_title = [];

  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  final tel = TextEditingController();
  String name = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      lastname.text = widget.e.lastname.toString();
      username.text = widget.e.username.toString();
      password.text = widget.e.password.toString();
      email.text = widget.e.email.toString();
      tel.text = widget.e.tel.toString();
      text_position = widget.e.position.toString();

      name_title = widget.e.firstname.toString();

      final title = name_title!.substring(0, 3);

      if (name_title!.substring(0, 3) == "นาย") {
        name_title = "นาย";
        firstname.text = widget.e.firstname!.substring(3);
      } else if (name_title!.length > 5) {
        if (name_title!.substring(0, 6) == "นางสาว") {
          name_title = "นางสาว";
          firstname.text = widget.e.firstname!.substring(6);
        } else {
          name_title = "นาง";
          firstname.text = widget.e.firstname!.substring(3);
        }
      } else {
        name_title = "นาง";
        firstname.text = widget.e.firstname!.substring(3);
      }

      list_name_title = ["นาย", "นาง", "นางสาว"];

      list_text_position = ["พนักงาน", "หัวหน้าพนักงาน"];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 60, 0, 0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 30,
                        )),
                  ),
                  SizedBox(
                    child: Column(
                      children: const [
                        Text(
                          "แก้ไขข้อมูลพนักงาน ",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.5),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text("กรอกข้อมูลให้ถูกต้องก่อนแก้ไขข้อมูลพนักงาน")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.93,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: Column(children: [
                DropdownButtonFormField(
                  items: list_name_title!.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      name_title = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: name_title,
                    hintStyle: const TextStyle(color: Colors.black),
                    icon: const Icon(
                      FontAwesomeIcons.venusMars,
                      color: Color(0XFF397D54),
                      size: 20,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ]),
            ),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextField(
                      controller: firstname,
                      decoration: const InputDecoration(
                          label: Text("ชื่อ"),
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.user,
                            color: Color(0XFF397D54),
                            size: 20,
                          )),
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextField(
                      controller: lastname,
                      decoration: const InputDecoration(
                          label: Text("นามสกุล"),
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.user,
                            color: Color(0XFF397D54),
                            size: 20,
                          )),
                    )),
              ],
            ),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextField(
                      controller: username,
                      decoration: const InputDecoration(
                          label: Text("ชื่อผู้ใช้"),
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.userLarge,
                            color: Color(0XFF397D54),
                            size: 20,
                          )),
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen.withAlpha(50)),
                    child: TextField(
                      controller: password,
                      decoration: const InputDecoration(
                          label: Text("รหัสผู้ใช้"),
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.unlock,
                            color: Color(0XFF397D54),
                            size: 20,
                          )),
                    )),
              ],
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.93,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.lightGreen.withAlpha(50)),
                child: TextField(
                  controller: email,
                  decoration: const InputDecoration(
                      label: Text("อีเมล์"),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.squareEnvelope,
                        color: Color(0XFF397D54),
                        size: 20,
                      )),
                )),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.93,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.lightGreen.withAlpha(50)),
                child: TextField(
                  controller: tel,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                    MaskedInputFormatter('###-###-####')
                  ],
                  decoration: const InputDecoration(
                      label: Text("เบอร์โทร"),
                      hintStyle: TextStyle(color: Colors.black),
                      //suffixIcon: _getClearButton_weight(),
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.phone,
                        color: Color(0XFF397D54),
                        size: 20,
                      )),
                )),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.93,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightGreen.withAlpha(50)),
              child: Column(children: [
                DropdownButtonFormField(
                  items: list_text_position!.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      text_position = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: text_position,
                    hintStyle: const TextStyle(color: Colors.black),
                    icon: const Icon(
                      FontAwesomeIcons.userTie,
                      color: Color(0XFF397D54),
                      size: 20,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                setState(() {
                  emp.username = username.text;
                  emp.password = password.text;
                  String firstnameTitle = name_title! + firstname.text;
                  emp.firstname = firstnameTitle;
                  emp.lastname = lastname.text;
                  emp.email = email.text;
                  emp.tel = tel.text;
                  emp.position = text_position;
                  Farm idFarm = Farm(id_Farm: widget.fm.id_Farm);
                  emp.farm = idFarm;
                });

                final employee = Employee_data().EditEmployee(emp);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: ((context) {
                  return Mainfarm(
                    fm: widget.fm,
                  );
                })));
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                width: size.width * 0.97,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 34, 120, 37).withAlpha(50)),
                alignment: Alignment.center,
                child: const Text('แก้ไขข้อมูลพนักงาน',
                    style: TextStyle(color: Color(0xff235d3a), fontSize: 18)),
              ),
            )
          ],
        )),
      ),
    );
  }
}