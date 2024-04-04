import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;


class UserBill extends StatelessWidget {
  final String userEmail;

  const UserBill({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile',
          style: TextStyle(
            color: Colors.white, // ตั้งค่าสีตัวอักษรเป็นสีขาวที่นี่
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: getUserBillData(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic>? userData = snapshot.data;

            if (userData == null) {
              return const Center(child: Text('User data not found.'));
            } else {
              String? imageUrl = userData['rec'] as String?;

              if (imageUrl == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Image not found.'),
                      ElevatedButton(
                        onPressed: () {
                          // เมื่อกดปุ่มให้เรียกฟังก์ชันที่ทำการอัปเดตค่า field 'bill' ใน Firestore
                          updateUserBill(userEmail);
                          updateUserPaymentForAdmin(userEmail);
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(imageUrl),
                      ElevatedButton(
                        onPressed: () {
                          print('User email: $userEmail');
                          // เมื่อกดปุ่มให้เรียกฟังก์ชันที่ทำการอัปเดตค่า field 'bill' ใน Firestore
                          updateUserBill(userEmail);
                          updateUserPaymentForAdmin(userEmail);
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getUserBillData() async {
    QuerySnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: userEmail).get();

    if (userSnapshot.docs.isNotEmpty) {
      return userSnapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      throw Exception('User data not found.');
    }
  }

  Future<void> updateUserBill(String userEmail) async {
    // อัปเดตค่า field 'bill' และลบ field 'rec' ใน Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference.update({
          'bill': 'Paid',
          'rec': FieldValue.delete(),
        });
      });
    });
  }


  Future<void> updateUserPaymentForAdmin(String userEmail) async {
    // อัปเดตค่า field 'amount' ในเอกสาร userpayment_foradmin
    await FirebaseFirestore.instance
        .collection('userpayment_foradmin')
        .doc(userEmail)
        .update({'amount': 0});
        
  }

}
