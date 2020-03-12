import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:hackforcause/models/user.dart';

SharedPreferences pref;

class Shared{
  static void setUserData(User user){
    // print(user.uid);
    // print(pref);
    // print(pref!=null);
    // print("1");
    // print(user.toString());
    // print("2");
    // print(jsonEncode(user));
    // print("3");
    if(pref!=null){
      pref.setString('userDetails', jsonEncode(user.toJson()));
      print("User Details Set!");
    }
    else{
      print("Error saving user details!");
    }
  }

  static dynamic getUserDetails() async {
   if(pref!=null)
    {
      // return jsonDecode(pref.getString('userDetails'));
      return jsonDecode(pref.getString('userDetails'));
    }
   else{
     print("Error getting user details");
     return "";
   }
  }

 static void initialize() async {
   SharedPreferences.setMockInitialValues({});
   if(pref==null)
    {
      pref = await SharedPreferences.getInstance();
      print("Shared preferences initialized!");
    }
   else{
     return;
   }
  }
}