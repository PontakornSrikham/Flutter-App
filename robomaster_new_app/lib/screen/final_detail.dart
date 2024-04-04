
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:robomaster_new_app/screen/usermenu.dart';

class FinalDetail extends StatefulWidget {
  final String documentId;

  const FinalDetail({super.key, required this.documentId});

  @override
  State<FinalDetail> createState() => _FinalDetailState();
}

class _FinalDetailState extends State<FinalDetail> {

  late String beginning = '';
  late String destination = '';
  late String packageType = '';
  late String additional_info = '';
  late int distance = 0;
  late double weight = 0 ;
  late double amount = 0;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('payments')
        .doc(widget.documentId)
        .get();
    if (documentSnapshot.exists) {
      setState(() {
        beginning = documentSnapshot['beginning'] ?? '';
        destination = documentSnapshot['destination'] ?? '';
        packageType = documentSnapshot['package_type'] ?? '';
        additional_info = documentSnapshot['additional_info'] ?? '';
        distance = (documentSnapshot['distance'] ?? 0).toInt();
        weight = (documentSnapshot['weight'] ?? 0).toDouble();
        amount = (documentSnapshot['amount'] ?? 0).toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'The robot car is currently delivered.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Text(
                    'Detail',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'Beginning Room',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    beginning,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'Destination Room',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    destination,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'Total weight',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    '${weight.toStringAsFixed(2)} Kg',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'Amount',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    '${amount.toStringAsFixed(2)} ฿',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'Distance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    '${distance.toString()} m',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'Package Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    packageType,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    'Note :',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                  child: Text(
                    additional_info,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
                if (currentUserEmail != null) {
                  await updateDeliveryStatus(currentUserEmail);
                  await updateRobotStatus();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return MenuScreen();
                    },
                  ), (route) => false);
                }
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(100, 45)),
              ),
              child: const Text('Confirm', style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateDeliveryStatus(String userEmail) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.update({'deliver': 'Transporting'});
      });
    });
  }


  Future<void> updateRobotStatus() async {
    await FirebaseFirestore.instance
        .collection('status')
        .doc('status')
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          snapshot.reference.update({'status': 'In Use'});
      }
    });
  }

}