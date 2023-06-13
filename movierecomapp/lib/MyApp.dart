import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movierecomapp/ProfileScreen.dart';
import 'package:movierecomapp/components/Drawer.dart';

import 'MovieDetails.dart';
import 'WelcomeScreen.dart';
import 'models.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.firebaseuser, this.userModel});
  static const String id ="MyApp";
  final User? firebaseuser;
  final UserModel? userModel;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      title: 'RMDB',
      //   theme: ThemeData(scaffoldBackgroundColor: const Color(0x00ffffff),appBarTheme: AppBarTheme(color: Colors.black)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> list = <String>['genres','Action', 'Adventure', 'Animation', "Children", 'Comedy', 'Crime', 'Documentary', 'Drama', 'Fantasy',
    'Film-Noir', 'Horror', 'Musical', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller', 'War', 'Western'];
  String dropdownValue = 'genres';
  int selected=0;
  @override
  Widget build(BuildContext context) {
    String url = 'http://127.0.0.1:5000/api/popularmovie';
    late var data;
    String output='nothing';

    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(
        centerTitle: false,
        //  leadingWidth: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: SizedBox(
              height: 30,
              width: 60,
              child: Card(
                  color:Color(0xffffC75F),
                  child: Center(child: Text('RMDb',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),)))),
        ),
        titleSpacing: 0,
        actions: [Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.0,top: 8,bottom: 8),
              child:           SizedBox(
                  height: 26,
                  width: 230,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Search for Movie,TV show",
                        hintStyle: TextStyle(fontSize: 15)
                    ),
                  )),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen()));
              },
              child: CircleAvatar(

              ),
            )
          ],
        )],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Recommended for you"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  MoveTile(url: 'http://127.0.0.1:5000/api/collabKNN?query=1',),
                ],
              ),
            ),
            const Text("Coz you watched()"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  MoveTile(url: 'http://127.0.0.1:5000/api/collaborative?query=Avatar',),

                ],
              ),
            ),
            const Text("Popular now"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  MoveTile(url: 'http://127.0.0.1:5000/api/popularmovie',),
                ],
              ),
            ),
            const Text("Action"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  MoveTile(url: 'http://127.0.0.1:5000/api/genre?query=Action',),

                ],
              ),
            ),
            const Text("Put all others if wanna"),




          ],
        ),
      ),
    );
  }
}
class MoveTile extends StatelessWidget {
  const MoveTile({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return url!=''?SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 200,
        color: Colors.white24,
        //  child: Text("data"),
        child: FutureBuilder<List<Movie>>(
          future: fetchdata(url),
          builder: (context,snapshot){

            //     print(snapshot.connectionState);

            // print(snapshot);
            if(snapshot.connectionState==ConnectionState.done){
              if(snapshot.hasData){

                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context,index){
                      //         print(snapshot.data![index].MovieName);
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder:(context)=>MovieDetails(movie: snapshot.data![index]) ));
                        },
                        child: Card(
                          color: Colors.white24,
                          child: SizedBox(
                            height: 350,
                            width: 200,
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 170,

                                    child: Center(child: Image.network("https://image.tmdb.org/t/p/w342"+snapshot.data![index].MovieUrl.toString()))),
                                Text((snapshot.data![index].MovieName)!,overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
              else if(snapshot.hasError){
                // print(snapshot.error);
                return Container(child: const Text("hii"),);
              }
              else {
                return Container(
                  child: const Text("hi"),
                );

              }}
            else{
              return Container(

              );
            }
          },
        ),
      ),
    ):Card(
      color: Colors.white24,
      child: SizedBox(
        height: 200,
        width: 200,
        child: Column(
          children: const [
            Text("data2")
          ],
        ),
      ),
    );
  }
}


Future<List<Movie>> fetchdata(String url) async {
  Response response = await get(Uri.parse(url));

  var decoded1 = jsonDecode(response.body);
  List decoded = decoded1["output"];
//  print(decoded);
  List<Movie> x = [];
  var m = decoded.map((e) {
    // print("object");
    // print(e['title']);
    //  print(class(e));
    x.add(Movie.fromJson(e));
  });
  print(m);
  return x;
//  return decoded.map((e) => Movie.fromJson(e)).toList();
}
