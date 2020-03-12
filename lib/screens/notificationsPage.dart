import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:hackforcause/scoped_models/mainModel.dart';
import 'package:hackforcause/screens/homePage.dart';
import 'package:hackforcause/screens/peoplePage.dart';
import 'package:hackforcause/screens/profilePage.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        return Scaffold(
        backgroundColor: Color(0xffb121212),
        body: Container(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 21.0, bottom: 0.0, left: 15.0),
                  child: Text(
                    "Notifications",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30
                    ),
                  ),
                ),
              ),
              model.notifyList.length==0
              ?
              Container(
                // width: double.infinity,
                // height: double.infinity,
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.8,
                child: Center(
                  child: Text(
                    "No notifications to show",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              )
              :
              Container(
                child: Expanded(
                  child: ListView.builder(
              itemCount: model.notifyList.length,
              itemBuilder: (BuildContext context, int index){
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(3.0),
                                child: Text(
                                    model.notifyList[index]["time"]==null
                                    ?
                                    "Intruder alert in the living room"
                                    :
                                    "Intruder alert outside",
                                    // model.notifyList[index]["time"],
                                    // textAlign: ,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18
                                    ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(3.0),
                                child: Text(
                                    // "13:30",//16
                                    model.notifyList[index]["time"]==null
                                    ?
                                    "13:30"
                                    :
                                    model.notifyList[index]["time"].substring(4, 10)+", "+model.notifyList[index]["time"].substring(16, 24),
                                    style: TextStyle(
                                      color: Color(0xffB8B8B8),
                                      fontSize: 12
                                    ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1.0,
                        ),
                      ],
                    ),
                  );
              }
            ),
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
                            color: Colors.blue
                          ),
                          onPressed: (){},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.person,
                            color: Colors.white
                          ),
                          onPressed: (){
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProfilePage();
                                }),
                            );
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
          // child: ,
    );
  }
}

/*ListView.builder(
            itemCount: 2,
            itemBuilder: (BuildContext context, int index){
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text("Intruder alert in the living room\n13:30"),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                    ],
                  ),
                );
            }
          )*/