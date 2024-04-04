import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:robomaster_new_app/screen/SettingScreen.dart';
import 'package:robomaster_new_app/screen/monthlybill.dart';
import 'package:robomaster_new_app/screen/profilescreen.dart';
import 'package:robomaster_new_app/screen/queue.dart';
import 'package:robomaster_new_app/screen/robotStatus.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({super.key});


  @override
  State<AdminMenu> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<AdminMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu",
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
                    .collection('admins')
                    .doc('deliver_stat')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('No data available');
                  }
                  var statusData = snapshot.data!.data() as Map<String, dynamic>;
                  var robotStatus = statusData['deliver_stat'] as String;

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
                    ]
                  );
                },
              ),
              SizedBox(height: 50,),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton.icon(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return const QueueScreen();
                  })
                );
                }, icon: const Icon(Icons.agriculture),
                label: const Text("Queue",style: TextStyle(fontSize: 20),)
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton.icon(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return RobotStatus();
                  })
                );
                }, icon: const Icon(Icons.agriculture),
                label: const Text("Robot Status",style: TextStyle(fontSize: 20),)
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton.icon(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return const MonthlyBill();
                  })
                );
                }, icon: const Icon(Icons.add_card),
                label: const Text("Monthly Bill",style: TextStyle(fontSize: 20),)
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton.icon(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return SettingScreen();
                  })
                );
                }, icon: const Icon(Icons.exit_to_app),
                label: const Text("Logout",style: TextStyle(fontSize: 20),)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}