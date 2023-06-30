import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:movierecomapp/main.dart';

import '../MyApp.dart';
import '../components/RoundedButtons.dart';
import '../components/constants.dart';
import '../models.dart';
class RegistrationScreen extends StatefulWidget {

  static const String id ="registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth=FirebaseAuth.instance;
  bool showSpinner=false;
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
   //     backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 55.0,right: 55),
                child: Card(
                    color:Color(0xffffC75F),
                    child: SizedBox(
                        height: 80,
                        width: 10,
                        child: Center(child: Text('RMDb',style: TextStyle(fontSize:50,color: Colors.black,fontWeight: FontWeight.w800),)))),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                    email=value;
                  //Do something with the user input.
                },
                decoration: kTextfieldDecoration.copyWith(hintText:"Enter your email",
                    hintStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ))
              ),
              const SizedBox(
                height: 8.0,
              ),

              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  password=value;
                  //Do something with the user input.
                },
                decoration: kTextfieldDecoration.copyWith(hintText: "Enter your password",
                    hintStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ))
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(const Color(0xffffC75F), "register",() async{
                setState(() {
                  showSpinner=true;
                });
                try {
                  final newuser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  String uid = newuser.user!.uid;
                  UserModel user = UserModel(uid: uid,email: email,firstname: '');
                  await FirebaseFirestore.instance.collection('users').doc(uid).set(
                      user.toMap()).then((value){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyApp(userModel: user,firebaseuser: newuser.user,)));

                 //   Navigator.popUntil(context, (route) => route.isFirst);
                //    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyApp(firebaseuser:newuser.user ,userModel:user ,)));
                  });
                  setState(() {
                    showSpinner=false;
                  });
                }

              catch(e){
                print(e);
                setState(() {
                  showSpinner=false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.fixed,
                  content: Text(e.toString(),style: TextStyle(color: Colors.white),),
                  backgroundColor: Colors.red,
                ));
              }
      },Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
