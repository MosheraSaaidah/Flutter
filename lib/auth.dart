import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/HomePage.dart';
import 'package:flutter_proj/Login.dart';
import 'package:flutter_proj/MainPage.dart';


class auth extends StatefulWidget {
  const auth({super.key});

  @override
  State<auth> createState() => _authState();
}

class _authState extends State<auth> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context,snapshot){

            if(snapshot.hasData){
              return Homepage();
            }
            else{
              return Mainpage();
            }
          }
          ),
        )
    );
  }
}
