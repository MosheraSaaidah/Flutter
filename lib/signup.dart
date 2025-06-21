import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  GlobalKey <FormState> _key = GlobalKey<FormState>();
  TextEditingController NameController = TextEditingController();
  TextEditingController PassController = TextEditingController();
  TextEditingController EmailController = TextEditingController();

void addUser()async{
  final cred = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: EmailController.text.trim(), password: PassController.text.trim());
  final uid = cred.user!.uid;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .set({
    'email':EmailController.text.trim(),
    'username':NameController.text.trim(),
    'avatar':'https://cdn-icons-png.freepik.com/256/14024/14024680.png?uid=R135753459&ga=GA1.1.1493282509.1737971570&semt=ais_hybrid',
    'createdAt': Timestamp.now(),
  });
}
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child:Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        color:  Color(0xFFFBC7A8),
        child:Form(
          key: _key,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Logo.png',width: 250,height: 250,),
            TextFormField(
              controller: NameController,
                validator: (val){
                  if(val == null || val.isEmpty){
                    return 'you need to write you Name';
                  }
                  return null;
                },
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Color(0xFFB2594B),
                          width:2
                      )
                  ),
                  focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Color(0xFFB2594B),
                          width:2
                      )

                  ),
                  icon: Icon(Icons.person,color: Color(0xFFB2594B),),
                  labelText: 'Name',
                  hintText: 'enter your Name'
              ),
            ),
            SizedBox(width: 15,height: 25,),
            TextFormField(
              controller: EmailController,
                validator: (val){
                  if(val == null || val.isEmpty){
                    return 'you need to write you email';
                  }
                  return null;
                },
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Color(0xFFB2594B),
                          width:2
                      )
                  ),
                  focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Color(0xFFB2594B),
                          width:2
                      )

                  ),
                  icon: Icon(Icons.mail,color: Color(0xFFB2594B),),
                  labelText: 'email',
                  hintText: 'enter your email',

              ),
            ),
            SizedBox(width: 15,height: 25,),
            TextFormField(
              obscureText: true,
              controller: PassController,
                validator: (val){
                  if(val == null || val.isEmpty){
                    return 'you need to write you password';
                  }
                  return null;
                },
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Color(0xFFB2594B),
                          width:2
                      )
                  ),
                  focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Color(0xFFB2594B),
                          width:2
                      )

                  ),
                  icon: Icon(Icons.password,color: Color(0xFFB2594B),),
                  labelText: 'Password',
                  hintText: 'enter your password'
              ),
            ),
            SizedBox(width: 15,height: 25,),
            TextFormField(
              obscureText: true,
                validator: (val){
                  if(val == null || val.isEmpty){
                    return 'you need to write you password';
                  }else if(val != PassController.text.trim() ){
                    return 'your password not matches';
                  }
                  return null;
                },
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFFB2594B),
                      width:2
                    )
                  ),
                  focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Color(0xFFB2594B),
                          width:2
                      )
                  ),
                  icon: Icon(Icons.lock_outline,color: Color(0xFFB2594B),),
                  labelText: 'Confirm Password',
                  hintText: 'enter your password'
              ),
            ),
            SizedBox(width: 15,height: 25,),
            OutlinedButton(
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                    BorderSide(color: Color(0xFFB2594B), width: 2),
                  ),
                  foregroundColor: WidgetStateProperty.all(Color(0xFFB2594B)),
                  overlayColor: WidgetStateProperty.all(Color(0x33B2594B)),
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
            ,onPressed: ()async{
                  if(_key.currentState!.validate()){
                    addUser();
                   Navigator.pushNamed(context, '/Login');
                  }
            }, child: Text('signup')),
            SizedBox(width: 15,height: 25,),
          ],
        )),
      ),
    )
      ,);
  }
}
