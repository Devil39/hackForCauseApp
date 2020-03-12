import 'package:flutter/material.dart';

import 'package:hackforcause/screens/notificationsPage.dart';
import 'package:hackforcause/screens/homePage.dart';
import 'package:hackforcause/screens/peoplePage.dart';
import 'package:hackforcause/widgets/friendCard.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        width: double.infinity,
        height: double.infinity,
        color: Color(0xff121212),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      "G",
                      style: TextStyle(
                        fontSize: 24
                      ),
                    ),
                    radius: 30.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Gagan Varma",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0
                          ),
                        ),
                        Text(
                          "gagan@gmail.com",
                          style: TextStyle(
                            color: Color(0xffB8B8B8),
                            fontSize: 12.0
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.sync,
                    color: Colors.white,
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      "Switch to another group",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 5.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 5.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      "Members at Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24
                      ),
                      // textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            FriendCard(name: "Sarthak", url: "assets/sarthak.png"),
                            FriendCard(name: "Ankush", url: "assets/ankush.png"),
                          ],
                        ),
                        // Row(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
            color: Color(0xff121212),        
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  /*decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),*/
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.home,
                          color: Colors.white
                      ),
                        onPressed: (){
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return HomePage();
                              }),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.people,
                          color: Colors.white
                        ),
                        onPressed: (){
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return PeoplePage();
                              }),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: Colors.white
                        ),
                        onPressed: (){
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return NotificationsScreen();
                              }),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.person,
                          color: Colors.blue
                        ),
                        onPressed: (){
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return ProfilePage();
                          //     }),
                          // );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}