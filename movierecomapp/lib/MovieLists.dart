import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MovieDetails.dart';
import 'MyApp.dart';
import 'ProfileScreen.dart';
import 'models.dart';

class MoveListsByGenre extends StatefulWidget {
  const MoveListsByGenre({Key? key, required this.url, this.userModel, this.firebaseuser}) : super(key: key);
  final String url;
  final UserModel? userModel;
  final User? firebaseuser;
  @override
  State<MoveListsByGenre> createState() => _MoveListsByGenreState();
}

class _MoveListsByGenreState extends State<MoveListsByGenre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black,),
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ProfileScreen()));
                },
                child: const CircleAvatar(

                ),
              ),
            )
          ],
        )],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            FutureBuilder<List<Movie>>(
              future: fetchdata(widget.url),
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
                              Navigator.push(context, MaterialPageRoute(builder:(context)=>MovieDetails(movie: snapshot.data![index],firebaseuser: widget.firebaseuser,userModel: widget.userModel,) ));
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
