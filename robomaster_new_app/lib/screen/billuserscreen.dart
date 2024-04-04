import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:robomaster_new_app/screen/billscreen.dart';

class BillUserScreen extends StatefulWidget {
  @override
  _BillUserScreenState createState() => _BillUserScreenState();
}

class _BillUserScreenState extends State<BillUserScreen> {
  double totalAmount = 0;
  String userBill = '';
  

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    //bool isDayOver = now.day >= 20;
    // Check if the current date is between 25th and 28th of the month
    if (now.day >=20 && now.day <= 27) {
      // Call _generateBill() when the condition is met
      _generateBill();
    }
    // Call displayUserBill() to display user's bill
    displayUserBill();
    _getTotalAmount().then((value) {
      setState(() {
        totalAmount = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill User Screen',
          style: TextStyle(
            color: Colors.white, // ตั้งค่าสีตัวอักษรเป็นสีขาวที่นี่
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0), // เพิ่ม Padding ด้านบน 50 พิกเซล
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // กำหนดรูปร่างของ Card
                ),
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount : ${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'User Bill Now : $userBill',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FutureBuilder<QuerySnapshot>(
                      future: _getUserPayments(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Widget> paymentWidgets = [];
                          List<DocumentSnapshot> payments = snapshot.data!.docs;
                          // เรียงลำดับ payments ตาม timestamp จากเก่าไปใหม่
                          payments.sort((a, b) {
                            // ตรวจสอบว่า a และ b มีค่า timestamp ไม่ใช่ null ก่อน
                            if (a['timestamp'] != null && b['timestamp'] != null) {
                              return (a['timestamp'] as Timestamp).compareTo(b['timestamp']);
                            } else {
                              // ถ้ามีค่า timestamp เป็น null ให้เรียงลำดับตามเกณฑ์อื่น ๆ
                              return 0; // ไม่เปลี่ยนลำดับ
                            }
                          });
                          // จำกัดจำนวนการแสดงผลเฉพาะ 5 ตัวล่าสุด
                          int displayCount = 5;
                          int endIndex = payments.length - 1;
                          int startIndex = endIndex - displayCount + 1;
                          startIndex = startIndex >= 0 ? startIndex : 0; // ตรวจสอบเพื่อหลีกเลี่ยงข้อผิดพลาดหากมีรายการน้อยกว่า 3 ตัว
                          for (int i = endIndex; i >= startIndex; i--) {
                            var payment = payments[i];
                            var amount = payment['amount'];
                            var timestamp = payment['timestamp'];
                            String? formattedDate;
                            
                            if (timestamp != null) {
                              formattedDate = DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch).toString();
                            } else {
                              formattedDate = "N/A";
                            }
                            
                            var formattedAmount = (amount as double).toStringAsFixed(2);
                            paymentWidgets.add(
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Card(
                                  elevation: 3,
                                  child: ListTile(
                                    title: Text('Amount: $formattedAmount'),
                                    subtitle: Text('Date: $formattedDate'),
                                  ),
                                ),
                              ),
                            );
                          }
                          return ListView(
                            children: paymentWidgets,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 100), // เพิ่ม Padding ด้านล่าง 100 พิกเซล
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return BillScreen();
                      },
                    ));
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(100, 45)),
                  ),
                  child: const Text('Pay a bill', style: TextStyle(fontSize: 20),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double> _getTotalAmount() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    

    if (user != null) {
      // Access the user's email
      String currentUserEmail = user.email!;
      
      // Query "userpayment_foradmin" collection with matching user email
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('userpayment_foradmin')
          .where('user_email', isEqualTo: currentUserEmail)
          .get();

      // Check if there's any data
      if (snapshot.docs.isNotEmpty) {
        // Access the first document (assuming there's only one document per user)
        var data = snapshot.docs.first.data();
        // Check if the document contains the 'amount' field
        if (data.containsKey('amount')) {
          // Access the 'amount' field and convert it to double
          return double.parse(data['amount'].toString());
        }
      }
    }
    // Return 0.0 if there's no data or user is not logged in
    return 0.0;
  }

  Future<void> _generateBill() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Access the user's email
      String currentUserEmail = user.email!;

      // Get current date
      DateTime now = DateTime.now();
      int currentDay = now.day;
      DateTime startDateTime;
      DateTime endDateTime;

      if (currentDay >= 28) {
        // If today is 28th or later, start from the 28th of the current month
        startDateTime = DateTime(now.year, now.month, 28);
        endDateTime = DateTime(now.year, now.month + 1, 19);
      } else {
        // If today is before 28th, start from the 28th of the previous month
        startDateTime = DateTime(now.year, now.month - 1, 28);
        endDateTime = DateTime(now.year, now.month, 19);
      }

      // Access Firestore collection "payments" and query documents with matching email and timestamp within the specified range
      QuerySnapshot<Map<String, dynamic>> payments = await FirebaseFirestore.instance
          .collection('payments')
          .where('user_email', isEqualTo: currentUserEmail)
          .where('timestamp', isGreaterThanOrEqualTo: startDateTime)
          .where('timestamp', isLessThanOrEqualTo: endDateTime)
          .get();

      // Calculate total amount from all documents
      double sum = 0;
      payments.docs.forEach((payment) {
        // Check if the payment document contains the 'amount' field
        if (payment.data().containsKey('amount')) {
          sum += payment['amount'];
        }
      });

      // Check if sum is greater than 0 before updating the bill status
      if (sum != 0) {
        // Check if it's between the specified range
        // Access Firestore collection "users" and query documents with matching email
        QuerySnapshot<Map<String, dynamic>> users = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUserEmail)
            .get();

        // Check if there's any user with this email
        if (users.docs.isNotEmpty) {
          // Access the first document (assuming there's only one user with this email)
          var userData = users.docs.first.data();

          // Check if the user has a bill field
          if (userData.containsKey('bill')) {
            // Access the bill field
            var userBillData = userData['bill'];

            // Check if the bill is already paid
            if (userBillData == 'Paid') {
              // If the bill is already paid, exit the function
              return;
            }
          }
        }

        // Create a reference to the 'user_payments' collection
        CollectionReference userPaymentsRef = FirebaseFirestore.instance.collection('user_payments');

        // Add a new document with a generated ID
        await userPaymentsRef.add({
          'user_email': currentUserEmail,
          'amount': sum,
          'timestamp': FieldValue.serverTimestamp(),
        });

        CollectionReference userPaymentsRefforadmin = FirebaseFirestore.instance.collection('userpayment_foradmin');
        // สร้าง DocumentReference โดยระบุเอกสารที่ต้องการอัปเดต
        DocumentReference docRef = userPaymentsRefforadmin.doc(currentUserEmail);

        // อัปเดตข้อมูลในเอกสารนี้
        await docRef.set({
          'user_email': currentUserEmail,
          'amount': sum,
        });
        // Update totalAmount in the state to trigger UI update
        /*setState(() {
          totalAmount = sum;
        });*/
      }
    }
  }

  Future<void> displayUserBill() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Access the user's email
      String currentUserEmail = user.email!;

      // Access Firestore collection "users" and query documents with matching email
      QuerySnapshot<Map<String, dynamic>> users = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUserEmail)
          .get();

      // Check if there's any user with this email
      if (users.docs.isNotEmpty) {
        // Access the first document (assuming there's only one user with this email)
        var userData = users.docs.first.data();

        // Check if the user has a bill field
        if (userData.containsKey('bill')) {
          // Access the bill field
          var userBillData = userData['bill'];

          // Update userBill in the state to trigger UI update
          setState(() {
            userBill = userBillData.toString();
          });
        } else {
          // Handle the case where the user doesn't have a bill field
          setState(() {
            userBill = 'User does not have a bill.';
          });
        }
      } else {
        // Handle the case where user data is not found
        setState(() {
          userBill = 'User data not found.';
        });
      }
    } else {
      // Handle the case where user is not logged in
      // You may navigate user to login screen or display an error message
      setState(() {
        userBill = 'User not logged in.';
      });
    }
  }

  Future<QuerySnapshot> _getUserPayments() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Access the user's email
      String currentUserEmail = user.email!;

      // Query "user_payments" collection with matching user email
      return await FirebaseFirestore.instance
          .collection('user_payments')
          .where('user_email', isEqualTo: currentUserEmail)
          .get();
    } else {
      throw Exception('User not logged in.');
    }
  }
}