import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/Categories.dart';
import 'package:flutter_proj/Profile.dart';
import 'package:flutter_proj/Shop.dart';
import 'package:flutter_proj/auth.dart';
import 'package:flutter_proj/mainHomePage.dart';
import 'Product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _choosenIndex=0;

void whichPage(int index){
  setState(() {
    _choosenIndex = index;

  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:_pages[_choosenIndex],
bottomNavigationBar:BottomNavigationBar(type: BottomNavigationBarType.fixed,
    currentIndex: _choosenIndex,
    onTap: whichPage,
    unselectedItemColor:Color(0xFFB2594B),
    selectedItemColor: Colors.grey,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
       BottomNavigationBarItem(icon:  Icon(Icons.shopping_cart),label: 'shop' ,),
      BottomNavigationBarItem(icon:  Icon(Icons.person),label: 'Profile'),
]) ,
    );
  }
}
final List<Widget> _pages = [
  mainHomePage(),
  Shop(),
  Profile(),
];

