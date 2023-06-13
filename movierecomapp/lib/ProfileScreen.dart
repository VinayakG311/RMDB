import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movierecomapp/MyApp.dart';
import 'package:movierecomapp/main.dart';

import 'WelcomeScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String id ="profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child:             Padding(
          padding: EdgeInsets.only(right: 8.0),
          child:  TextButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (Route<dynamic> route) => false,
                );
                // Navigator.popUntil(context, (route) => route.isFirst);
                // Navigator.pushReplacementNamed(context,WelcomeScreen.id);
                // // Navigator.of(context).popUntil((route) => route.isFirst);
                // //
                // // Navigator.of(context).pushNamed(WelcomeScreen.id);
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //         WelcomeScreen.id,
                //         (route) => false);
                // // Navigator.popUntil(context, (route) => route.isFirst);
                // // Navigator.pushReplacementNamed(context,WelcomeScreen.id);
              },
              child:  Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Sign Out",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),
                    Icon(Icons.exit_to_app_outlined)
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
