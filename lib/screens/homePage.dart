import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hackforcause/screens/peoplePage.dart';
import 'package:hackforcause/screens/notificationsPage.dart';
import 'package:hackforcause/screens/profilePage.dart';
import 'package:hackforcause/widgets/objectCard.dart';
import 'package:hackforcause/scoped_models/urls.dart';
import 'package:flutter/services.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hardware_buttons/hardware_buttons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Socket socket;

  int index=1;

  String imgPath;

  StreamSubscription _volumeButtonSubscription;

  @override
  void initState(){
    super.initState();
    // AudioPlayer.logEnabled = true;
    _volumeButtonSubscription = volumeButtonEvents.listen((VolumeButtonEvent event) {
      // do something
      // event is either VolumeButtonEvent.VOLUME_UP or VolumeButtonEvent.VOLUME_DOWN
      print("Volume Button");
      print(event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // be sure to cancel on dispose
    _volumeButtonSubscription?.cancel();
  }

  playLocal() async {
    print("Playing audio");
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(
        "assets/audio1.mp3",
    );
    // AudioPlayer audioPlayer = AudioPlayer();
    // int result = await audioPlayer.play('assets/audio1.mp3', isLocal: true);
  }

  void _setupSocket() async {
   print("1");
   await Socket.connect(socketUrl, 8080).then((Socket sock) {
   print("2");
   print(sock);
   socket = sock;
   socket.listen(dataHandler,
      onError: errorHandler,
      onDone: doneHandler,
      cancelOnError: false);
   print("<__>");
   print(sock);
   print(sock.toList());
   }).catchError((dynamic e) {//AsyncError
      print("Unable to connect: $e");
   });
   //Connect standard in to the socket
   stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
  }

  void dataHandler(data){
    print("<----->");
    print(new String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace){
    print(error);
  }

  void doneHandler(){
    socket.destroy();
  }

  void _modalBottomSheetMenu1(){
    // setState(() {
    //   index=2;
    // });
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
                        title: Text("Add a new object"),
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
                          // print("Here!");
                          var file = await ImagePicker.pickImage(source: ImageSource.gallery);
                          // print(file);
                          if(file!=null)
                           {
                             setState(() {
                               imgPath=file.path;
                             });
                            //  print("File:");
                            //  print(file.path);
                             Navigator.of(context).pop();
                             _modalBottomSheetMenu2();
                           }
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
                            Text(
                              "Choose from gallery",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21
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

  void _modalBottomSheetMenu2(){
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
                    title: Text("Save a new object"),
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
                      style: TextStyle(
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        labelText: "Add a name to the object",
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
                  imgPath==null
                  ?
                  Container()
                  :
                  Container(
                    child: Image.asset(
                      imgPath,
                      height: MediaQuery.of(context).size.height*0.5,
                      width: double.infinity,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
                    child: FlatButton(
                      onPressed: (){
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
    return Scaffold(
      body: Container(
        color: Color(0xffb121212),
        child: ListView(
          children: <Widget>[
            // Container(
            //   child: FlatButton(
            //     onPressed: (){
            //       _setupSocket();
            //     },
            //     child: Text(
            //       "Establish Socket",
            //       style: TextStyle(
            //         color: Colors.white
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 10.0),
              width: MediaQuery.of(context).size.width*0.9,
              child: Text(
                "Welcome,\nGagan Varma",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  // fontWeight: 
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width*0.8,
              decoration: BoxDecoration(
                color: Color(0xff1F1F1F),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  // color: Colors.red,
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // margin: EdgeInsets.only(top: 3.0),
                    padding: EdgeInsets.only(top: 9.0),
                    child: Align(
                      child: Text(
                        "Living Room",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26
                        ),
                      ),
                    ),
                  ),
                  Wrap(
                    children: <Widget>[
                      ObjectCard(),
                      ObjectCard(name: 'Fish Bowl', url: 'assets/fishBowl.png'),
                      // ObjectCard(),
                      // ObjectCard(),
                    ],
                  ),
                  // Row(
                  //   children: <Widget>[
                  //   ],
                  // ),
                  Container(
                    margin: EdgeInsets.all(3.0),
                    child: GestureDetector(
                      onTap: (){
                        // _modalBottomSheetMenu2();
                        // _modalBottomSheetMenu1();
                        if(index==null)
                         {
                           index=1;
                         }
                        if(index==1)
                         {
                          //  _modalBottomSheetMenu1();
                          _modalBottomSheetMenu2();
                          //  return;
                         }
                        // Navigator.of(context).pop();
                        // print("Index: $index");
                        // if(index==null)
                        //  {
                        //    setState(() {
                        //      index=1;
                        //    });
                        //  }
                        // if(index==1)
                        //  {
                        //    _modalBottomSheetMenu2();
                        //    _modalBottomSheetMenu1();
                        //    return;
                        //  }
                        // if(index==2)
                        //  {
                        //    _modalBottomSheetMenu2();
                        //  }
                      },
                      child: Text(
                        "+ Add and object",
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
                      "Long Press on an object to remove from list",
                      style: TextStyle(
                        color: Color(0xffB8B8B8),
                        fontSize: 14
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Container(
                margin: EdgeInsets.only(left: 27.0, right: 27.0, top: 10.0, bottom: 20.0),
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red
                  ),
                ),
                child: GestureDetector(
                  onTap: (){
                    print("Live On!");
                    playLocal();
                  },
                  child: Text(
                    "LIVE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 24
                    ),
                  ),
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
                      color: Colors.blue
                  ),
                    onPressed: (){},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.people,
                      color: Color(0xffE5E5E5)
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
                      color: Color(0xffE5E5E5)
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
                      color: Color(0xffE5E5E5)
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
            // Container(
            //   width: MediaQuery.of(context).size.width/2,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: <Widget>[
            //       IconButton(
            //         icon: Icon(
            //           Icons.notifications,
            //           color: Colors.white
            //         ),
            //         onPressed: (){},
            //       ),
            //       IconButton(
            //         icon: Icon(
            //           Icons.person,
            //           color: Colors.white
            //          ),
            //         onPressed: (){},
            //       ),
            //     ],
            //   ),
            // ),
           ],
         ),
       ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {

//   List<CameraDescription> cameras;
//   CameraController controller;
//   // CameraController _camera;
//   // CameraLensDirection _direction = CameraLensDirection.back;

//   @override
//   void initState() {
//     super.initState();
//     _initializePage();
//   }

//   void _initializePage() async {
//     cameras=await availableCameras();
//     controller = CameraController(cameras[0], ResolutionPreset.medium);
//     print("1");
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//     print("2");
//       controller.startImageStream((CameraImage availableImage) {
//         controller.stopImageStream();
//         // _scanText(availableImage);
//         print(availableImage.runtimeType);
//       });

//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void cameraBytesToDetector({@required CameraController camera}){
//     camera.startImageStream( (image) {
//       // do something with the image stream here
//       print(image.runtimeType);
//       print(image);
//     });
//   }

//   Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
//     return await availableCameras().then(
//       (List<CameraDescription> cameras) => cameras.firstWhere(
//             (CameraDescription camera) => camera.lensDirection == dir,
//           ),
//     );
//   }

//   // void _initializeCamera() async {
//   //   print("1");
//   //   _camera = CameraController(
//   //     await _getCamera(_direction),
//   //     defaultTargetPlatform == TargetPlatform.iOS
//   //         ? ResolutionPreset.low
//   //         : ResolutionPreset.medium,
//   //   );
//   //   print("2");
//   //   print(_camera);
//   //   await _camera.initialize();
//   //   print("3");
//   //   controller.startImageStream((CameraImage image) {
//   //     print(image.runtimeType);
//   //     print(image);
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // actions: <Widget>[],
//         centerTitle: true,
//         title: Text("HomePage"),
//       ),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             FlatButton(
//               onPressed: (){
//                 // cameraBytesToDetector(camera: null);
//                 // _initializeCamera();
//               },
//               child: Text("Start"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends State<HomePage> {
//   dynamic _scanResults;
//   CameraController _camera;

//   bool _isDetecting = false;
//   CameraLensDirection _direction = CameraLensDirection.back;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
//     // print("1.1");
//     return await availableCameras().then(
//       (List<CameraDescription> cameras) => cameras.firstWhere(
//             (CameraDescription camera) => camera.lensDirection == dir,
//           ),
//     );
//   }

//   void _initializeCamera() async {
//     // print("1");
//     _camera = CameraController(
//       await _getCamera(_direction),
//       defaultTargetPlatform == TargetPlatform.iOS
//           ? ResolutionPreset.low
//           : ResolutionPreset.medium,
//     );
//     // print("2");
//     // print(_isDetecting);
//     print("0.1");
//     await _camera.initialize();
//     print("0.5");
//     _camera.startImageStream((CameraImage image) {
//       print("1");
//       if (_isDetecting) return;
//       print("2");
//       _isDetecting = true;
//       print("3");
//       try {
//         // await doSomethingWith(image)
//         print("Here!");
//         print(image.runtimeType);
//       } catch (e) {
//         print("Error!....$e");
//         // await handleExepction(e)
//       } finally {
//         _isDetecting = false;
//       }
//     });
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Somethign"),
//       ),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             Text("Something"),
//             FlatButton(
//               child: Text("Something"),
//               onPressed: (){
//                 setState(() {
//                   _isDetecting=true;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }