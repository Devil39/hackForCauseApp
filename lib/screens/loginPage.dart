import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:hackforcause/scoped_models/shared.dart';

import 'package:hackforcause/models/user.dart';
import 'package:hackforcause/scoped_models/mainModel.dart';
import 'package:hackforcause/screens/homePage.dart';
import 'package:hackforcause/screens/peoplePage.dart';
import 'package:hackforcause/screens/notificationsPage.dart';
import 'package:hackforcause/screens/profilePage.dart';
import 'package:hackforcause/screens/test.dart';
// import 'package:hackforcause/screens/homePage.dart';
// import 'package:hackforcause/screens/dialogFlow.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Shared preferences initializing!");
    Shared.initialize();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle(MainModel model) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    // print('Registered User: $user');
    print('UID:');
    print(user.uid);
    if(user!=null && user.uid!=null)
     {
       var user1=User.fromJson({
         "uid": user.uid,
         "name": user.displayName==null?"Something":user.displayName,
         "email": user.email
       });
      //  model.logIn(user.uid, "Someone2");
      model.logIn(user1);
     }
    // //var resp=await 
    // var resp=await _setUpListener(user.uid);
    // //var a=json.decode(user);
    // //print('JSON Decoded $a');
    // //setName("Someone");
    // //final LoginPage state=new LoginPage();
    // //state.setName(user.displayName);
    // //setName(user.displayName);
    // //print("Name Set: $name");
    // setEmail(user.email);
    // setUID(user.uid);
    // //var uid=user.uid;
    // //print('UID: $uid');
    // print(user.runtimeType);
    // print('User Email: '+user.email);
    // return 'signInWithGoogle succeeded: $user';
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        return Scaffold(
          backgroundColor: Color(0xff121212),
        body: Container(
          // color: Colors.white,
          color: Color(0xff121212),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlutterLogo(size: 150),
                  SizedBox(height: 50),
                  _signInButton(model),
                ],
              ),
            ),
          ),
        );
      }
          // child: ,
    );
  }

  Widget _signInButton(MainModel model) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
      signInWithGoogle(model).whenComplete(() {
      print("Signed In!");
      Navigator.of(context).push(
        // Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            // return FirstScreen(name, email, uid);
            // return MyHomePage(title: "Something",);
            // return MessageList();
            // return HomePage();
            return PeoplePage();
            // return NotificationsScreen();
            // return ProfilePage();
            // return GetUserMediaSample();
            // return HomePageDialogflow();
          },
        ),
      );
    });
  },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}