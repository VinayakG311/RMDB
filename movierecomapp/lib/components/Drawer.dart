import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movierecomapp/MovieLists.dart';

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
                    onPressed: null,
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text("Search by Genre",style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Action")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Action',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Adventure")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Adventure',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Animation")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Animation',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Children")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text("Children",style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Comedy")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text( 'Comedy',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Crime")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Crime',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Documentary")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Documentary',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Drama")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Drama',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Fantasy")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text( 'Fantasy',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Film-noir")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Film-Noir',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Horror")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Horror',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Musical")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Musical',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Mystery")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Mystery',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Romance")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Romance',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Sci-Fi")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Sci-Fi',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Thriller")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('Thriller',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=War")));

                    },
                    child: const SizedBox(
                        height: 30,
                        width: 300,
                        child: Text('War',style: TextStyle(color: Colors.white),))),
                TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoveListsByGenre(url:"http://127.0.0.1:5000/api/genre?query=Wastern")));

                    },
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
