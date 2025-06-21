import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_proj/HomePage.dart';
import 'package:flutter_proj/Login.dart';
import 'package:flutter_proj/MainPage.dart';
import 'package:flutter_proj/auth.dart';
import 'firebase_options.dart';
import 'signup.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: auth(),

      debugShowCheckedModeBanner: false,
      routes:  <String, WidgetBuilder>{
        '/auth': (BuildContext ctx) =>auth(),
        '/mainPage': (BuildContext ctx) =>Mainpage(),
        '/Login': (BuildContext ctx) => Login(),
        '/SignUp': (BuildContext ctx) => SignUpPage(),
        '/HomePage':(BuildContext ctx) => Homepage()
      }
    );
  }
}
