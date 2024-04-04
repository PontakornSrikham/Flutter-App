import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:robomaster_new_app/screen/package_detail.dart';

class Destination extends StatefulWidget {
  final String documentId;

  const Destination({Key? key, required this.documentId}) : super(key: key);

  @override
  _DestinationState createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {
  late List<bool> buttonPressedList;

  final List<String> buttonDataList = ['612','615','617','619','618/1-621','618/2','623-625'];

  @override
  void initState() {
    super.initState();
    buttonPressedList = List.generate(buttonDataList.length, (index) => false);
    // Automatically update buttonPressedList based on Firestore data
    sendDataToFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Button',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select destination room',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Display buttons
            // Create the first row of buttons
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
                        sendDataToFirestore(buttonDataList[i]);
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
            // Create the third row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 6; i < 7; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: buttonPressedList[i] ? null : () {
                        sendDataToFirestore(buttonDataList[i]);
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

            // Next button
            Padding(
              padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
              child: ElevatedButton(
                onPressed: isAnyRoomSelected()
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PackageDetail(documentId: widget.documentId),
                          ),
                        );
                      }
                    : null,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(80, 40)),
                ),
                child: Text('Next', style: TextStyle(fontSize: 18)),
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

  Future<void> sendDataToFirestore([String? selectedRoom]) async {
      // Retrieve the document from Firestore based on the documentId
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .doc(widget.documentId)
          .get();

      // Define the variable 'beginning' and set its initial value as an empty string
      String beginning = '';

      // Check if the document exists and contains 'beginning' value
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    if (documentSnapshot.exists && data.containsKey('beginning')) {
      beginning = data['beginning'] as String;
      // Update the 'destination' field in Firestore if the selected room is different from the beginning room
      if (selectedRoom != null && selectedRoom != beginning) {
        await FirebaseFirestore.instance
            .collection('payments')
            .doc(widget.documentId)
            .update({
          'destination': selectedRoom,
        });
      }

      // Update buttonPressedList to disable button if the selected room is the same as the beginning room
      setState(() {
        for (int i = 0; i < buttonDataList.length; i++) {
          if (buttonDataList[i] == beginning) {
            buttonPressedList[i] = true;
          }
        }
      });
    }
  }
}