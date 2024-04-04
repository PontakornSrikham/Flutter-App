import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:robomaster_new_app/screen/destination_room.dart';

class Beginning extends StatefulWidget {
  const Beginning({super.key});

  @override
  State<Beginning> createState() => _BeginningState();
}

class _BeginningState extends State<Beginning> {
  final databaseReference = FirebaseDatabase.instance.ref();
  late String documentId = ""; // Variable to store the document ID

  // Define a list of button data
  final List<String> buttonDataList = ['612','615', '617', '619', '618/1-621', '618/2', '623-625'];

  final List<bool> buttonPressedList = List.filled(7, false);

  void sendDataToFirebase(String data) {
    databaseReference.child("buttonData").set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Button',
          style: TextStyle(
            color: Colors.white, // ตั้งค่าสีตัวอักษรเป็นสีขาวที่นี่
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select beginning room (Your room)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Create the first row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: buttonPressedList[i] ? null : () {
                        sendDataToFirestore(i);
                        setState(() {
                          buttonPressedList[i] = true;
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
                        minimumSize: MaterialStateProperty.all(Size(80, 40)),
                      ),
                      child: Text(buttonDataList[i], style: TextStyle(fontSize: 18),),
                    ),
                  ),
              ],
            ),
            // Create the second row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 3; i < 6; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: buttonPressedList[i] ? null : () {
                        sendDataToFirestore(i);
                        setState(() {
                          buttonPressedList[i] = true;
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
                        minimumSize: MaterialStateProperty.all(Size(80, 40)),
                      ),
                      child: Text(buttonDataList[i], style: TextStyle(fontSize: 18),),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 6; i < 7; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: buttonPressedList[i] ? null : () {
                        sendDataToFirestore(i);
                        setState(() {
                          buttonPressedList[i] = true;
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
                        minimumSize: MaterialStateProperty.all(Size(80, 40)),
                      ),
                      child: Text(buttonDataList[i], style: TextStyle(fontSize: 18),),
                    ),
                  ),
              ],
            ),
            // "Next" button at the bottom
            Padding(
              padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
              child: ElevatedButton(
                onPressed: isAnyRoomSelected() ? () {
                  // Navigate to the Destination screen
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Destination(documentId: documentId);
                    },
                  ));
                } : null,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(80, 40)),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 18),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isAnyRoomSelected() {
    return buttonPressedList.contains(true);
  }

  Future<void> sendDataToFirestore(int index) async {
    if (documentId.isNotEmpty) {
      DocumentReference documentReference = FirebaseFirestore.instance.collection('payments').doc(documentId);
      await documentReference.update({
        'beginning': buttonDataList[index],
      });
    } else {
      final newDocument = await FirebaseFirestore.instance.collection('payments').add({
        'beginning': buttonDataList[index],
      });
      documentId = newDocument.id;
    }
  }
}
