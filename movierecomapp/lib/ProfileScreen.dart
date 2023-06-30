import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movierecomapp/MoviesLaterNow.dart';
import 'package:movierecomapp/WelcomeScreen.dart';
import 'package:movierecomapp/loginRegister/login_screen.dart';
import 'package:movierecomapp/main.dart';

import 'models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.userModel, this.firebaseuser}) : super(key: key);
  static const String id ="profile";
  final UserModel? userModel;
  final User? firebaseuser;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WatchLaterNow(firebaseuser: widget.firebaseuser,userModel: widget.userModel,val: 0)));
                  },
                  child: Row(
                    children: const [
                      Text("Watched List",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color: Colors.white),),
                      Icon(Icons.navigate_next,color: Colors.white,)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WatchLaterNow(firebaseuser: widget.firebaseuser,userModel: widget.userModel,val: 1,)));

                  },
                  child: Row(
                    children: const [
                      Text("Watch Later",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color: Colors.white),),
                      Icon(Icons.navigate_next,color: Colors.white,)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>RMDB()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Sign Out",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),
                      Icon(Icons.exit_to_app_outlined)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
