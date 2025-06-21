import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePage.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  String? uid;

  // سيتم تنفيذ هذا عند دخول الصفحة أو كل مرة تتغير الـ dependencies (المستخدم مثلاً)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // إذا لم يتم تسجيل الدخول بعد، نعرض لودر مؤقت
    if (uid == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFB2594B),
          title: Text('Cart'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    //  بدي أجيب العناصر من الفايربيس للمستخدم الحالي حسب uid
    final cartStream = FirebaseFirestore.instance
        .collection('carts')
        .doc(uid)
        .collection('items')
        .orderBy('timestamp', descending: true)
        .snapshots(); //  بعمل Stream (تحديث مباشر) كل مرة بيصير تغيير

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB2594B),
        leading: IconButton(
          // لما المستخدم يرجع من صفحة Shop يرجع على Homepage
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Homepage()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Cart', style: TextStyle(fontSize: 22)),
      ),

      //  هون بدي أعرض المعلومات باستخدام StreamBuilder
      // كل ما تصير داتا جديدة في Firestore يتم التحديث تلقائياً
      body: StreamBuilder<QuerySnapshot>(
        stream: cartStream,
        builder: (ctx, snap) {
          // التأكد إذا الداتا لسه مش جاهزة
          if (!snap.hasData) return Center(child: CircularProgressIndicator());

          final docs = snap.data!.docs;

          //  التأكد إذا السلة فاضية
          if (docs.isEmpty) return Center(child: Text('Your Cart is Empty'));

          //  حساب المجموع الكلي لكل المنتجات في السلة
          double totalAll = docs.fold(0.0, (sum, d) {
            final data = d.data() as Map<String, dynamic>;
            return sum + (data['total'] as num);
          });

          return Column(
            children: [
              //  عرض المنتجات داخل ListView
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //  عرض السعر الكلي للمنتج الواحد
                          Text(
                            '\$${(data['total'] as num).toStringAsFixed(2)} ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          //  زر الحذف من السلة
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              //  حذف العنصر من Firestore عند الضغط
                              await docs[item].reference.delete();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ✅ عرض المجموع الكلي النهائي لكل المنتجات في السلة
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
