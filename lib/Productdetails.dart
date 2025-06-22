import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Shop.dart';

//Work by Moshera
class Productdetails extends StatefulWidget {
  final Map<String, dynamic> product;

  const Productdetails({super.key, required this.product});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {

  String _size = 'M';
  int _numOfProduct = 1;

  @override
  Widget build(BuildContext context) {
    final item = widget.product;
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB2594B),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Product Details'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(item['image'], height: 200)),
            SizedBox(height: 16),
            Text(
              item['title'],
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 20),
                Text(item['rating'].toString(), style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 12),
            Text(item['description'].toString().substring( 0,60)),
            SizedBox(height: 35),
            Text('Item Size', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Row(
              children:
                  ['S', 'M', 'L'].map((size) {
                    final selected = size == _size;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _size = size;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selected ? Color(0xFFB2594B) : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          size,
                          style: TextStyle(
                            color: selected ? Colors.black : Colors.grey,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('quantity', style: TextStyle(fontSize: 16)),
                IconButton(
                  onPressed:
                      _numOfProduct > 1
                          ? () => setState(() => _numOfProduct--)
                          : null,
                  icon: Icon(Icons.remove_circle_outline),
                ),
                Text('$_numOfProduct'),
                IconButton(
                  onPressed: () => setState(() => _numOfProduct++),
                  icon: Icon(Icons.add_circle_outline),
                ),
                SizedBox(width: 70),
                Text('total = ', style: TextStyle(fontSize: 16)),
                Text(
                  '\$${(item['price'] * _numOfProduct).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 16,
                ),
                label: Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                //اضافة المنتج الي الفير ستور
                onPressed: () async {
                  final uid = FirebaseAuth.instance.currentUser!.uid;
                  await FirebaseFirestore.instance
                      .collection('carts')
                      .doc(uid)
                      .collection('items')
                      .add({
                        'productId': item['id'],
                        'title': item['title'],
                        'price': item['price'],
                        'image': item['image'],
                        'size': _size,
                        'quantity': _numOfProduct,
                        'total': item['price'] * _numOfProduct,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Shop()
                    ),
                  );

                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Color(0xFFB2594B),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
