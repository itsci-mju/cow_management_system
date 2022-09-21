import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/mainfarm.dart';
import 'package:flutter/material.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddEmployee extends StatefulWidget {
  final Farm fm;
  const AddEmployee({
    Key? key,
    required this.fm,
  }) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  Employee emp = Employee();
  String? name_title = "";
  String? position = "";

  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  final tel = TextEditingController();

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
                          "เพิ่มข้อมูลพนักงาน ",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.5),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text("กรอกข้อมูลให้ถูกต้องก่อนเพิ่มข้อมูลพนักงาน")
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
                  items: ['นาง', 'นาย', 'นางสาว'].map((String value) {
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
                  decoration: const InputDecoration(
                    hintText: 'คำนำหน้า',
                    hintStyle: TextStyle(color: Colors.black),
                    icon: Icon(
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
                  items: ['หัวหน้าพนักงาน', 'พนักงาน'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      position = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'ตำแหน่ง',
                    hintStyle: TextStyle(color: Colors.black),
                    icon: Icon(
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
                  emp.position = position;
                  Farm idFarm = Farm(id_Farm: widget.fm.id_Farm);
                  emp.farm = idFarm;
                });

                final employee = Employee_data().RegisterEmployee(emp);

                if (employee != null) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return Mainfarm(
                      fm: widget.fm,
                    );
                  })));
                } else {
                  print("fail to upload");
                }
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                width: size.width * 0.97,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color:
                        const Color.fromARGB(255, 34, 120, 37).withAlpha(50)),
                alignment: Alignment.center,
                child: const Text('เพิ่มข้อมูลพนักงาน',
                    style: TextStyle(color: Color(0xff235d3a), fontSize: 18)),
              ),
            )
          ],
        )),
      ),
    );
  }
}
