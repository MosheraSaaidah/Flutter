import 'package:flutter/material.dart';
/////// splash page
class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
            child:Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              color:  Color(0xFFFBC7A8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/Logo.png',width: 250,height: 250,),
                  IconButton(onPressed: ()=>Navigator.pushNamed(context, '/Login'),icon:Icon(Icons.arrow_circle_right,color:Color(0xFFB2594B),size:45,))
                ],
              ),
            )
        ) ,
    );
  }
}
