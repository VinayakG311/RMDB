import 'package:flutter/material.dart';
import 'package:movierecomapp/models.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({Key? key,this.movie}) : super(key: key);
  final Movie? movie;
  static const String id ="details";

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    Movie movie=widget.movie!;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             SizedBox(
               height: 400,
               width: 400,
               child: Card(

                 child: Center(
                   child: Image.network("https://image.tmdb.org/t/p/w342"+movie.MovieUrl.toString()),
                 ),
               ),
             ),
             Text(movie.MovieName!,style: TextStyle(fontSize: 20),maxLines: 5,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Card(
                   color: Colors.transparent,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       SizedBox(
                         height: 40,
                         width: 90,
                         child: Card(
                             child: Center(child: Text(movie.VoteAverage.toString()))),
                       ),
                       Text(movie.VoteCount.toString()+" votes")
                     ],
                   ),
                 ),
                 TextButton(onPressed: (){}, child: Text("Add to Watchlist",style: TextStyle(color: Colors.white)))
               ],
             ),
             Text(movie.MovieSummary.toString(),maxLines: 10,),
             Text("Vote for the film"),
             Row(
               children: [
                 IconButton(onPressed: (){}, icon: Icon(Icons.thumb_up)),
                 IconButton(onPressed: (){}, icon: Icon(Icons.thumb_down)),

               ],
             ),
             TextButton(onPressed: (){}, child: Text("Rste the Movie",style: TextStyle(color: Colors.white),)),
             TextButton(onPressed: (){}, child: Text("Write a Review",style: TextStyle(color: Colors.white)))

           ],

        ),
      ),
    );
  }
}
