
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models.dart';

class FirebaseHelper{
  static Future<UserModel?> GetUserModelById(String uid ) async{
    UserModel? user;
    DocumentSnapshot docsnap=await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(docsnap.data()!=null){
      user = UserModel.fromMap(docsnap.data() as Map<String,dynamic>);
    }
    return user;
  }

  Future<String> uploadtostorage(String childname,Uint8List file,bool isPost) async{
    Reference ref = FirebaseStorage.instance.ref().child(childname).child(FirebaseAuth.instance.currentUser!.uid);
    if(isPost){
      ref=ref.child(const Uuid().v1());
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap =await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }
  Future<String> uploadPost(
      Uint8List file
      ) async{
    try{
      String photourl= await uploadtostorage("Posts", file, true);
     // print(photourl);
      return photourl;
    }
    catch(err){
      print(err);
      return err.toString();
    }
  }
}
