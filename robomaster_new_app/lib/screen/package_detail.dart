import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:robomaster_new_app/screen/WaitCarScreen.dart';
import 'package:robomaster_new_app/model/order.dart' as MyAppOrder;

class PackageDetail extends StatefulWidget {
  final String documentId;
  const PackageDetail({super.key, required this.documentId});

  @override
  State<PackageDetail> createState() => _PackageDetailState();
}

class _PackageDetailState extends State<PackageDetail> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<String> buttonDataList = ['Document', 'Food', 'Other'];
  String selectedPackageType = '';
  final List<bool> buttonPressedList = List.filled(6, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Detail',
          style: TextStyle(
            color: Colors.white, // ตั้งค่าสีตัวอักษรเป็นสีขาวที่นี่
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Package Detail',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text('Package Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                for (int i = 0; i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: buttonPressedList[i] ? null : () {
                        sendDataToFirestore(buttonDataList[i]);
                        setState(() {
                          buttonPressedList[i] = true;
                          selectedPackageType = buttonDataList[i];
                        });
                        for (int j = 0; j < buttonPressedList.length; j++) {
                          if (j != i) {
                            setState(() {
                              buttonPressedList[j] = false;
                            });
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: buttonPressedList[i] ? MaterialStateProperty.all(Colors.grey) : null,
                        minimumSize: MaterialStateProperty.all(Size(100, 45)),
                      ),
                      child: Text(buttonDataList[i], style: TextStyle(fontSize: 20),),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Note :',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(
                    hintText: 'Enter additional information...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  showConfirmationDialog();
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(100, 45)),
                ),
                child: const Text('Done', style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendDataToFirestore(String userEmail) async {
    DateTime currentTimestamp = DateTime.now();

    DocumentSnapshot documentSnapshot1 = await FirebaseFirestore.instance.collection('payments').doc(widget.documentId).get();
    String beginning = '';
    String destination = '';

    if (documentSnapshot1.exists) {
      Map<String, dynamic> data = documentSnapshot1.data() as Map<String, dynamic>;
      beginning = data['beginning'];
      destination = data['destination'];
    } else {
      print('Document does not exist');
      return;
    }

    // อ้างอิงไปยังคอลเล็กชัน "queue" ใน Firestore
    final queueReference = FirebaseFirestore.instance.collection('queue');

    // Create an Order object
    MyAppOrder.Order newOrder = MyAppOrder.Order(
      documentId: widget.documentId,
      packageType: selectedPackageType,
      additionalInfo: _textFieldController.text,
      userEmail: userEmail,
      timestamp: currentTimestamp,
      beginning: beginning,
      destination: destination
    );

    // เพิ่มข้อมูลเข้าไปในคอลเล็กชัน "queue"
    await queueReference.add({
      'document_id': widget.documentId,
      'package_type': selectedPackageType,
      'additional_info': _textFieldController.text,
      'user_email': userEmail,
      'timestamp': currentTimestamp,
      'beginning': beginning,
      'destination': destination
    });

    // Update the existing document or create a new one
    final documentReference =
        FirebaseFirestore.instance.collection('payments').doc(widget.documentId);

    final documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists) {
      // Update the existing document
      await documentReference.update({
        'package_type': selectedPackageType,
        'additional_info': _textFieldController.text,
        'user_email': userEmail,
        'timestamp': currentTimestamp,
        'beginning': beginning,
        'destination': destination
      });
    } else {
      // Create a new document if it doesn't exist
      await documentReference.set({
        'package_type': selectedPackageType,
        'additional_info': _textFieldController.text,
        'user_email': userEmail,
        'timestamp': currentTimestamp,
        'beginning': beginning,
        'destination': destination
      });
    }
  }

  Future<void> deleteDocument() async {
    await FirebaseFirestore.instance.collection('payments').doc(widget.documentId).delete();
  }

  void showConfirmationDialog() async {
    // Get the current user's email
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to sent this package?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Cancel the action and close the dialog
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await sendDataToFirestore(userEmail);
                // Close the dialog and navigate to WaitCarScreen
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return WaitCarScreen(documentId: widget.documentId);
                    },
                  ),
                  (route) => false,
                );
              },
              child: const Text("Confirm", style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }
}
