import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'CategoryProductsPage.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> myCategory = [];
  List<String> Category = [
    "men's clothing",
    'electronics',
    'jewelery',
    "women's clothing",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCat();
  }

  void getCat() async {
    final cat = await FirebaseFirestore.instance.collection('categories').get();
    setState(() {
      myCategory = cat.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: myCategory.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = myCategory[index];
          String category = Category[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CategoryProductsPage(category: category),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(5),
              width: 100,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(myIcon[index], color: Color(0xFFB2594B)),
                    Text(
                      '$item',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

final List<IconData> myIcon = [
  FontAwesomeIcons.shirt,
  FontAwesomeIcons.tv,
  FontAwesomeIcons.ring,
  FontAwesomeIcons.personDress,
];
