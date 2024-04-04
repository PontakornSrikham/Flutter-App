import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:robomaster_new_app/screen/usermenu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _image;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> uploadImageToFirebase() async {
    if (_image == null) {
      // Handle if no image is selected
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().toString()}');
        UploadTask uploadTask = storageReference.putFile(_image!);
        await uploadTask.whenComplete(() => print('Image uploaded to Firebase'));

        String downloadURL = await storageReference.getDownloadURL();
        print('Download URL: $downloadURL');

        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          String? userEmail = (userDoc.data() as Map<String, dynamic>)['email'];
          await _firestore.collection('users').doc(user.uid).set({
            'rec': downloadURL,
          }, SetOptions(merge: true));
          print('Bill uploaded for user with email: $userEmail');
        } else {
          print('User document not found');
        }
      } else {
        print('User not signed in');
      }
    } catch (e) {
      print('Error uploading image to Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Add GlobalKey to Scaffold
      appBar: AppBar(
        title: const Text('Upload Bill',
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
            _image == null
                ? const Text('No image selected.')
                : Image.file(_image!),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => getImage(ImageSource.gallery),
                  child: const Text('Select from Gallery'),
                ),
                ElevatedButton(
                  onPressed: () => getImage(ImageSource.camera),
                  child: const Text('Take a Picture'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await uploadImageToFirebase();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Upload Successful')),
                );
                Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context){
                      return MenuScreen();
                }),
                  (route) => false
                );
              },
              child: const Text('Upload Bill'),
            ),
          ],
        ),
      ),
    );
  }
}
