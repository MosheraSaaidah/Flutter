import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}
TextEditingController EmailController = TextEditingController();
TextEditingController PassController = TextEditingController();
final FirebaseAuth _auth = FirebaseAuth.instance;
String errorMessage = '';
class _LoginState extends State<Login> {
  @override
  void LoginUser() async{
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: EmailController.text.trim(),
          password: PassController.text.trim());
      Navigator.pushNamed(context, '/HomePage');

    }
    on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message as String;
      });
    }

  }
  GlobalKey <FormState> _key = GlobalKey<FormState>();
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
              controller: EmailController,
              validator: (String? value){
                if(value != null || value!.isEmpty){
                  return 'you need to write you email';
                }
                return null;
              },
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFFB2594B),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFFB2594B),
                      width: 2,
                    ),
                  ),
                  icon: Icon(Icons.mail,color: Color(0xFFB2594B),),
                  labelText: 'Gmail',
                  hintText: 'enter your Gmail'
              ),
            ),
            SizedBox(width: 15,height: 25,),
            TextFormField(
              obscureText:true ,
              controller: PassController,
              validator: (val){
                if(val != null || val!.isEmpty){
                  return 'you need to write you email';
                }
                return null;
              }
              ,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFFB2594B),
                      width: 2,
                    ),
                  ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFFB2594B),
                    width: 2,
                  ),
                ),
                  icon: Icon(Icons.password,color:Color(0xFFB2594B),),
                  labelText: 'Password',
                hintText: 'enter your password',

              ),
            ),
            SizedBox(width: 15,height: 25,),
            OutlinedButton(style: ButtonStyle(
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
            ),onPressed: (){
              LoginUser();

            }, child: Text('Login')),
            SizedBox(width: 15,height: 25,),
            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/SignUp');
                },
                child: Text('you dont have an account?',style: TextStyle(color: Color(0xFFB2594B)),),
              ),
            ),
          SizedBox(height:10 ,),
          if(!errorMessage.isEmpty) Text('*theres error on your data',style: TextStyle(color: Colors.red),) ,

          ],
        )),
      ),
    )
      ,);
  }
}
