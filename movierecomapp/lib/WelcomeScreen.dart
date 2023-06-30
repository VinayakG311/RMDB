import 'package:flutter/material.dart';
import 'components/RoundedButtons.dart';
import 'loginRegister/login_screen.dart';
import 'loginRegister/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id ="welcome_screen";
  // final UserModel? userModel;
  // final User? firebaseUser;

  //WelcomeScreen({Key? key,this.userModel,this.firebaseUser}) : super(key: key);
  @override

  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController Controller;
  late Animation animation;
  @override
  void initState(){
    super.initState();
    Controller=AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation=CurvedAnimation(parent: Controller, curve: Curves.decelerate);
    Controller.forward();
    Controller.addListener(() {
      setState(() {
      });
      //print(animation.value);

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  //    backgroundColor: Colors.white,
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
            RoundedButton(const Color(0xffffC75F), "login",(){Navigator.pushNamed(context, LoginScreen.id);},Colors.black),
            RoundedButton(Colors.white, "Registration",(){Navigator.pushNamed(context, RegistrationScreen.id);},Colors.black),

          ],
        ),
      ),
    );
  }
}
