import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart' as firebase_database;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robomaster_new_app/screen/final_detail.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class WaitUser extends StatefulWidget {
  final String documentId;
  const WaitUser({Key? key, required this.documentId}) : super(key: key);

  @override
  State<WaitUser> createState() => _WaitUserState();
}

class _WaitUserState extends State<WaitUser> {
  late Future<String> _imageUrlFuture;

  @override
  void initState() {
    super.initState();
    _imageUrlFuture = getImageUrlFromFirebase('robot_button.jpg');
  }

  double? weight;

  Future<void> fetchWeightFromDatabase() async {
    firebase_database.DatabaseReference weightRef = firebase_database.FirebaseDatabase.instance.ref().child('Weight');
    double weightValue = 0;
    
    try {
      firebase_database.Query query = weightRef.orderByKey().limitToLast(1);
      firebase_database.DataSnapshot snapshot = (await query.once()).snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;

        if (values != null) {
          values.forEach((key, value) {
            weightValue = double.parse(value.toString());
          });
          await FirebaseFirestore.instance.collection('payments').doc(widget.documentId).update({
            'weight': weightValue,
          });
        }
      } else {
        print("No Data");
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<String> getImageUrlFromFirebase(String imageName) async {
    try {
      // Get reference to the image
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref('robot_button/$imageName');

      // Get the download URL
      String url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      print('Error getting image URL: $e');
      return ''; // Return empty string if error occurs
    }
  }

  Future<void> calculateAmount() async {
    final DocumentSnapshot paymentSnapshot =
        await FirebaseFirestore.instance.collection('payments').doc(widget.documentId).get();

    if (paymentSnapshot.exists) {
      final int distance = paymentSnapshot['distance'];
      final double weight = paymentSnapshot['weight'];
      final double amount = distance * weight;
      final Map<String, dynamic> updatedData = {
        'amount': amount,
      };
      await FirebaseFirestore.instance.collection('payments').doc(widget.documentId).update(updatedData);
    }
  }

  Future<void> updateAdminDeliveryStatus() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc('deliver_stat')
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update({'deliver_stat': 'Ready to send'});
      }
    });
  }

  Future<void> showConfirmationDialog() async {
    await fetchWeightFromDatabase(); // Fetch weight from Realtime Database
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to send this package?"),
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
                await calculateAmount();
                await updateAdminDeliveryStatus();
                Navigator.of(context).pop(); // Close confirmation dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return FinalDetail(documentId: widget.documentId);
                    },
                  ),
                  (route) => false,
                );
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(100, 45)),
              ),
              child: const Text("Confirm", style: TextStyle(fontSize: 20),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Packaging...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 30),
              child: Text(
                'Please press the confirm button\nwhen the packages are already\nput into the robot car basket.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 30),
                child: Text(
                  '!! And do not forget to\npress the button on robot !!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            FutureBuilder<String>(
              future: _imageUrlFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Image.network(
                    snapshot.data!,
                    width: 250,
                    height: 250,
                  );
                }
              },
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () async {
                showConfirmationDialog();
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(100, 45)),
              ),
              child: const Text('Done', style: TextStyle(fontSize: 20),),
            )
          ],
        ),
      ),
    );
  }
}
