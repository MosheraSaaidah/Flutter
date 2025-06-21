import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_proj/Login.dart';
import 'Productdetails.dart';

class CategoryProductsPage extends StatefulWidget {
  final String category;
  const CategoryProductsPage({super.key, required this.category});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> productList = [];
  bool isLoading = true;
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
  }

  void fetchProductsByCategory() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('products')
            .where('cat', isEqualTo: widget.category)
            .get();

    final products = snapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      productList = products.cast<Map<String, dynamic>>();
      isLoading = false;
      isEmpty = productList.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB2594B),
        title: Text(widget.category),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : isEmpty
              ? Center(
                child: Text(
                  'No products found in this category',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final item = productList[index];
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
                          SizedBox(height: 15),
                          Text(
                            item['title'].toString().length > 15
                                ? item['title'].toString().substring(0, 15)
                                : item['title'].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 15),
                          Text(
                            '\$${item['price'].toString()}',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

/* */
