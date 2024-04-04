import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robomaster_new_app/model/user.dart';
import 'package:robomaster_new_app/screen/SettingScreen.dart';
import 'package:robomaster_new_app/screen/beginning_room.dart';
import 'package:robomaster_new_app/screen/billscreen.dart';
import 'package:robomaster_new_app/screen/billuserscreen.dart';
import 'package:robomaster_new_app/screen/profilescreen.dart';
import 'package:robomaster_new_app/screen/receive.dart';

class MenuScreen extends StatelessWidget {
  
  // Function to check if current date is between 20th and 28th
  bool isBetween20thAnd28th() {
    DateTime currentDate = DateTime.now();
    return currentDate.day >= 20 && currentDate.day <= 27;
  }

  // Function to update bill status
  Future<void> updateBillStatus(String userEmail) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    QuerySnapshot querySnapshot = await firestore.collection('users').where('email', isEqualTo: userEmail).get();
    if (querySnapshot.docs.isNotEmpty) {
      // หากพบข้อมูลผู้ใช้
      String userId = querySnapshot.docs.first.id;
      await firestore.collection('users').doc(userId).update({'bill': 'Unpaid'});
    } else {
      // หากไม่พบข้อมูลผู้ใช้
      print('User data not found');
    }
  } catch (error) {
    print('Error updating bill status: $error');
  }
}


  @override
  Widget build(BuildContext context) {
    if (!isBetween20thAnd28th()) {
      // Update bill status for current user
      String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
      updateBillStatus(currentUserEmail);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu",
          style: TextStyle(
            color: Colors.white, // ตั้งค่าสีตัวอักษรเป็นสีขาวที่นี่
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('status')
                    .doc('status')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('No data available');
                  }
                  var statusData = snapshot.data!.data() as Map<String, dynamic>;
                  var robotStatus = statusData['status'] as String;

                  // แสดงข้อมูลสถานะหุ่นยนต์
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Robot Status: ',
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                          SizedBox(width: 5.0), // เพิ่มระยะห่างระหว่าง Text widget
                          Text(
                            robotStatus,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Text('No user data available');
                          }
                          var userData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                          var deliverValue = userData['deliver'] as String;

                          // แสดงค่าในฟิลด์ deliver ของผู้ใช้ปัจจุบัน
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Delivery Status: ',
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                              SizedBox(width: 5.0), // เพิ่มระยะห่างระหว่าง Text widget
                              Text(
                                deliverValue,
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),

              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Beginning()),
                    );
                  },
                  icon: Icon(Icons.agriculture),
                  label: Text(
                    "Delivery",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BillUserScreen()),
                    );
                  },
                  icon: Icon(Icons.add_card),
                  label: Text(
                    "Bill",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmailVerificationPage()),
                    );
                  },
                  icon: Icon(Icons.add_card),
                  label: Text(
                    "Receive Item",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  icon: Icon(Icons.person),
                  label: Text(
                    "Profile",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingScreen()),
                    );
                  },
                  icon: Icon(Icons.exit_to_app),
                  label: Text(
                    "Logout",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
