import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

String currentUserName;
String currentUserImgUrl;
String currentUserId;
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<String> googleSignIn(BuildContext context) async {
  final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final User currentUser = _auth.currentUser;
  assert(user.uid == currentUser.uid);
  currentUserName = user.displayName;
  currentUserImgUrl = user.photoURL;
  currentUserId = currentUser.uid;
  print(
      "Name:${user.displayName} Email:${user.email} Phone:${user.phoneNumber}");

  return 'signInWithGoogle succeeded: $user';
}

bool isLoggedin() {
  if (FirebaseAuth.instance.currentUser != null) {
    final User user = FirebaseAuth.instance.currentUser;
    print("${user.displayName}");
    currentUserName = user.displayName;
    currentUserImgUrl = user.photoURL;
    currentUserId = user.uid;
    return true;
  } else {
    print("not Logged in");
    return false;
  }
}

Future<bool> signOutGoogle() async {
  await _googleSignIn.signOut();
  await _auth.signOut();
  return true;
}
