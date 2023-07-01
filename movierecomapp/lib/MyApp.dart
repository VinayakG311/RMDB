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
const apikey="a4f935f84a9c541b12ffe03282cb7337";

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.firebaseuser, this.userModel});
  static const String id ="MyApp";
  final User? firebaseuser;
  final UserModel? userModel;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      home: MyHomePage(firebaseuser: widget.firebaseuser,userModel: widget.userModel,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.firebaseuser, this.userModel}) : super(key: key);
  final User? firebaseuser;
  final UserModel? userModel;

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
    String url = 'http://192.168.1.2:4444/api/popularmovie';
    late var data;
    String output='nothing';
    UserModel model = widget.userModel!;
    List movies = model.MoviesWatchedandRated;
    print(movies);
    List d= [];
    var e;
    for(int i=0;i<movies.length;i++) {
      var entry = movies[i].keys.forEach((element) {
        e = element;
      });

      d.add(e);
    }
    return Scaffold(
      drawer: const Drawers(),
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
            const Padding(
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
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(firebaseuser: widget.firebaseuser,userModel: widget.userModel,)));
                },
                child: const CircleAvatar(

                ),
              ),
            )
          ],
        )],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Recommended for you",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  MoveTile(url: 'http://192.168.1.2:4444/api/collabKNN?query=1',firebaseuser: widget.firebaseuser,userModel: widget.userModel,),
                ],
              ),
            ),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: [
            //       MoveTile(
            //         url: 'http://127.0.0.1:5000/api/collaborative?query=The%20Shawshank%20Redemption',
            //         firebaseuser: widget.firebaseuser,
            //         userModel: widget.userModel,),
            //
            //     ],
            //   ),
            // ),


       // SizedBox(height: 50,),
       //     Text("hi"),


              for(int i=1;i<movies.length;i++)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("Coz you watched ${d[i]}",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight
                            .bold),),
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          MoveTile(
                            url: 'http://192.168.1.2:4444/api/collaborative?query=${d[i]}',
                            firebaseuser: widget.firebaseuser,
                            userModel: widget.userModel,),

                        ],
                      ),
                    ),

                  ],
                ),



            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Popular now",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:[
                  MoveTile(url: 'http://192.168.1.2:4444/api/popularmovie',firebaseuser: widget.firebaseuser,userModel: widget.userModel,),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Action",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:  [
                  MoveTile(url: 'http://192.168.1.2:4444/api/genre?query=Action',firebaseuser: widget.firebaseuser,userModel: widget.userModel,),

                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
}
class MoveTile extends StatelessWidget {
  const MoveTile({Key? key, required this.url, this.firebaseuser, this.userModel}) : super(key: key);
  final String url;
  final User? firebaseuser;
  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {

    return url!=''?SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 350,
        //color: Colors.white24,
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
                          Navigator.push(context, MaterialPageRoute(builder:(context)=>MovieDetails(movie: snapshot.data![index],firebaseuser: firebaseuser,userModel: userModel,) ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                      //    color: Color(0xff121212),
                          //  elevation: 0,
                             //color: Colors.transparent,
                       //   color: Colors.white24,
                            child: SizedBox(
                              height: 700,
                              width: 200,
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: 300,
                                      width: 210,
                                      child: Center(child: Image.network("https://image.tmdb.org/t/p/w780"+snapshot.data![index].MovieUrl.toString()))),
                                  Text((snapshot.data![index].MovieName)!,overflow: TextOverflow.ellipsis,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
              else if(snapshot.hasError){
                // print(snapshot.error);
                return Container(child: Text("Error loading list, please try again later"),);
              }
              else {
                return Container(
                  child: Text("hi"),
                );

              }}
            else{
              return Container(

              );
            }
          },
        ),
      ),
    )
        :Card(
      child: Text("Try again later"),
    );
  }
}



Future<List<Movie>> fetchdata(String url) async {
  Response response = await get(Uri.parse(url));
  var decoded1 = jsonDecode(response.body);
  List decoded = decoded1["output"];
  //print(url);
 // print(decoded);
  List<Movie> x = [];
  var m = decoded.map((e) {
    // print("object");
    // print(e['title']);
    //  print(class(e));
  //  print(e);
    Movie er = Movie.fromJson(e);
 //   print(er);
    x.add(er);
  });
  print(m);
  // print(x);

  return x;
//  return decoded.map((e) => Movie.fromJson(e)).toList();
}


