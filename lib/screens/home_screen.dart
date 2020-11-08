import 'dart:io';

import 'package:assignment/screens/login_screen.dart';
import 'package:assignment/widgets/player.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../firebase/auth.dart' as auth;

class HomeScreen extends StatelessWidget {
  final List<String> sampleVideoUrlList = [
    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
     "https://mazwai.com/download_new.php?hash=a8f520e4d42349b0459575952fc9efd1",
    "https://mazwai.com/download_new.php?hash=0dc29ec7fdfe2b01e13e52ba26b414d7",
    "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4?_=1",
    'https://content.videvo.net/videvo_files/video/free/2014-12/originalContent/Raindrops_Videvo.mp4',
    
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Hi, ",
                        style: TextStyle(color: Colors.grey, fontSize: 30)),
                    TextSpan(
                        text: "${auth.currentUserName.split(" ")[0]}",
                        style: TextStyle(color: Colors.black, fontSize: 30)),
                  ]),
                ), //          "Hi, ${auth.currentUserName.split(" ")[0]}",style: TextStyle(fontSize: 30),),
                Container(
                    height: 50,
                    width: 50,
                    child: ClipOval(
                      child: Image.network(auth.currentUserImgUrl),
                    )),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: FlatButton(
              child: Text("Logout"),
              onPressed: () {
                auth.signOutGoogle().then((d){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context)=>LoginScreen())
                );
              }
              );
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          _tag("Network Videos"),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView(
                  children: sampleVideoUrlList.map((url) {
            final String name =
                "Sample Video ${sampleVideoUrlList.indexOf(url)}";
            return Column(
              children: [
                ListTile(
                  leading: Icon(Icons.ondemand_video_rounded),
                  title: Text(
                    name,
                  ),
                  onTap: () {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeLeft,
                      DeviceOrientation.landscapeRight
                    ]);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Player(url,name);
                    }));
                  },
                ),
                Divider(height: 2,),
              ],
            );
          }).toList())),
        ]),
      ),
    );
  }

  Widget _tag(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      alignment: Alignment.centerLeft,
    );
  }
}
