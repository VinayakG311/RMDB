import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../MyApp.dart';
import '../components/RoundedButtons.dart';
import '../components/constants.dart';
import '../main.dart';
import '../models.dart';
class LoginScreen extends StatefulWidget {
  static const String id ="lpgin_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  bool showspinner=false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Scaffold(
  //      backgroundColor: Colors.white,
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
                  //Do something with the user input.
                  email=value;
                },
                decoration: kTextfieldDecoration.copyWith(hintText: "Enter your email",
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
                  style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  //Do something with the user input.
                  password=value;
                },
                decoration: kTextfieldDecoration.copyWith(
                    hintText:"Enter your password",
                    hintStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(25))
                )
                ),

              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(const Color(0xffffC75F), "login",()async {
                setState(() {
                  showspinner=true;
                });

                try{
                final user=await _auth.signInWithEmailAndPassword(email: email, password: password);
                if(user!=null){
                  String uid = user.user!.uid;
                //  await FirebaseFirestore.instance.collection('users').doc(uid).set({"MoviesWatched":[{}]});
                  DocumentSnapshot userdata = await FirebaseFirestore.instance.collection('users').doc(uid).get();
             //     print(userdata.data());
             //     UserModel newUser;

                  UserModel newUser = UserModel.fromMap(userdata.data() as Map<String,dynamic>);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyApp(userModel: newUser,firebaseuser: user.user!,)));

                }
                setState(() {
                  showspinner=false;
                });}
                catch(e){
                  print(e);
                  setState(() {
                    showspinner=false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.fixed,
                      content: Text(e.toString(),style: TextStyle(color: Colors.white),),
                    backgroundColor: Colors.red,
                  ));
                }
              },Colors.black
              )
              ,
            ],
          ),
        ),
      ),
    );
  }
}
