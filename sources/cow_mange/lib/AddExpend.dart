import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/ExpendType.dart';
import 'package:cow_mange/class/Expendfarm.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/mainfarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AddExpend extends StatefulWidget {
  final Farm? fm;
  const AddExpend({Key? key, required this.fm}) : super(key: key);

  @override
  State<AddExpend> createState() => _AddExpendState();
}

class _AddExpendState extends State<AddExpend> {
  DateTime? expendFarmDate;
  Expendfarm exd_f = Expendfarm();
  final expendDate = TextEditingController();
  final name = TextEditingController();
  final amount = TextEditingController();
  final price = TextEditingController();
  List<ExpendType> list_exp = [];

  List<String> list_exp_name = [];
  String? category = "";

  Future init() async {
    final exp = await ExpendType_data().listExpendType();
    setState(() {
      list_exp_name = exp;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
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
                          "เพิ่มข้อมูลค่าใช้จ่ายฟาร์ม ",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.5),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                            "กรอกข้อมูลให้ถูกต้องก่อนเพิ่มข้อมูลค่าใช้จ่ายฟาร์ม")
                      ],
                    ),
                  ),
                ],
              ),
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
                  controller: expendDate,
                  readOnly: true,
                  decoration: const InputDecoration(
                      label: Text(
                        "เลือกวันที่ซื้อสินค้า",
                        style: TextStyle(color: Colors.black),
                      ),
                      hintText: "Date is not selected",
                      //suffixIcon: _getClearButton_date(),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.calendar,
                        color: Color(0XFF397D54),
                        size: 20,
                      )),
                  onTap: () async {
                    expendFarmDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));

                    if (expendFarmDate != null) {
                      DateTime d = DateTime(expendFarmDate!.year + 543,
                          expendFarmDate!.month, expendFarmDate!.day);

                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(d);

                      setState(() {
                        expendDate.text = formattedDate;
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
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
                  controller: name,
                  decoration: const InputDecoration(
                      label: Text("ชื่อ"),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.font,
                        color: Color(0XFF397D54),
                        size: 20,
                      )),
                )),
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
                      controller: amount,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                        MaskedInputFormatter('#########')
                      ],
                      decoration: const InputDecoration(
                          label: Text("จำนวน"),
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.listNumeric,
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
                      controller: price,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                        MaskedInputFormatter('##########')
                      ],
                      decoration: const InputDecoration(
                          label: Text("ราคา"),
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.dollarSign,
                            color: Color(0XFF397D54),
                            size: 20,
                          )),
                    )),
              ],
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
                  items: list_exp_name.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      category = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'ประเภท',
                    hintStyle: TextStyle(color: Colors.black),
                    icon: Icon(
                      FontAwesomeIcons.bowlFood,
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
                  exd_f.expendFarmDate = expendFarmDate;
                  exd_f.name = name.text;
                  exd_f.amount = int.parse(amount.text);
                  exd_f.price = double.parse(price.text);
                  exd_f.expendType =
                      ExpendType.expendType_name(expendType_name: category);
                  exd_f.farm = Farm.Newid_farm(id_Farm: widget.fm!.id_Farm);
                });
                final exd = Expend_data().AddExpend(exd_f);

                if (exd != null) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return Mainfarm(
                      fm: widget.fm!,
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
                    color: const Color.fromARGB(255, 34, 120, 37).withAlpha(50)),
                alignment: Alignment.center,
                child: const Text('เพิ่มข้อมูลค่าใช้จ่ายฟาร์ม',
                    style: TextStyle(color: Color(0xff235d3a), fontSize: 18)),
              ),
            )
          ],
        )),
      ),
    );
  }
}
