import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:robomaster_new_app/screen/login.dart';

class SettingScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  SettingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(auth.currentUser!.email!, style: const TextStyle(fontSize: 25),),
              SizedBox(height: 20,),
              ElevatedButton(
                child: const Text("Logout"),
                onPressed: (){
                  auth.signOut().then((value){
                      Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (context){
                      return const LoginScreen();
                    }),(route) => false
                    );
                  });
                },)
            ],),
        ),
      ),
    );
  }
}