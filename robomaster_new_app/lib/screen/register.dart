import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:robomaster_new_app/model/profile.dart';
import 'package:robomaster_new_app/screen/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formkey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '', phone: '', username: '', bill: '', deliver: '');
  final Future<FirebaseApp> loginfirebase = Firebase.initializeApp();
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loginfirebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text("Error"),backgroundColor: Colors.blue,),
              body: Center(child: Text("${snapshot.error}")),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Register",
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
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Please enter your password"),
                              MinLengthValidator(6, errorText: "Password must be at least 6 characters"),
                            ]),
                            obscureText: true,
                            onSaved: (String? password) {
                              profile.password = password!;
                            },
                          ),
                          const SizedBox(height: 15),
                          const Text("Username", style: TextStyle(fontSize: 20)),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: "Please enter your username"),
                            onSaved: (String? username) {
                              profile.username = username!;
                            },
                          ),
                          const SizedBox(height: 15),
                          const Text("Phone", style: TextStyle(fontSize: 20)),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Please enter your phone number"),
                              PatternValidator(r'^[0-9]*$', errorText: 'Please enter only numeric digits'),
                              MinLengthValidator(10, errorText: 'Phone number must be at least 10 digits'),
                              MaxLengthValidator(15, errorText: 'Phone number must not exceed 15 digits'),
                            ]),
                            onSaved: (String? phone) {
                              profile.phone = phone!;
                            },
                          ),
                          SizedBox(height: 60,),
                          Center(
                            child: SizedBox(
                              width: 300,
                              height: 45,
                              child: ElevatedButton(
                                child: const Text("Register",
                                    style: TextStyle(fontSize: 20)),
                                onPressed: () async{
                                  if (formkey.currentState!.validate()) {
                                    formkey.currentState!.save();
                                    try{
                                      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: profile.email,
                                      password: profile.password
                                      );
                                      await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userCredential.user!.uid)
                                        .set({
                                        'email': profile.email,
                                        'username': profile.username,
                                        'phone': profile.phone,
                                        'bill': 'Paid',
                                        'deliver': 'Delivered'
                                      });
                                      Fluttertoast.showToast(
                                        msg: "User account created successfully",
                                        gravity: ToastGravity.CENTER);
                                      formkey.currentState!.reset();
                                      Navigator.pushAndRemoveUntil(
                                        context, MaterialPageRoute(builder: (context){
                                          return const LoginScreen();
                                        }),
                                          (route) => false
                                        );
                                    }on FirebaseAuthException catch(e){
                                      Fluttertoast.showToast(
                                        msg: e.message!,
                                        gravity: ToastGravity.CENTER);
                                    }
                                  }
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
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
