import 'package:assignment/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../firebase/auth.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Welcome!", style: TextStyle(fontSize: 40)),
              OutlineButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                borderSide: BorderSide(color: Colors.black),
                child: Container(
                  width: 220,
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/google_logo.png",
                        height: 25,
                      ),
                      Text(
                        "Sign in with google",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  googleSignIn(context).then((status) {
                    if (status) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    }
                  });
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
