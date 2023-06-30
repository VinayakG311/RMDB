import 'dart:ffi';

import 'package:flutter/material.dart';

class Movie{
  String? MovieName;
  String? MovieUrl;
  String? MovieSummary;
  List<String>? MovieGenre;
  bool? isAdult;
  String? Lang;
  double? popularity;
  String? Tagline;
  double? VoteAverage;
  int? VoteCount;
  int? MovieId;

  Movie.name(
      this.MovieId,
      this.MovieName,
      this.MovieUrl,
      this.MovieSummary,
      this.MovieGenre,
      this.isAdult,
      this.Lang,
      this.popularity,
      this.Tagline,
      this.VoteAverage,
      this.VoteCount);
  Movie.fromJson(Map<String,dynamic> json){
    MovieGenre=[];
   // var json=json1["output"];
        MovieName=json['title'];
        MovieUrl=json['poster_path'];
         MovieSummary=json['overview'];
         List<dynamic> genre=json['genres'];
     //    print(genre);
        for(var i in genre){
          MovieGenre?.add(i["name"]);
        }
        isAdult=json['adult'];
        Lang=json['original_language'];
        popularity=json['popularity'];
        Tagline=json['tagline'];
        VoteAverage=json['vote_average'];
        VoteCount=json['vote_count'];
        MovieId=json['id'];
  }
}

class UserModel{
  String? image;
  String? uid;
  String? firstname;
  String? lastname;
  String? email;
  String? phoneNumber;
  String? DateOfBirth;
  String? Gender;
  //List<dynamic> MoviesWatched=<int>[];
  List MoviesWatched = [{"0":"0"}];
  List MoviesWatchedandRated = [{}];
  List<dynamic>? MoviesInWatchList=[];
  bool? anonymity;
  UserModel({this.uid,this.firstname,this.email,this.phoneNumber});
  UserModel.fromMap(Map<String,dynamic> map){
    uid = map['uid'];
    firstname =  map['firstname'];
    lastname = map['lastname'];
    email = map['email'];
    phoneNumber = map['phoneNumber'];
    DateOfBirth = map['DateofBirth'];
    Gender = map['Gender'];
    anonymity=map['anonymity'];
    MoviesInWatchList=map['MoviesInWatchList'];
    MoviesWatched=map['MoviesWatched'];
    MoviesWatchedandRated=map['MoviesWatchedandRated'];
  }
  Map<String,dynamic> toMap(){
    return{
      "uid":uid,
      "firstname":firstname,
      "lastname":lastname,
      "email":email,
      "phoneNumber":phoneNumber,
      "DateofBirth":DateOfBirth,
      "Gender":Gender,
      "anonymity":anonymity,
      "MoviesWatched":MoviesWatched,
      "MoviesInWatchList":MoviesInWatchList,
      "MoviesWatchedandRated":MoviesWatchedandRated
    };

  }
}
class WatchedMoviesModel {
  int? MovieId;
  int? Rating;
  String? uid;
  WatchedMoviesModel({required this.MovieId,required this.Rating});
  WatchedMoviesModel.fromMap(Map<String,dynamic> map){
    uid = map['uid'];
    MovieId=map['MovieId'];
    Rating=map["Rating"];
  }
  Map<String,dynamic> toMap(){
    return{
      "uid":uid,
      "MovieId":MovieId,
      "Rating":Rating,

    };

  }

}