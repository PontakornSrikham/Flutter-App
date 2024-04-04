import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robomaster_new_app/screen/usermenu.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email Verification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmailVerificationPage(),
    );
  }
}

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  TextEditingController _emailController = TextEditingController();

  Future<void> _verifyEmail() async {
    String userEmail = _emailController.text.trim();
    // Query to check if the latest document in 'queue' collection has the same user_email as input
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('queue')
        .orderBy('timestamp', descending: false)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String latestUserEmail = querySnapshot.docs.first.get('user_email');
      if (userEmail == latestUserEmail) {
        QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: latestUserEmail)
        .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          DocumentReference userDocRef = userQuerySnapshot.docs.first.reference;
          await userDocRef.update({'deliver': 'Delivered'});
          await updateAdminDeliveryStatus();
          await updateRobotStatus();
        }

        // Do something if email matches
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Repoomceived the item successfully.'),
            actions: [
              TextButton(
                onPressed: () async {
                  // Delete data from 'queue' collection based on the earliest timestamp
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('queue').orderBy('timestamp', descending: false).limit(1).get();
                  if (querySnapshot.docs.isNotEmpty) {
                    String documentIdToDelete = querySnapshot.docs.first.id;
                    await FirebaseFirestore.instance.collection('queue').doc(documentIdToDelete).delete();
                  }
                  
                  // Navigate back to MenuScreen
                  Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context){
                        return MenuScreen();
                    }),
                    (route) => false
                  );
                  },
                child: Text('Done', style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        );
      } else {
        // Do something if email doesn't match
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Email does not match.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK', style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> updateAdminDeliveryStatus() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc('deliver_stat')
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update({'deliver_stat': 'Finished'});
      }
    });
  }

  Future<void> updateRobotStatus() async {
    await FirebaseFirestore.instance
        .collection('status')
        .doc('status')
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update({'status': 'Ready'});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Email Verification',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: _verifyEmail,
              child: Text('Verify', style: TextStyle(fontSize: 20),),
            ),
          ],
        ),
      ),
    );
  }
}

