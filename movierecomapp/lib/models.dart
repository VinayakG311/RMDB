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

  Movie.name(
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
    };

  }
}