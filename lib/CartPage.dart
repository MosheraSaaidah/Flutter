import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Productdetails.dart';

class CartPage extends StatelessWidget {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    //////////////  بدي أجيب العنصرمن الفيربيس

    final cartStream =
        FirebaseFirestore.instance
            .collection('carts')
            .doc(uid)
            .collection('items')
            .orderBy('timestamp', descending: true)
            .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB2594B),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Cart', style: TextStyle(fontSize: 22)),
      ),

      // هون بدي اعمل عرض للمعلومات عندي بعمل سناب كل مرة بيصير عندي داتا جديدة
      // وبدي اتاكد منها هل هي وصلت او  لا وبعدين بدي أعرضها
      body: StreamBuilder<QuerySnapshot>(
        stream: cartStream,
        builder: (ctx, snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return Center(child: Text('Your Cart is Empty'));
          // عشان احسب المبلغ الكامل لكل المنتجات الي عندي بالسلة
          // fold   هاي تُستخدم لتجميع أو تراكم القيم داخل القائمة في قيمة واحدة نهائية وبنستخدمها عادة للشغلات التراكمية
          double totalAll = docs.fold(0.0, (sum, d) {
            final data = d.data() as Map<String, dynamic>;
            return sum + (data['total'] as num);
          });

          return Column(
            children: [
              //  لعرض المنتج الواحد داخل  السلة
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, item) {
                    final data = docs[item].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Image.network(data['image'], width: 50),
                      title: Text(data['title']),
                      subtitle: Text(
                        'Size ${data['size']} . Qua: ${data['quantity']}',
                      ),
                      trailing: Text(
                        '\$${(data['total'] as num).toStringAsFixed(2)} ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              // المجموع الكلي لكل المنتجات في سلة المستخدم الحالي
              Padding(
                padding: EdgeInsets.all(70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\$${totalAll.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
