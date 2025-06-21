import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/Productdetails.dart';
import 'Productdetails.dart';

class Prodcut extends StatefulWidget {
  final String? value;
  const Prodcut({super.key, this.value});

  @override
  State<Prodcut> createState() => _ProdcutState();
}

class _ProdcutState extends State<Prodcut> {
  bool isLoading = true;
  List<Map<String, dynamic>> ProductList = [];
  bool IsProductNull = false;
  @override
  void didUpdateWidget(covariant Prodcut oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      getProduct();
    }
  }

  void getProduct() async {
    final prod = await FirebaseFirestore.instance.collection('products').get();
    final searchValue = widget.value ?? '';
    setState(() {
      ProductList =
          prod.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .where(
                (product) => product['title'].toString().contains(searchValue),
              )
              .toList();
      if (ProductList.length == 0) {
        IsProductNull = true;
      } else
        IsProductNull = false;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (IsProductNull) {
      return Center(
        child: Text(
          'No Data Found',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4,
        ),
        itemCount: ProductList.length,
        itemBuilder: (context, index) {
          //Moshera Update  GestureDetector
          final item = ProductList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Productdetails(product: item),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(item['image'], width: 150, height: 150),
                  Text(
                    item['title'].toString().substring(0, 15),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '\$${item['price']}',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
