import 'dart:io';
// import 'dart:math';

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:hackforcause/screens/notificationsPage.dart';
import 'package:hackforcause/screens/profilePage.dart';
import 'package:hackforcause/screens/homePage.dart';
import 'package:hackforcause/scoped_models/mainModel.dart';
import 'package:hackforcause/widgets/personCard.dart';
import 'package:hackforcause/main.dart';

class PeoplePage extends StatefulWidget {
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {

  String imgPath;

  int index;

  bool _trustValue=false, _nontrustValue=false;

  File file;
  String fileType='';
  String fileName='';
  List listKnown=[];

  TextEditingController _controller=new TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // final MainModel model=MainModel();

  Future showNotificationWithoutSound(var a) async {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          // playSound: false, importance: Importance.Max, priority: Priority.High);
      );
      // var iOSPlatformChannelSpecifics =
      //     new IOSNotificationDetails(presentSound: false);
      var iOSPlatformChannelSpecifics =
           new IOSNotificationDetails();
      var platformChannelSpecifics = new NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'Alert',
        'Suspicious activity detected at '+a["time"],
        //time: Mon Mar 09 2020 02:56:55 GMT+0000 (Coordinated Universal Time), token: cpLBAAA, fileName: sarthak.jpg}
        platformChannelSpecifics,
        // payload: 'No_Sound',
        payload: 'Notification',
      );
    }

  // final MainModel _model=MainModel();
  MainModel _model;

  Future onSelectNotification(String payload) async {
    // print("onSelectNotification");
    // debugPrint("payload: $payload");
    // showDialog(
    //   context: context,
    //   builder: (_)=>AlertDialog(
    //     title: Text("Notification"),
    //     content: Text(payload),
    //   ),
    // );
    // showDialog(
    //   context: context,
    //   builder: 
    // );
  }

  void _initializePage() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  @override
  void initState(){
    super.initState();
    // final MainModel model=MainModel();
    // model.setUpListener();
    _initializePage();
    setUpListener();
  }

  Future<void> getListOfKnowns(MainModel model){
    var a=model.getListOfKnowns();
    // print("Smething");
    // print(a);
    a.then((val){
      // print(val);
      setState(() {
        listKnown=val["payload"]["listKnowns"];
      });
      // print("<__>");
      // print(listKnown);
    });
    // listKnown=a;
  }

  Future<void> getList(MainModel model) async {
    await getListOfKnowns(model);
  }

  void _onChageDetection(Event event) {
    print("Change happened!");
    DataSnapshot change=event.snapshot;
    print(change.key);
    print(change.value);
    showNotificationWithoutSound(change.value);
    if(_model!=null)
     {
       _model.addToNotifyList(change.value);
     }
    else
     {
       print("Model is called on null!");
     }
    // onSelectNotification("Something Something");
  }

  void setUpListener(){
    var childRef;
    final DBRef=FirebaseDatabase.instance.reference();
    print(DBRef);
    print(DBRef.child('notification'));
    childRef=DBRef.child('notification').onChildChanged.listen(_onChageDetection);
    print("Listener Set!");
  }

  Future filePicker(BuildContext context, MainModel model) async {
    try {
      if (fileType == 'image') {
        file = await FilePicker.getFile(type: FileType.IMAGE);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        // model.addPersonImage(file, fileName, _trustValue?true:false);
      }
      if (fileType == 'audio') {
        file = await FilePicker.getFile(type: FileType.AUDIO);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        // model.addPersonImage(file, fileName, _trustValue?true:false);
      }
      if (fileType == 'video') {
        file = await FilePicker.getFile(type: FileType.VIDEO);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        // model.addPersonImage(file, fileName, _trustValue?true:false);
      }
      if (fileType == 'pdf') {
        file = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'pdf');
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        // model.addPersonImage(file, fileName, _trustValue?true:false);
      }
      if (fileType == 'others') {
        file = await FilePicker.getFile(type: FileType.ANY);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        // model.addPersonImage(file, fileName, _trustValue?true:false);
      }
    } on PlatformException catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        );
    }
  }

  void _modalBottomSheetMenu1(MainModel model){
    // setState(() {
    //   index=2;
    // });
    _model=model;
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Container(
            // width: double.infinity,
            height: MediaQuery.of(context).size.height*0.3,
            color: Color(0xff121212),
            child: Column(
              children: <Widget>[
                Container(
                  child: Wrap(
                    children: <Widget>[
                      AppBar(
                        leading: Container(),
                        title: Text("Add a new person"),
                        centerTitle: true,
                        actions: <Widget>[
                          IconButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.clear),
                          ),
                        ],
                        backgroundColor: Color(0xff121212),
                        elevation: 0.0, 
                      ),
                      GestureDetector(
                        onTap: () async {
                          // MyApp().showNotificationWithoutSound();
                          // print("Here!");
                          // var file1 = await ImagePicker.pickImage(source: ImageSource.gallery);
                          // print(file);
                          setState(() {
                            fileType='image';
                          });
                          // if(file1!=null)
                          //  {
                          //    setState(() {
                          //      imgPath=file1.path;
                          //      fileType='image';
                          //      file=file1;
                          //    });
                          //   //  print("File:");
                          //   //  print(file.path);
                          //    Navigator.of(context).pop();
                          //    _modalBottomSheetMenu2();
                          //  }

                          await filePicker(context, model);
                          if(file!=null)
                           {
                             setState(() {
                              imgPath=file.path;
                            });
                           }
                          Navigator.of(context).pop();
                          _modalBottomSheetMenu2(model);

                          // if(file!=null)
                          //  {
                          //  }
                        },
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Use a camera",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 2.0,
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(
                                Icons.photo,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  fileType='image';
                                });
                                await filePicker(context, model);
                                if(file!=null)
                                {
                                  setState(() {
                                    imgPath=file.path;
                                  });
                                }
                                Navigator.of(context).pop();
                                _modalBottomSheetMenu2(model);
                              },
                              child: Text(
                                "Choose from gallery",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  List<Widget> makeListOfKnowns(){
    print(listKnown);
    if(listKnown.length!=0)
     {
       var a=<Widget>[];
       if(listKnown.length%2==0)
        {
          for(int i=0;i<listKnown.length;i+=2)
            {
              a.add(
                Row(
                  children: <Widget>[
                    PersonCard(name: listKnown[i]["name"],url: listKnown[i]["url"]),
                    PersonCard(name: listKnown[i+1]["name"],url: listKnown[i+1]["url"]),
                  ],
                )
              );
            }
          print(a);
        }
       else{
        //  print(listKnown[0]["name"]);
        int i=0;
         for(i=0;i<(listKnown.length/2).floor();i+=2)
            {
              a.add(
                Row(
                  children: <Widget>[
                    PersonCard(name: listKnown[i]["name"],url: listKnown[i]["url"]),
                    PersonCard(name: listKnown[i+1]["name"],url: listKnown[i+1]["url"]),
                  ],
                )
              );
            }
          a.add(
            PersonCard(name: listKnown[i]["name"],url: listKnown[i]["url"]),
          );
          print(a);
       }
       return a;
     }
    else{
      return [Container(
        height: MediaQuery.of(context).size.height*0.6,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )];
    }
  }

  void _modalBottomSheetMenu2(MainModel model){
    _trustValue=false; 
    _nontrustValue=false;
    setState(() {
      index=1;
    });
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return SingleChildScrollView(
                      child: Container(
              // width: double.infinity,
              height: MediaQuery.of(context).size.height*0.60,
              color: Color(0xff121212),
              child: ListView(
                children: <Widget>[
                  AppBar(
                    leading: Container(),
                    title: Text("Save a new person"),
                    centerTitle: true,
                    actions: <Widget>[
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ],
                    backgroundColor: Color(0xff121212),
                    elevation: 0.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        labelText: "Enter the person's name here",
                        labelStyle: TextStyle(
                          color: Colors.white
                        ),
                        // labelStyle: TextStyle(
                        //   color: Colors.white
                        // ),
                        // fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Image.asset(
                      imgPath,
                      // height: MediaQuery.of(context).size.height*0.5,
                      // width: double.infinity,
                    ),
                  ),
                  Container(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              value: _trustValue,
                              onChanged: (val){
                                setState(() {
                                  // print(_trustValue);
                                  _trustValue=val;
                                });
                              },
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.0),
                              child: Text(
                                "Trust",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.0),
                              child: Image.asset('assets/Trusted.png'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              value: _nontrustValue,
                              onChanged: (val){
                                setState(() {
                                  // print(!_nontrustValue);
                                  _nontrustValue=val;
                                });
                              },
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.0),
                              child: Text(
                                "Don't Trust",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.0),
                              child: Image.asset('assets/NotTrusted.png'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
                    child: FlatButton(
                      onPressed: () async {
                        await model.addPersonImage(file, _controller.text, _trustValue?true:false);
                        Navigator.of(context).pop();
                      },
                      color: Color(0xff4298B8),
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        _model=model;
        print("1");
        getList(model);
        print("2");
        return Scaffold(
          body: Container(
            width: double.infinity,//MediaQuery.of(context).size.width
            height: double.infinity,//MediaQuery.of(context).size.height
            color: Color(0xffb121212),
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 27.0, left: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "People",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 3.0, bottom: 3.0),
                    child: Container(
                      // width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        // color: Color(0xff1F1F1F),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          // color: Colors.red
                        )
                      ),
                      child: Column(
                        children: 
                        makeListOfKnowns()
                        // <Widget>[
                        //   // GridView.builder(
                        //   //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //   //     crossAxisCount: 2
                        //   //   ),
                        //   //   itemBuilder: (BuildContext context, int index){
                        //   //     return PersonCard();
                        //   //   }
                        //   // ),
                        //   Wrap(
                        //     children: <Widget>[
                        //       PersonCard(),
                        //       PersonCard(),
                        //       PersonCard(),
                        //       // ListView.builder(
                        //       //   itemCount:
                        //       //   // listKnown.length==0?1:listKnown.length,
                        //       //   2,
                        //       //   itemBuilder: (BuildContext context, int index){
                        //       //     return Container();
                        //       //   },
                        //       // ),
                        //       // PersonCard(),
                        //     ],
                        //   ),
                        //   // Row(
                        //   //   children: <Widget>[
                        //   //     PersonCard(),
                        //   //     PersonCard(),
                        //   //   ],
                        //   // ),
                        // ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(6.0),
                            child: GestureDetector(
                              onTap: (){
                                // Navigator.of(context).pop();
                              if(index==null)
                                {
                                  index=1;
                                }
                                if(index==1)
                                {
                                  // showNotificationWithoutSound();
                                  _modalBottomSheetMenu1(model);


                                  // _modalBottomSheetMenu2();
                                  //  return;
                                }
                              },
                              child: Text(
                                "+ Add a person",
                                style: TextStyle(
                                  color: Color(0xff4298B8),
                                  fontSize: 21
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              "You can change a person's status by a long press",
                              style: TextStyle(
                                color: Color(0xffB8B8B8),
                                fontSize: 14
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],           
              ),
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
                          color: Colors.blue
                        ),
                        onPressed: (){},
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
      },
          // child: ,
    );
  }
}