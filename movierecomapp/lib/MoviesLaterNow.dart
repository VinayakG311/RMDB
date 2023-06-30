import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'MovieDetails.dart';
import 'models.dart';

const apikey="a4f935f84a9c541b12ffe03282cb7337";

class WatchLaterNow extends StatefulWidget {
  const WatchLaterNow({Key? key, this.userModel, this.firebaseuser, required this.val}) : super(key: key);
  final UserModel? userModel;
  final User? firebaseuser;
  final int val;
  @override
  State<WatchLaterNow> createState() => _WatchLaterNowState();
}

class _WatchLaterNowState extends State<WatchLaterNow> {
  @override
  Widget build(BuildContext context) {
    UserModel user = widget.userModel!;
    List<dynamic> x = widget.val==1?user.MoviesInWatchList!:user.MoviesWatched;
   // var data=fetchdata("https://api.themoviedb.org/3/movie/949?api_key=${apikey}",x);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black,),
      ),
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            FutureBuilder<List<Movie>>(
              future: fetchdata(user,widget.val),
              builder: (context,snapshot){

                if(snapshot.connectionState==ConnectionState.done){
                  if(snapshot.hasData){

                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),

                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context,index){
                          //         print(snapshot.data![index].MovieName);
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder:(context)=>MovieDetails(movie: snapshot.data![index],firebaseuser: widget.firebaseuser,userModel: widget.userModel) ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          margin: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Colors.grey,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://image.tmdb.org/t/p/w780"+snapshot.data![index].MovieUrl.toString()
                                                ),
                                                fit: BoxFit.cover),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Color(0xff3C3261),
                                                  blurRadius: 5.0,
                                                  offset: Offset(2.0, 5.0))
                                            ],
                                          ),
                                          child: Container(
                                            width: 70.0,
                                            height: 70.0,
                                          ),
                                        ),
                                      ),
                                      Expanded(

                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(16.0,0.0,16.0,0.0),
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                              Text(
                                                (snapshot.data![index].MovieName)!,
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: 'Arvo',
                                                    fontWeight: FontWeight.bold,
                                                    color:Colors.white),
                                              ),
                                              const Padding(padding: EdgeInsets.all(2.0)),
                                              Text((snapshot.data![index].MovieSummary)!,
                                                maxLines: 3,
                                                style: const TextStyle(
                                                    color: Color(0xff8785A4),
                                                    fontFamily: 'Arvo'
                                                ),)
                                            ],),
                                          )
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 300.0,
                                    height: 0.5,
                                    color: const Color(0xD2D2E1ff),
                                    margin: const EdgeInsets.all(16.0),
                                  )
                                ],
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
          ],
        ),
      ),
    );
  }
}

Future<List<Movie>> fetchdata(UserModel userModel,int val) async {
  List<dynamic> data = [];

  if(val==1) {
    List<Movie> list = [];
    List entries = userModel.MoviesInWatchList!;
    for (int i = 0; i < entries.length; i++) {
      //print(entries[i]);
      Response response = await get(Uri.parse(
          "https://api.themoviedb.org/3/movie/${entries[i]}?api_key=${apikey}"));

      var decoded1 = jsonDecode(response.body);
      Movie movie = Movie.fromJson(decoded1);
      list.add(movie);
      // print(movie.MovieName);
    }

    return list;
  }
  else{
    List data = userModel.MoviesWatched;
    List<Movie> l=[];
    for(int i=1;i<data.length;i++){
      var e;
      var entry=data[i].keys.forEach((element) {
        e=element;
      });
      Response response = await get(Uri.parse(
          "https://api.themoviedb.org/3/movie/${e}?api_key=${apikey}"));

      var decoded1 = jsonDecode(response.body);
      Movie movie = Movie.fromJson(decoded1);
      l.add(movie);

    }

    return l;
  }
//   List decoded = decoded1["output"];
// //  print(decoded);
//   List<Movie> x = [];
//   var m = decoded.map((e) {
//     // print("object");
//     // print(e['title']);
//     //  print(class(e));
//     x.add(Movie.fromJson(e));
//   });
//   print(m);
//   return x;
//  return decoded.map((e) => Movie.fromJson(e)).toList();
}
