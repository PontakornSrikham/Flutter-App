import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  String? _username;
  String? _phone;
  String? _email;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final userData = await firestore.collection('users').doc(auth.currentUser!.uid).get();
    setState(() {
      _username = userData['username'];
      _phone = userData['phone'];
      _email = auth.currentUser!.email;
    });
  }

  void _editUsername() async {
    final newUsername = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String updatedUsername = _username ?? '';
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextFormField(
            initialValue: updatedUsername,
            onChanged: (value) => updatedUsername = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, updatedUsername),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newUsername != null) {
      setState(() {
        _username = newUsername;
      });
      await updateUserData();
    }
  }

  void _editPhone() async {
    final newPhone = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String updatedPhone = _phone ?? '';
        return AlertDialog(
          title: const Text('Edit Phone Number'),
          content: TextFormField(
            initialValue: updatedPhone,
            onChanged: (value) => updatedPhone = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, updatedPhone),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newPhone != null) {
      setState(() {
        _phone = newPhone;
      });
      await updateUserData();
    }
  }

  Future<void> updateUserData() async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'username': _username,
      'phone': _phone,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Profile',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    'Email',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Text(
                    _email ?? 'N/A',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            buildEditableRow('Username', _username ?? 'N/A', _editUsername),
            buildEditableRow('Phone', _phone ?? 'N/A', _editPhone),
          ],
        ),
      ),
    );
  }

  Widget buildEditableRow(String label, String value, void Function()? onTap) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
              ),
              const Icon(Icons.edit),
            ],
          ),
        ),
      ],
    );
  }
}
