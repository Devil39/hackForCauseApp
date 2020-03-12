import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// import 'package:hackforcause/screens/chatScreen.dart';
import 'package:hackforcause/screens/loginPage.dart';
import 'package:hackforcause/screens/homePage.dart';
import 'package:hackforcause/scoped_models/mainModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final MainModel _model=MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
          child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
        home: LoginPage(),
        // initialRoute: '/',
        routes: {
          // '/': (context)=>MyApp(),
          '/login': (context)=>LoginPage(),
          '/home': (context)=>HomePage(),
          // '/chatScreen': (context)=>ChatScreen(),
        }
      ),
    );
  }
}