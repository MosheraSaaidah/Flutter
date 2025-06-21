import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_proj/Categories.dart';
import 'Product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Profile.dart';
class mainHomePage extends StatefulWidget {
  const mainHomePage({super.key});
  @override
  State<mainHomePage> createState() => _mainHomePageState();
}

class _mainHomePageState extends State<mainHomePage> {
  bool isLoading = true;
  String value = '';
  String avatar = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAuthData();
  }

  void getAuthData() async {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          final data = doc.data();
          avatar = data?['avatar'];
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Container(
        padding: EdgeInsets.all(15),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Omesha Shop',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xFFB2594B),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) =>Profile()));
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  avatar.isNotEmpty
                                      ? avatar
                                      : "https://cdn-icons-png.freepik.com/256/14024/14024680.png?uid=R135753459&ga=GA1.1.1493282509.1737971570&semt=ais_hybrid",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                    Text('Get popular fashion from home'),
                    SizedBox(height: 15),
                    TextFormField(
                      onChanged: (val) {
                        setState(() {
                          value = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search the clothes you need',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: BorderSide(
                            color: Color(0xFFB2594B),
                            width: 3,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: BorderSide(
                            color: Color(0xFFB2594B),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Categories(),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular Fashion',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Prodcut(value: value),
                  ],
                ),
      ),
    );
  }
}
