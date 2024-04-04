import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:robomaster_new_app/screen/WaitUser.dart';
import 'package:robomaster_new_app/screen/usermenu.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class WaitCarScreen extends StatefulWidget {
  
  final String documentId;
  const WaitCarScreen({super.key, required this.documentId});

  @override
  State<WaitCarScreen> createState() => _WaitCarScreenState();
}

class _WaitCarScreenState extends State<WaitCarScreen> {
  late Future<String> _imageUrlFuture;

  @override
  void initState() {
    super.initState();
    _imageUrlFuture = getImageUrlFromFirebase('robot_button.jpg');
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
                'Please wait...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                'The robot car is on it way.',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
              child: Text(
                'When the car has arrived\npress the confirm button.',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 30),
                child: Text(
                  '!! And do not forget to\npress the button on robot !!',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
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
            ElevatedButton(onPressed:() async{
              await checkAndUpdateDocument();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return WaitUser(documentId: widget.documentId);
                    },

                  ),(route) => false
                );
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(100, 45)),
            ),
            child: const Text('Confirm', style: TextStyle(fontSize: 20),)
            ),
            TextButton(
              onPressed: () async{
                // Delete the document and close the dialog
                await deleteDocument();
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return MenuScreen();
                    },
                  ),(route) => false
                );
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
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

  Future<void> checkAndUpdateDocument() async {
    // Get the document reference
    DocumentReference documentReference = FirebaseFirestore.instance.collection('payments').doc(widget.documentId);

    // Check if the document exists
    DocumentSnapshot documentSnapshot = await documentReference.get();

    // Check if the document has the expected values
    if (documentSnapshot.exists &&
        documentSnapshot.data() != null &&
        (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '612' &&
        (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '615') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 18;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    } else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '612' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '617') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 35;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    } else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '612' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '619') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 42;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '612' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '618/1-621') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 50;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '612' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '624-625') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 62;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '612' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '618/2') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 2;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '615' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '612') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 18;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '615' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '617') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 17;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '615' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '619') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 24;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '615' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '623-625') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 44;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '615' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '618/1-621') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 32;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '615' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '618/2') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 44;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '617' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '612') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 35;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '617' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '615') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 17;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '617' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '619') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 7;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '617' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '618/1-621') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 15;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '617' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '623-625') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 27;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '617' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '618/2') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 27;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '619' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '612') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 42;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '619' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '615') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 24;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '619' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '617') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 7;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '619' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '618/1-621') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 8;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '619' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '623-625') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 20;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '619' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '618/2') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 20;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '618/1-621' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '612') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 50;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '618/1-621' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '615') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 32;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '618/1-621' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '617') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 15;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '618/1-621' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '619') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 8;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '618/1-621' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '618/2') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 12;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '618/1-621' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '623-625') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 12;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }
    else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '623-625' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '612') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 62;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }
    else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '623-625' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '615') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 44;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }
    else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '623-625' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '617') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 27;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }
    else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '623-625' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '619') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 20;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }
    else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '623-625' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '618/1-621') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 12;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }
    else if (documentSnapshot.exists &&
              documentSnapshot.data() != null &&
              (documentSnapshot.data() as Map<String, dynamic>)['beginning'] == '623-625' &&
              (documentSnapshot.data() as Map<String, dynamic>)['destination'] == '618/2') {
      
      // Get the current distance value or set it to 0 if it doesn't exist
      int currentDistance = (documentSnapshot.data() as Map<String, dynamic>).containsKey('distance')
          ? (documentSnapshot.data() as Map<String, dynamic>)['distance']
          : 0;

      int updatedDistance = currentDistance + 5;

      // Update the document with the 'distance' field
      await documentReference.set({
        'distance': updatedDistance,
      }, SetOptions(merge: true));

      // Perform any additional actions or show messages if needed
      print('Document updated successfully! New distance: $updatedDistance');
    }
    else {
      // Document does not meet the expected conditions
      print('Document does not meet the expected conditions. No update performed.');
    }
  }


  Future<void> deleteDocument() async {
      await FirebaseFirestore.instance.collection('payments').doc(widget.documentId).delete();
  }
}