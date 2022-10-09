import 'package:cow_mange/Mainpageguest.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  GoogleFonts.config.allowRuntimeFetching = true;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff689758),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red))),
        chipTheme:
            ChipTheme.of(context).copyWith(backgroundColor: Colors.green),
        textTheme: GoogleFonts.mitrTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Color.fromARGB(46, 0, 48, 75)),
        textSelectionTheme:
            const TextSelectionThemeData(selectionColor: Colors.green),
      ),
      home: Mainguest(),
    );
  }
}
