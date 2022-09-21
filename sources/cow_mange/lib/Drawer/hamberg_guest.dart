import 'package:cow_mange/Mainpageguest.dart';
import 'package:cow_mange/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class hamberg_guest extends StatefulWidget {
  const hamberg_guest({
    Key? key,
  }) : super(key: key);

  @override
  State<hamberg_guest> createState() => _hamberg_guestState();
}

class _hamberg_guestState extends State<hamberg_guest> {
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
            radius: 70,
            child: Image.asset("images/cow-01.png"),
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Cow Manage",
            style: TextStyle(
              fontSize: 20,
            ),
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
              Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                return const Mainguest();
              })));
            },
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.userLarge,
              color: Color(0XFF397D54),
              size: 20,
            ),
            title: const Text("เข้าสู่ระบบ"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                return const LoginScreen();
              })));
            },
          ),
        ],
      ),
    );
  }
}
