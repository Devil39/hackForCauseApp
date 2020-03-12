import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:hackforcause/scoped_models/shared.dart';
import 'package:hackforcause/models/user.dart';
import 'package:hackforcause/scoped_models/urls.dart';

mixin UserModel on Model{

  // var b=jsonEncode({
  //   time: "Mon Mar 09 2020 02:56:55 GMT+0000 (Coordinated Universal Time)", token: "cpLBAAA", fileName: "sarthak.jpg"});

  var notifyList=[];

  void addToNotifyList(a){
    notifyList.add(a);
    print(notifyList);
  }

  void _onChageDetection(Event event) {
    print("Change happened!");
    // print(event);
    // print(event.toString());
    // print(event.previousSiblingKey);
    // print(event.snapshot);
    DataSnapshot change=event.snapshot;
    // // // print(change.key);
    // // // print(change.value);
    // print(change.toString());
    // print(event.);
  }

  void setUpListener(){
    var childRef;
    final DBRef=FirebaseDatabase.instance.reference();
    print(DBRef);
    print(DBRef.child('notification'));
    childRef=DBRef.child('notification').onChildChanged.listen(_onChageDetection);
    print("Listener Set!");
  }

  Future<dynamic> addTrustedUser(String name, String url) async {
   var statuscode;
   var message;
  //  var body;
   var body=json.encode({
      "name": name,
      "url": url
   });
   print("BOdy1");
   print(body);
   try{
      print("Sending trust Request!");
      // print(body);
      http.Response response=await http.post(
          url_addTrustedUser,
          // "",
          headers: {"Content-type": "application/json"},
          body: body
      );
      print("Response trust:");
      print(response.statusCode);
      print(response.body);
      statuscode=response.statusCode;
      if(response.statusCode==200)
       {
        //  print("User:");
        //  print(user.uid);
        return jsonDecode(response.body);
      }
      else{
        if(response.statusCode==500 || response.statusCode==400 || response.statusCode==404)
          {
            throw "Server Error!";
          }
        else{
          print("This wala error!");
          message=jsonDecode(response.body)["message"];
          throw message;
        }
      }
   }
  catch(err){
    print("Error trusting!....$err");
    return {
      "code": statuscode,
      "message": err
    };
  }
 }  

  Future<dynamic> addPersonImage(File file, String fileName, bool trusted) async {
    StorageReference storageReference;
    if(trusted)
     {
       storageReference=FirebaseStorage.instance.ref().child("cpLBAAA/trusted/$fileName");
     }
    else{
      storageReference=FirebaseStorage.instance.ref().child("cpLBAAA/unknown/$fileName");
    }
    final StorageUploadTask uploadTask=storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    if(trusted)
     {
       addTrustedUser(fileName, url);
     }
    print("URL is $url");
 }

  // Future<dynamic> logIn(String uid, String name) async {
  Future<dynamic> logIn(User user) async {
   var statuscode;
   var message;
  //  var body;
   var body=json.encode({
      "uid": user.uid,
      "username": user.name,
      "email": user.email
   });
  //  print("BOdy1");
  //  print(body);
   try{
      print("Sending Log In Request!");
      // print(body);
      http.Response response=await http.post(
          url_register,
          // "",
          headers: {"Content-type": "application/json"},
          body: body
      );
      print("Response LogIn:");
      print(response.statusCode);
      print(response.body);
      statuscode=response.statusCode;
      if(response.statusCode==200)
       {
        //  print("User:");
        //  print(user.uid);
        Shared.setUserData(user);
        return jsonDecode(response.body);
      }
      else{
        if(response.statusCode==500 || response.statusCode==400 || response.statusCode==404)
          {
            throw "Server Error!";
          }
        else{
          print("This wala error!");
          message=jsonDecode(response.body)["message"];
          throw message;
        }
      }
   }
  catch(err){
    print("Error Logging In!....$err");
    return {
      "code": statuscode,
      "message": err
    };
  }
 }

 Future<dynamic> getListOfKnowns() async {
   var statuscode;
   var message;
   try{
      print("Sending get list Request!");
      // print(body);
      http.Response response=await http.get(
          url_getListOfKnowns,
          // "",
          headers: {"Content-type": "application/json"},
      );
      print("Response get list:");
      print(response.statusCode);
      print(response.body);
      statuscode=response.statusCode;
      if(response.statusCode==200)
       {
        //  print("User:");
        //  print(user.uid);
        return jsonDecode(response.body);
      }
      else{
        if(response.statusCode==500 || response.statusCode==400 || response.statusCode==404)
          {
            throw "Server Error!";
          }
        else{
          print("This wala error!");
          message=jsonDecode(response.body)["message"];
          throw message;
        }
      }
   }
  catch(err){
    print("Error get list!....$err");
    return {
      "code": statuscode,
      "message": err
    };
  }
 }  
}