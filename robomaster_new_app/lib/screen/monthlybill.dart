import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robomaster_new_app/screen/userbill.dart';

class MonthlyBill extends StatefulWidget {
  const MonthlyBill({super.key});

  @override
  _MonthlyBillState createState() => _MonthlyBillState();
}

class _MonthlyBillState extends State<MonthlyBill> {
  String _resultMessage = '';
  List<Map<String, dynamic>> _userAmountList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Bill',
          style: TextStyle(
            color: Colors.white, // ตั้งค่าสีตัวอักษรเป็นสีขาวที่นี่
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _userAmountList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _userAmountList.length,
                      itemBuilder: (context, index) {
                      final userData = _userAmountList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Card(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: ListTile(
                          title: Text(
                            userData['user_email'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Total: ${userData['total_amount'].toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // เมื่อผู้ใช้คลิกที่รายการ ให้ไปยังหน้า UserProfile
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserBill(userEmail: userData['user_email']),
                              ),
                            );
                          },
                        ),
                        )
                      );
                    },
                  )
                : Center(
                  child: Text(_resultMessage),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: ElevatedButton(
              onPressed: () {
                generateMonthlyBill();
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(100, 45)),
              ),
              child: const Text('Generate Monthly Bill' , style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> generateMonthlyBill() async {
    QuerySnapshot paymentsSnapshot = await FirebaseFirestore.instance.collection('userpayment_foradmin').get();

    Map<String, double> userAmountMap = {};

    for (var paymentDoc in paymentsSnapshot.docs) {
    String? userEmail = (paymentDoc.data() as Map<String, dynamic>?)?['user_email'] as String?;
    double amount = (paymentDoc.data() as Map<String, dynamic>?)?['amount']?.toDouble() ?? 0;

    // เพิ่มเงื่อนไขเช็คว่า userEmail ไม่เป็น null และไม่ว่างเพื่อคำนวณเฉพาะเอกสารที่มี user_email
    if (userEmail != null && userEmail.isNotEmpty) {
      if (userAmountMap.containsKey(userEmail)) {
        userAmountMap[userEmail] = (userAmountMap[userEmail] ?? 0) + amount;
      } else {
        userAmountMap[userEmail] = amount;
      }
    }
  }

    userAmountMap.forEach((userEmail, totalAmount) {
      FirebaseFirestore.instance.collection('admin_payment').doc(userEmail).set({
        'user_email': userEmail,
        'total_amount': totalAmount,
      }, SetOptions(merge: true));
    });

    setState(() {
      _userAmountList = userAmountMap.entries.map((entry) => {
        'user_email': entry.key,
        'total_amount': entry.value,
      }).toList();
      _resultMessage = 'Monthly Bill generated successfully!';
    });
  }
}
