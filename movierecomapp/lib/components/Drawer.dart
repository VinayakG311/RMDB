import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Drawers extends StatelessWidget {
  const Drawers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text("Popular movies",style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Action',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Adventure',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Animation',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text("Children",style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text( 'Comedy',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Crime',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Documentary',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Drama',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text( 'Fantasy',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Film-Noir',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Horror',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Musical',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Mystery',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Romance',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Sci-Fi',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Thriller',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('War',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {  },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text( 'Western',style: TextStyle(color: Colors.white),))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
