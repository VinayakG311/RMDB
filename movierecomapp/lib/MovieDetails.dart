import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movierecomapp/models.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({Key? key,this.movie, this.userModel, this.firebaseuser}) : super(key: key);
  final UserModel? userModel;
  final User? firebaseuser;
  final Movie? movie;
  static const String id ="details";
  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {

  @override
  Widget build(BuildContext context) {
    Movie movie=widget.movie!;
    var x=widget.userModel!;

    TextEditingController controller = TextEditingController();
    int min=0;
    int max=10;
    int val=0;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white,),
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: SizedBox(
              height: 50,
              width: 130,
              child: Card(
                  color:Color(0xffffC75F),
                  child: Center(child: Text('RMDb',style: TextStyle(fontSize:30,color: Colors.black,fontWeight: FontWeight.w800),)))),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
       // crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Image.network("https://image.tmdb.org/t/p/w342"+movie.MovieUrl.toString(),fit: BoxFit.cover,),
           BackdropFilter(
             filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
             child: Container(
               color: Colors.black.withOpacity(0.5),
             ),
           ),
           SingleChildScrollView(
             child: Container(
               margin: const EdgeInsets.all(20),
               child: Column(
                 children: [
                   Container(
                     alignment: Alignment.center,
                     child: Container(
                       width: 400.0,
                       height: 400.0,
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10.0),
                         image: DecorationImage(image: NetworkImage("https://image.tmdb.org/t/p/w780"+movie.MovieUrl.toString()),fit: BoxFit.cover),
                         boxShadow: const [
                           BoxShadow(
                               color: Colors.black,
                               blurRadius: 20.0,
                               offset: Offset(0.0, 10.0)
                           )
                         ]
                     ),
                   ),
                   ),
               Container(
                 margin: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 0.0),
                 child: Row(

                   children: <Widget>[
                     Expanded(child: Text(movie.MovieName!,style: const TextStyle(color: Colors.white,fontSize: 30.0,fontFamily: 'Arvo'),)),
                     Text(movie.VoteAverage.toString(),style: const TextStyle(color: Colors.white,fontSize: 20.0,fontFamily: 'Arvo'),)
                   ],
                 ),
               ),
                   Text(movie.MovieSummary.toString(),style: const TextStyle(color: Colors.white, fontFamily: 'Urbanist')),
                   const Padding(padding: EdgeInsets.all(10.0)),
                   Row(
                     children: <Widget>[
                       Expanded(
                           child: InkWell(
                             onTap:(){
                               showDialog(context: (context),
                                   builder: (BuildContext context)=>AlertDialog(
                                 title: Text("Rate movie"),
                                     content: TextField(
                                       controller: controller,
                                       keyboardType: TextInputType.number,
                                       onChanged: (String value){
                                         int x;

                                         if(value==""){
                                           x=0;
                                         }
                                         else {
                                           x = int.parse(value);
                                         }
                                         if(x>=min && x<=max){
                                           val=x;
                                         }
                                         else{
                                           controller.text="10";
                                         }

                                       },
                                     ),
                                     actions: [
                                       TextButton(
                                         onPressed: () => Navigator.pop(context, 'Cancel'),
                                         child: const Text('Cancel'),
                                       ),
                                       TextButton(
                                         onPressed: () async
                               {
                                 print(val);
                                 UserModel m = widget.userModel!;
                               //  List<dynamic> l = m.MoviesWatched;
                                 List l = m.MoviesWatched;
                                 //    print(m.MoviesInWatchList);
                                 int j=-1;
                                 for(int i=0;i<l.length;i++){
                                   if(l[i].containsKey(movie.MovieId.toString())){
                                     j=i;
                                   }
                                 }
                                 if(j!=-1){
                                   m.MoviesWatched[j][movie.MovieId.toString()]=val.toString();
                                   m.MoviesWatchedandRated[j][movie.MovieName.toString()]=val.toString();
                                 }
                                 else {
                                   m.MoviesWatched.add({movie.MovieId.toString():val.toString()});
                                   m.MoviesWatchedandRated.add({movie.MovieName.toString():val.toString()});

                                   //    m.MoviesWatched?.add(movie.MovieId!);
                                 }
                                 setState(() {
                                   x=m;
                                 });

                                 await FirebaseFirestore.instance.collection("users").doc(widget.userModel?.uid).set(m.toMap());

                                 Navigator.pop(context, 'OK');
                               },
                                         child: const Text('OK'),
                                       ),
                                     ],
                               ));
                             },
                             child: Container(
                               width: 150.0,
                               height: 60.0,
                               alignment: Alignment.center,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10.0),
                                   color: const Color(0xaa3C3261)),
                               child: const Text(
                                 'Rate Movie',
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontFamily: 'Arvo',
                                     fontSize: 20.0),
                               ),
                             ),
                           )),
                       Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Container(
                           padding: const EdgeInsets.all(16.0),
                           alignment: Alignment.center,
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(10.0),
                               color: const Color(0xaa3C3261)),
                           child: const Icon(
                             Icons.share,
                             color: Colors.white,
                           ),
                         ),
                       ),
                       Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: InkWell(
                             onTap: () async {
                           //    print("object");
                           //    print(widget.userModel);
                               UserModel m = widget.userModel!;
                               List<dynamic> l = m.MoviesInWatchList!;
                           //    print(m.MoviesInWatchList);
                               if(l.contains(movie.MovieId)){
                                 m.MoviesInWatchList?.remove(movie.MovieId!);
                               }
                               else {
                                 m.MoviesInWatchList?.add(movie.MovieId!);
                               }
                               setState(() {
                                 x=m;
                               });
                               // print(movie.MovieId!);
                               // print(m.MoviesInWatchList);
                               await FirebaseFirestore.instance.collection("users").doc(widget.userModel?.uid).set(m.toMap());
                             },
                             child: Container(
                               padding: const EdgeInsets.all(16.0),
                               alignment: Alignment.center,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10.0),
                                   color: const Color(0xaa3C3261)),
                               child: Icon(
                                 //Icons.bookmark,
                                 x.MoviesInWatchList!.contains(movie.MovieId!) ? Icons.bookmark:Icons.bookmark_border,
                                 color: Colors.white,
                               ),
                             ),
                           )
                       ),
                       Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: InkWell(
                             onTap: () async{
                               showDialog(context: (context),
                                   builder: (BuildContext context)=>AlertDialog(
                                     title: Text("Rate movie"),
                                     content: TextField(
                                       controller: controller,
                                       keyboardType: TextInputType.number,
                                       onChanged: (String value){
                                         int x;

                                         if(value==""){
                                           x=0;
                                         }
                                         else {
                                           x = int.parse(value);
                                         }
                                         if(x>=min && x<=max){
                                           val=x;
                                         }
                                         else{
                                           controller.text="10";
                                         }

                                       },
                                     ),
                                     actions: [
                                       TextButton(
                                         onPressed: () => Navigator.pop(context, 'Cancel'),
                                         child: const Text('Cancel'),
                                       ),
                                       TextButton(
                                         onPressed: () async
                                         {
                                           print(val);
                                           UserModel m = widget.userModel!;
                                           //  List<dynamic> l = m.MoviesWatched;
                                           List l = m.MoviesWatched;
                                           //    print(m.MoviesInWatchList);
                                           int j=-1;
                                           for(int i=0;i<l.length;i++){
                                             if(l[i].containsKey(movie.MovieId.toString())){
                                               j=i;
                                             }
                                           }
                                           if(j!=-1){
                                             m.MoviesWatched[j][movie.MovieId.toString()]=val.toString();
                                             m.MoviesWatchedandRated[j][movie.MovieName.toString()]=val.toString();
                                           }
                                           else {
                                             m.MoviesWatchedandRated.add({movie.MovieName.toString():val.toString()});
                                             //    m.MoviesWatched?.add(movie.MovieId!);
                                           }
                                           setState(() {
                                             x=m;
                                           });

                                           await FirebaseFirestore.instance.collection("users").doc(widget.userModel?.uid).set(m.toMap());

                                           Navigator.pop(context, 'OK');
                                         },
                                         child: const Text('OK'),
                                       ),
                                     ],
                                   ));
                             //   UserModel m = widget.userModel!;
                             //   List<dynamic> l = m.MoviesWatched;
                             //   //    print(m.MoviesInWatchList);
                             //   if(l.contains(movie.MovieId)){
                             //     m.MoviesWatched.remove(movie.MovieId!);
                             //   }
                             //   else {
                             // //    m.MoviesWatched?.add(movie.MovieId!);
                             //   }
                             //   setState(() {
                             //     x=m;
                             //   });
                             //
                             //   await FirebaseFirestore.instance.collection("users").doc(widget.userModel?.uid).set(m.toMap());


                             },
                             child: Container(
                               padding: const EdgeInsets.all(16.0),
                               alignment: Alignment.center,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10.0),
                                   color: const Color(0xaa3C3261)),
                               child: Icon(
                                 ((){
                                   int u=0;
                                   for(int i=0;i<x.MoviesWatched.length;i++){
                                     if(x.MoviesWatched[i].containsKey(movie.MovieId!)){
                                       u=1;
                                       return Icons.remove_red_eye;
                                     }
                                   }

                                   return u==0?Icons.remove_red_eye_outlined:Icons.remove_red_eye;
                                 }()),
                                 //Icons.remove_red_eye,
                              //   x.MoviesWatched!.contains(movie.MovieId!) ? Icons.remove_red_eye:Icons.remove_red_eye_outlined,
                                 color: Colors.white,
                               ),
                             ),
                           )
                       ),
                     ],
                   )
                 ],
               ),
             ) ,
           ),

         ],

      ),
    );
  }
}
