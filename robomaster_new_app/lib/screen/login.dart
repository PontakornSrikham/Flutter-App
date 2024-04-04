import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:robomaster_new_app/model/profile.dart';
import 'package:robomaster_new_app/screen/adminMenu.dart';
import 'package:robomaster_new_app/screen/register.dart';
import 'package:robomaster_new_app/screen/usermenu.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '', phone: '', username: '',bill: '', deliver: '');
  final Future<FirebaseApp> loginfirebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loginfirebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: Center(child: Text("${snapshot.error}")),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Login/Register",
                  style: TextStyle(
                    color: Colors.white, // ตั้งค่าสีตัวอักษรเป็นสีขาวที่นี่
                  ),
                ),
                backgroundColor: Colors.blue,
              ),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 100, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Email", style: TextStyle(fontSize: 20)),
                            TextFormField(
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Please enter an email address"),
                                EmailValidator(errorText: "Invalid email address")
                              ]),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (String? email) {
                                profile.email = email!;
                              },
                            ),
                            const SizedBox(height: 15),
                            const Text("Password", style: TextStyle(fontSize: 20)),
                            TextFormField(
                              validator: RequiredValidator(
                                  errorText: "Please enter your password"),
                              obscureText: true,
                              onSaved: (String? password) {
                                profile.password = password!;
                              },
                            ),
                            SizedBox(height: 100,),
                            Center(
                              child: SizedBox(
                                width: 300,
                                height: 45,
                                child: ElevatedButton(
                                  child: const Text("Login",
                                      style: TextStyle(fontSize: 20)),
                                  onPressed: () async{
                                    if (formkey.currentState!.validate()) {
                                      formkey.currentState!.save();
                                      try{
                                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                                          email: profile.email,
                                          password: profile.password).then((value) async {
                                            formkey.currentState!.reset();
                                            var isAdmin = await checkIfAdmin(profile.email);
                                            if(isAdmin){
                                              Navigator.pushReplacement(
                                                context, MaterialPageRoute(builder: (context){
                                                return const AdminMenu();
                                              }));
                                            } else{
                                              Navigator.pushReplacement(
                                                context, MaterialPageRoute(builder: (context){
                                                return MenuScreen();
                                              }));
                                            }
                                          });
                                      }on FirebaseAuthException catch(e){
                                        Fluttertoast.showToast(
                                          msg: e.message!,
                                          gravity: ToastGravity.CENTER);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Center(
                              child: SizedBox(
                                width: 300,
                                height: 45,
                                child: ElevatedButton(
                                  child: const Text("Register",
                                  style: TextStyle(fontSize: 20)),
                                  onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context){
                                    return const RegisterScreen();
                                  })
                                );
                                },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
    }
    Future<bool> checkIfAdmin(String email) async {
    var result = await FirebaseFirestore.instance
        .collection('admins') // Replace with your admin collection name
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }
}