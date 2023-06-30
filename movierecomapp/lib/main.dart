
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:movierecomapp/MovieDetails.dart';
import 'package:movierecomapp/ProfileScreen.dart';

import 'package:movierecomapp/WelcomeScreen.dart';
import 'package:movierecomapp/loginRegister/login_screen.dart';
import 'package:movierecomapp/loginRegister/registration_screen.dart';
import 'package:movierecomapp/models.dart';

import 'MyApp.dart';
import 'components/Helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;

  if(currentUser!=null){

    UserModel? thisUser = await FirebaseHelper.GetUserModelById(currentUser.uid);
    if(thisUser!=null){
      runApp(RMDBLoggedin(userModel: thisUser, firebaseuser: currentUser));

    }
    else{
        runApp(const RMDB());

    }

  }
  else{
    runApp(const RMDB());
  }
}
class RMDB extends StatelessWidget {
  const RMDB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      initialRoute: WelcomeScreen.id,

      routes:{
        MyApp.id:(context)=>const MyApp(),
        WelcomeScreen.id:(context)=>const WelcomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),
        MovieDetails.id:(context)=>const MovieDetails(),
        ProfileScreen.id:(context)=>const ProfileScreen(),
      } ,

    );
  }
}
class RMDBLoggedin extends StatelessWidget {
  const RMDBLoggedin({Key? key, this.userModel, this.firebaseuser}) : super(key: key);
  final UserModel? userModel;
  final User? firebaseuser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),

      themeMode: ThemeMode.dark,
      initialRoute: MyApp.id,
      routes: {
        MyApp.id:(context)=>MyApp(firebaseuser: firebaseuser,userModel: userModel),
        MovieDetails.id:(context)=>MovieDetails(firebaseuser: firebaseuser,userModel: userModel),
        ProfileScreen.id:(context)=>ProfileScreen(firebaseuser: firebaseuser,userModel: userModel),
      },
    );
  }
}


