import 'package:cow_mange/Function/Function.dart';
import 'package:cow_mange/class/ExpendType.dart';
import 'package:cow_mange/class/Expendfarm.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/mainfarm.dart';
import 'package:cow_mange/validators.dart';
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
    clean_number();
  }

  //ccontroller
  final expendDate = TextEditingController();
  final name = TextEditingController();
  final amount = TextEditingController();
  final price = TextEditingController();
  //  button clear
  bool _showClearButton_expendDate = false;
  bool _showClearButton_name = false;
  bool _showClearButton_amount = false;
  bool _showClearButton_price = false;

  //textalert
  String textalert_1 = "";
  String textalert_2 = "";

  Future clean_number() async {
    expendDate.addListener(() {
      setState(() {
        _showClearButton_expendDate = expendDate.text.isNotEmpty;
      });
    });
    name.addListener(() {
      setState(() {
        _showClearButton_name = name.text.isNotEmpty;
      });
    });
    amount.addListener(() {
      setState(() {
        _showClearButton_amount = amount.text.isNotEmpty;
      });
    });
    price.addListener(() {
      setState(() {
        _showClearButton_price = price.text.isNotEmpty;
      });
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 224, 242, 228),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 30,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text("เพิ่มข้อมูลค่าใช้จ่ายฟาร์ม ",
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1.5)),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              "กรอกข้อมูลให้ถูกต้องก่อนเพิ่มข้อมูลค่าใช้จ่ายฟาร์ม",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  height: 1.5)),
                        ),
                      ],
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
                  child: TextFormField(
                    controller: expendDate,
                    readOnly: true,
                    validator:
                        Validators.required_isempty("กรุณาเลือกวันเกิดโค"),
                    decoration: InputDecoration(
                        suffixIcon: _getClearButton_expendDate(),
                        label: Text(
                          "เลือกวันที่ซื้อสินค้า",
                          style: TextStyle(color: Colors.black),
                        ),
                        hintText: "กรุณาเลือกวันที่ซื้อสินค้า",
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
                          lastDate: DateTime.now());

                      if (expendFarmDate != null) {
                        DateTime d = DateTime(expendFarmDate!.year + 543,
                            expendFarmDate!.month, expendFarmDate!.day);

                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(d);

                        setState(() {
                          expendDate.text = formattedDate;
                        });
                      } else {
                        print("กรุณาเลือกวันที่ซื้อสินค้า");
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
                  child: TextFormField(
                    controller: name,
                    validator: Validators.compose([
                      Validators.required_isempty(
                        "กรุณากรอก ชื่อรายการสินค้า",
                      ),
                      Validators.minLength(1, "กรุณากรอก ราคา"),
                      Validators.maxLength(7, "กรุณากรอก ราคา")
                    ]),
                    decoration: InputDecoration(
                        suffixIcon: _getClearButton_name(),
                        label: Text("ชื่อรายการสินค้า"),
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        icon: Icon(
                          FontAwesomeIcons.listNumeric,
                          color: Color(0XFF397D54),
                          size: 20,
                        )),
                  )),
              Row(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: amount,
                        keyboardType: TextInputType.number,
                        validator: Validators.compose([
                          Validators.required_isempty(
                            "กรุณากรอก จำนวน",
                          ),
                          Validators.minLength(1, "กรุณากรอก จำนวน"),
                          Validators.maxLength(7, "กรุณากรอก จำนวน")
                        ]),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                          MaskedInputFormatter('#########')
                        ],
                        decoration: InputDecoration(
                          suffixIcon: _getClearButton_amount(),
                          label: Text("จำนวน "),
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightGreen.withAlpha(50)),
                      child: TextFormField(
                        controller: price,
                        validator: Validators.compose([
                          Validators.required_isempty(
                            "กรุณากรอก ราคา",
                          ),
                          Validators.minLength(1, "กรุณากรอก ราคา"),
                          Validators.maxLength(7, "กรุณากรอก ราคา")
                        ]),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                          MaskedInputFormatter('##########')
                        ],
                        decoration: InputDecoration(
                            suffixIcon: _getClearButton_price(),
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
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(textalert_1,
                                style: TextStyle(color: Colors.red)),
                          )),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              textalert_2,
                            ),
                          ))
                    ],
                  )),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                        textalert_1 = "**";
                        if (category == "อาหาร") {
                          textalert_2 = "ถ้าเป็นประเภทอาหารเป็นกิโลกรัม";
                        } else {
                          textalert_2 = "ถ้าเป็นประเภทวัคซีนเป็นจำนวนขวด";
                        }
                      });
                    },
                    validator:
                        Validators.required_isnull("กรุณาเลือกประเภทอาหาร"),
                    decoration: InputDecoration(
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
                  bool validate = _formKey.currentState!.validate();
                  if (validate == false) {
                  } else {
                    exd_f.expendFarmDate = expendFarmDate;
                    exd_f.name = name.text;
                    exd_f.amount = int.parse(amount.text);
                    exd_f.price = double.parse(price.text);
                    exd_f.expendType =
                        ExpendType.expendType_name(expendType_name: category);
                    exd_f.farm = Farm.Newid_farm(id_Farm: widget.fm!.id_Farm);

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
                  child: const Text('เพิ่มข้อมูลค่าใช้จ่ายฟาร์ม',
                      style: TextStyle(color: Color(0xff235d3a), fontSize: 18)),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  Widget? _getClearButton_expendDate() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_expendDate) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          expendDate.clear();
        });
  }

  Widget? _getClearButton_name() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_name) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          name.clear();
        });
  }

  Widget? _getClearButton_amount() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_amount) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          amount.clear();
        });
  }

  Widget? _getClearButton_price() {
    // ถ้าเป็นค่าว่าง return null
    if (!_showClearButton_price) {
      return null;
    }
    return GestureDetector(
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        onTap: () {
          price.clear();
        });
  }
}
