import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RobotStatus extends StatefulWidget {
  @override
  _RobotStatusState createState() => _RobotStatusState();
}

class _RobotStatusState extends State<RobotStatus> {
  // Function เพื่ออัปเดตข้อมูลใน Firestore
  void _updateStatus(String newStatus) async {
    await FirebaseFirestore.instance
        .collection('status')
        .doc('status')
        .update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Screen',
          style: TextStyle(
            color: Colors.white, // ตั้งค่าสีตัวอักษรเป็นสีขาวที่นี่
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Select Robot Status:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _updateStatus('In Use'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(100, 45)),
              ),
              child: Text('In Use', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _updateStatus('Charging'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(100, 45)),
              ),
              child: Text('Charging', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _updateStatus('Ready'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(100, 45)),
              ),
              child: Text('Ready', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
